import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SharePage extends StatefulWidget {
  final List<Map<String, String>> localNotes;

  const SharePage({super.key, required this.localNotes});

  @override
  State<SharePage> createState() => _SharePage();
}

class _SharePage extends State<SharePage> {
  List<bool> _selected_friends = [false, false, false, false]; 
  List<bool> _selected_notes = [];

  @override
  Widget build(BuildContext context) {
    final notes = widget.localNotes;

    if (_selected_notes.length != notes.length) {
      _selected_notes = List<bool>.filled(notes.length, false);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Text(
            '<',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          onPressed: () => context.go('/home'),
        ),
        title: SizedBox(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search friend..',
              hintStyle: const TextStyle(color: Colors.black54),
              prefixIcon: const Icon(Icons.search, color: Colors.black54),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ) ,
            ),
            onChanged: (value) {
              
            },
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...List.generate(_selected_friends.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selected_friends[index] = !_selected_friends[index];
                    });
                  },
                  child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _selected_friends[index] ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Friend ${index + 1}',
                      style: TextStyle(
                        color: _selected_friends[index] ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selected_notes[index] = !_selected_notes[index];
                        });
                      },
                      child: Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: _selected_notes[index] ? Colors.green : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              note['title'] ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _selected_notes[index] ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              note['content'] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: _selected_notes[index] ? Colors.white : Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Text(
                    'Share',            
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  

                  onPressed: () async {
                    List<int> selectedFriendIndexes = [];
                    for (int i = 0; i < _selected_friends.length; i++) {
                      if (_selected_friends[i]) selectedFriendIndexes.add(i);
                    }

                    List<int> selectedNoteIndexes = [];
                    for (int i = 0; i < _selected_notes.length; i++) {
                      if (_selected_notes[i]) selectedNoteIndexes.add(i);
                    }

                    if (selectedFriendIndexes.isEmpty || selectedNoteIndexes.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select friends and notes')),
                      );
                      return;
                    }

                    try {
                      for (int noteIdx in selectedNoteIndexes) {
                        final note = widget.localNotes[noteIdx];
                        final noteId = note['title'] ?? '';

                        if (noteId.isEmpty) continue; 

                        await FirebaseFirestore.instance
                            .collection('notes')
                            .doc(noteId)
                            .update({
                            'sharedWith': FieldValue.arrayUnion(
                            selectedFriendIndexes.map((i) => 'friend_$i').toList(),
                          ),
                        });
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Shared successfully!')),
                      );
                      context.go('/home');

                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to share: $e')),
                      );
                    }
                  },



                ), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}

