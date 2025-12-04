import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SharePage extends StatefulWidget {
  const SharePage({super.key});

  @override
  State<SharePage> createState() => _SharePage();
}

class _SharePage extends State<SharePage> {
  final Set<String> _selectedFriendEmails = {};
  final Set<String> _selectedNoteIds = {};

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
           onPressed: () => context.go('/home'),
        ),
        title: const Text("Share Multiple", style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(8.0), child: Text("Select Friends")),
          SizedBox(
            height: 60,
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                if (!snapshot.data!.exists) return const SizedBox.shrink();

                final userData = snapshot.data!.data() as Map<String, dynamic>?;
                if (userData == null) return const SizedBox.shrink();

                final List friends = userData['friends'] ?? [];

                if (friends.isEmpty) return const Center(child: Text("Add friends first!"));

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(friends[index]).get(),
                      builder: (context, fSnap) {
                        if (!fSnap.hasData || fSnap.data == null) {
                          return const SizedBox(width: 50, child: Center(child: CircularProgressIndicator()));
                        }
                        
                        if (!fSnap.data!.exists) return const SizedBox.shrink();

                        final fData = fSnap.data!.data() as Map<String, dynamic>?;
                        
                        if (fData == null) return const SizedBox.shrink();

                        final email = fData['email'] ?? 'Unknown';
                        final username = fData['username'] ?? email;
                        final isSelected = _selectedFriendEmails.contains(email);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(username),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if(selected) _selectedFriendEmails.add(email);
                                else _selectedFriendEmails.remove(email);
                              });
                            },
                          ),
                        );
                      }
                    );
                  },
                );
              }
            ),
          ),

          const Divider(),

          const Padding(padding: EdgeInsets.all(8.0), child: Text("Select Lists")),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('lists')
                  .where('ownerId', isEqualTo: currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                 if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                 final docs = snapshot.data!.docs;
                 
                 return ListView.builder(
                   itemCount: docs.length,
                   itemBuilder: (context, index) {
                     final doc = docs[index];
                     final data = doc.data() as Map<String, dynamic>;
                     final isSelected = _selectedNoteIds.contains(doc.id);

                     return ListTile(
                       title: Text(data['title'] ?? 'No Title'),
                       trailing: Icon(
                         isSelected ? Icons.check_circle : Icons.circle_outlined,
                         color: isSelected ? Colors.green : Colors.grey,
                       ),
                       onTap: () {
                         setState(() {
                           if(isSelected) _selectedNoteIds.remove(doc.id);
                           else _selectedNoteIds.add(doc.id);
                         });
                       },
                     );
                   },
                 );
              }
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: const Text("SHARE SELECTED", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () async {
                if(_selectedFriendEmails.isEmpty || _selectedNoteIds.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select friends and lists first")));
                   return;
                }

                final batch = FirebaseFirestore.instance.batch();
                
                for(String noteId in _selectedNoteIds) {
                  final docRef = FirebaseFirestore.instance.collection('lists').doc(noteId);
                  batch.update(docRef, {
                    'sharedWith': FieldValue.arrayUnion(_selectedFriendEmails.toList())
                  });
                }

                await batch.commit();
                if(context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Shared successfully!")));
                  context.go('/home');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}