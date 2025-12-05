import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _itemControllers = [];

  @override
  void initState() {
    super.initState();
    _addNewItem();
  }

  void _addNewItem() {
    setState(() => _itemControllers.add(TextEditingController()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New List"),
        leading: IconButton(
          icon: const Icon(Icons.close), 
          onPressed: () => context.pop(), 
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: _saveList,
              style: TextButton.styleFrom(backgroundColor: AppTheme.secondary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20)),
              child: const Text("Save"),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark),
              decoration: const InputDecoration(
                hintText: 'List Title',
                border: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const Divider(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _itemControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        const Icon(Icons.circle_outlined, color: Colors.grey, size: 16),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _itemControllers[index],
                            decoration: const InputDecoration(
                              hintText: 'List item...',
                              border: InputBorder.none,
                              filled: false,
                              isDense: true,
                            ),
                          ),
                        ),
                        if (_itemControllers.length > 1)
                          IconButton(
                            icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                            onPressed: () => setState(() => _itemControllers.removeAt(index)),
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: _addNewItem,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3), style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppTheme.textDark),
                    SizedBox(width: 8),
                    Text("Add Item", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _titleController.text.isNotEmpty) {
      List<Map<String, dynamic>> items = [];
      for (var controller in _itemControllers) {
        if (controller.text.trim().isNotEmpty) {
          items.add({'task': controller.text.trim(), 'done': false});
        }
      }
      await FirebaseFirestore.instance.collection('lists').add({
        'title': _titleController.text,
        'items': items,
        'ownerId': user.uid,
        'ownerEmail': user.email,
        'sharedWith': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (context.mounted) context.pop();
    }
  }
}
