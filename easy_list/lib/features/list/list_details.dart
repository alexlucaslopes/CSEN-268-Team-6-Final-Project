import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../app/theme.dart';

class ListDetailsScreen extends StatefulWidget {
  final String listName; 
  const ListDetailsScreen({super.key, required this.listName});

  @override
  State<ListDetailsScreen> createState() => _ListDetailsScreenState();
}

class _ListDetailsScreenState extends State<ListDetailsScreen> {
  StreamSubscription? _accelerometerSubscription;
  DateTime? _lastShakeTime;
  final TextEditingController _newItemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startListeningToShake();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _newItemController.dispose();
    super.dispose();
  }

  void _startListeningToShake() {
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      double acceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (acceleration > 25) {
        final now = DateTime.now();
        if (_lastShakeTime == null || now.difference(_lastShakeTime!) > const Duration(seconds: 1)) {
          _lastShakeTime = now;
          _clearAllItems();
        }
      }
    });
  }

  Future<void> _clearAllItems() async {
    await FirebaseFirestore.instance.collection('lists').doc(widget.listName).update({'items': []});
    if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("List cleared!")));
  }

  Future<void> _toggleItem(List<dynamic> currentItems, int index) async {
    List<dynamic> updatedItems = List.from(currentItems);
    Map<String, dynamic> item = Map<String, dynamic>.from(updatedItems[index]);
    item['done'] = !item['done'];
    updatedItems[index] = item;
    await FirebaseFirestore.instance.collection('lists').doc(widget.listName).update({'items': updatedItems});
  }

  Future<void> _deleteItem(List<dynamic> currentItems, int index) async {
    List<dynamic> updatedItems = List.from(currentItems);
    updatedItems.removeAt(index);
    await FirebaseFirestore.instance.collection('lists').doc(widget.listName).update({'items': updatedItems});
  }

  Future<void> _editItem(List<dynamic> currentItems, int index, String newText) async {
    List<dynamic> updatedItems = List.from(currentItems);
    Map<String, dynamic> item = Map<String, dynamic>.from(updatedItems[index]);
    item['task'] = newText;
    updatedItems[index] = item;
    await FirebaseFirestore.instance.collection('lists').doc(widget.listName).update({'items': updatedItems});
  }

  Future<void> _addNewItem(List<dynamic> currentItems) async {
    if (_newItemController.text.trim().isEmpty) return;
    List<dynamic> updatedItems = List.from(currentItems);
    updatedItems.add({'task': _newItemController.text.trim(), 'done': false});
    await FirebaseFirestore.instance.collection('lists').doc(widget.listName).update({'items': updatedItems});
    _newItemController.clear();
  }

  void _showEditItemDialog(BuildContext context, List<dynamic> currentItems, int index, String currentText) {
    final controller = TextEditingController(text: currentText);
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Edit Item"),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              _editItem(currentItems, index, controller.text.trim());
              Navigator.pop(context);
            }
          }, child: const Text("Save"))
        ],
      );
    });
  }
  
  void _showShareDialog(BuildContext context) {
    String inviteEmail = "";
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text('Share List'),
        content: TextField(
          decoration: const InputDecoration(hintText: "Enter friend's email"),
          onChanged: (val) => inviteEmail = val,
        ),
        actions: [
          TextButton(onPressed: () async {
            if(inviteEmail.isNotEmpty) {
              await FirebaseFirestore.instance.collection('lists').doc(widget.listName).update({
                'sharedWith': FieldValue.arrayUnion([inviteEmail.trim().toLowerCase()])
              });
              if(context.mounted) {
                 Navigator.pop(context);
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invited!")));
              }
            }
          }, child: const Text("Invite"))
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('lists').doc(widget.listName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        if (!snapshot.data!.exists) return const Scaffold(body: Center(child: Text("List deleted")));

        final data = snapshot.data!.data() as Map<String, dynamic>;
        List<dynamic> items = data['items'] ?? [];
        if (items.isEmpty && data['content'] != null && data['content'].toString().isNotEmpty) {
           items = [{'task': data['content'], 'done': false}];
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(data['title'] ?? 'List'),
            actions: [
              IconButton(icon: const Icon(Icons.person_add_outlined), onPressed: () => _showShareDialog(context)),
              PopupMenuButton<String>(
                onSelected: (val) async {
                  if(val == 'delete') {
                    await FirebaseFirestore.instance.collection('lists').doc(widget.listName).delete();
                    if(context.mounted) context.pop();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'delete', child: Text("Delete List", style: TextStyle(color: Colors.red))),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: items.isEmpty 
                  ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.checklist, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text("Shake to clear completed items!", style: TextStyle(color: Colors.grey[400]))
                    ]))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (c,i) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = items[index] as Map<String, dynamic>;
                        final bool isDone = item['done'] ?? false;
                        final String task = item['task'] ?? '';

                        return Dismissible(
                          key: Key(task + index.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (_) => _deleteItem(items, index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                            ),
                            child: ListTile(
                              leading: GestureDetector(
                                onTap: () => _toggleItem(items, index),
                                child: Container(
                                  width: 24, height: 24,
                                  decoration: BoxDecoration(
                                    color: isDone ? AppTheme.primary : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: isDone ? AppTheme.primary : Colors.grey),
                                  ),
                                  child: isDone ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                                ),
                              ),
                              title: Text(task, style: TextStyle(
                                fontSize: 16,
                                decoration: isDone ? TextDecoration.lineThrough : null,
                                color: isDone ? Colors.grey : AppTheme.textDark,
                              )),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                onPressed: () => _showEditItemDialog(context, items, index, task),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              ),
              
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newItemController,
                        decoration: InputDecoration(
                          hintText: 'Add a new task...',
                          fillColor: AppTheme.background,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FloatingActionButton.small(
                      backgroundColor: AppTheme.secondary,
                      elevation: 0,
                      onPressed: () => _addNewItem(items),
                      child: const Icon(Icons.arrow_upward, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}