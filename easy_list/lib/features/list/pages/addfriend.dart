import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({super.key});

  @override
  State<AddFriendPage> createState() => _AddFriendPage();
}

class _AddFriendPage extends State<AddFriendPage> {
  String _searchEmail = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
        title: TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Add friend by email...',
            prefixIcon: const Icon(Icons.person_add),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send, color: Colors.blue),
              onPressed: _sendRequest,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
          ),
          onChanged: (val) => _searchEmail = val,
          onSubmitted: (val) => _sendRequest(),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists || snapshot.data!.data() == null) {
            return const Center(child: Text("User profile not found."));
          }
          
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final List friends = userData['friends'] ?? [];
          final List requests = userData['friendRequestsReceived'] ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // friend request section
              if (requests.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(16.0), 
                  child: Text("Friend Requests", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final senderUid = requests[index];
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(senderUid).get(),
                      builder: (context, senderSnap) {
                        if (!senderSnap.hasData) return const LinearProgressIndicator();
                        if (!senderSnap.data!.exists) return const SizedBox.shrink();

                        final senderData = senderSnap.data!.data() as Map<String, dynamic>;
                        return ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(senderData['username'] ?? 'Unknown'),
                          subtitle: Text(senderData['email'] ?? ''),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                            onPressed: () => _acceptRequest(currentUser.uid, senderUid),
                            child: const Text("Accept"),
                          ),
                        );
                      }
                    );
                  },
                ),
                const Divider(thickness: 1),
              ],

              // friends section
              const Padding(
                  padding: EdgeInsets.all(16.0), 
                  child: Text("My Friends", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
              ),
              Expanded(
                child: friends.isEmpty 
                ? const Center(child: Text("No friends yet."))
                : ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friendUid = friends[index];
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(friendUid).get(),
                      builder: (context, friendSnap) {
                        if (!friendSnap.hasData) return const SizedBox.shrink();
                        if (!friendSnap.data!.exists) return const SizedBox.shrink();

                        final friendData = friendSnap.data!.data() as Map<String, dynamic>;
                        final username = friendData['username'] ?? 'Unknown';
                        final email = friendData['email'] ?? '';

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green[100],
                              child: Text(username.isNotEmpty ? username[0].toUpperCase() : "?", style: const TextStyle(color: Colors.green)),
                            ),
                            title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(email),
                            trailing: IconButton(
                              icon: const Icon(Icons.person_remove_outlined, color: Colors.red),
                              // PASSING EMAIL HERE SO WE CAN CLEAN UP LISTS
                              onPressed: () => _showUnfriendDialog(context, currentUser.uid, friendUid, username, email),
                            ),
                          ),
                        );
                      }
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showUnfriendDialog(BuildContext context, String myUid, String friendUid, String friendName, String friendEmail) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Unfriend"),
          content: Text("Remove $friendName? They will lose access to any lists you shared with them."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _removeFriend(myUid, friendUid, friendEmail);
                Navigator.pop(context);
              },
              child: const Text("Remove", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      }
    );
  }

  Future<void> _removeFriend(String myUid, String friendUid, String friendEmail) async {
    try {
      // Remove from Users collection
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(FirebaseFirestore.instance.collection('users').doc(myUid), {
          'friends': FieldValue.arrayRemove([friendUid])
        });
        transaction.update(FirebaseFirestore.instance.collection('users').doc(friendUid), {
          'friends': FieldValue.arrayRemove([myUid])
        });
      });

      // Remove their email from YOUR Shared lists
      final myListsSnapshot = await FirebaseFirestore.instance
          .collection('lists')
          .where('ownerId', isEqualTo: myUid)
          .where('sharedWith', arrayContains: friendEmail)
          .get();

      final batch = FirebaseFirestore.instance.batch();
      
      for (var doc in myListsSnapshot.docs) {
        batch.update(doc.reference, {
          'sharedWith': FieldValue.arrayRemove([friendEmail])
        });
      }
      
      await batch.commit();

      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Friend removed and access revoked.")));
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to unfriend.")));
    }
  }

  Future<void> _sendRequest() async {
    FocusScope.of(context).unfocus();
    final currentUser = FirebaseAuth.instance.currentUser;
    if(_searchEmail.isEmpty || currentUser == null) return;
    
    final emailToFind = _searchEmail.trim().toLowerCase();

    if(emailToFind == currentUser.email) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You cannot add yourself.")));
       return;
    }

    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: emailToFind)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final targetUserDoc = query.docs.first;
        final targetData = targetUserDoc.data();
        final requests = targetData['friendRequestsReceived'] ?? [];
        final friends = targetData['friends'] ?? [];

        if (requests.contains(currentUser.uid) || friends.contains(currentUser.uid)) {
           if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Already friends or request sent.")));
           return;
        }

        await targetUserDoc.reference.update({
          'friendRequestsReceived': FieldValue.arrayUnion([currentUser.uid])
        });
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
          'friendRequestsSent': FieldValue.arrayUnion([targetUserDoc.id])
        });
        
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Request sent!")));
          _searchController.clear();
          setState(() => _searchEmail = "");
        }
      } else {
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User not found")));
      }
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _acceptRequest(String myUid, String senderUid) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(FirebaseFirestore.instance.collection('users').doc(myUid), {
          'friendRequestsReceived': FieldValue.arrayRemove([senderUid]),
          'friends': FieldValue.arrayUnion([senderUid])
        });
         transaction.update(FirebaseFirestore.instance.collection('users').doc(senderUid), {
          'friendRequestsSent': FieldValue.arrayRemove([myUid]),
          'friends': FieldValue.arrayUnion([myUid])
        });
      });
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to accept request.")));
    }
  }
}