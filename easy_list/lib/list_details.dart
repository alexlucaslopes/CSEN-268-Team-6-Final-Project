import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListDetailsScreen extends StatelessWidget {
  final String listName;

  const ListDetailsScreen({super.key, required this.listName});

  // Share dialog
  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Share This List'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Username input
              Container(
                color: const Color(0xFFBBDEFB), 
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Username',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Dialog actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  // Invite button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {}, // Does nothing RN
                    child: const Text('Invite'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // overlay for viewing item's details
  void _showViewItemDialog(BuildContext context, Map<String, String> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(18),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //  container with item info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15.0),
                color: const Color(0xFFBBDEFB),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                    const SizedBox(height: 10),
                    Text(item['description']!),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Dialog actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {}, // Does nothing right now
                    child: const Text('Confirm Edit'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    //example data
    final List<Map<String, String>> items = [
      {'name': 'Milk', 'description': 'Get 2% milk.'},
      {'name': 'Bread', 'description': 'Whole wheat.'},
      {'name': 'Eggs', 'description': 'A dozen, free-range.'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            // Top buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _showShareDialog(context),
                  child: const Text('Share list'),
                ),
                TextButton(
                  onPressed: () {}, // Does nothing right now
                  child: const Text('Delete list', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // The main list container
            Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    listName,
                    style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 30.0),

                  // real list of items
                  Column(
                    children: items.map((item) {
                      return Row(
                        children: [
                          // Item name
                          Expanded(child: Text('• ${item['name']}')),
                          // View
                          TextButton(
                            onPressed: () => _showViewItemDialog(context, item),
                            child: const Text('View'),
                          ),
                          // Delete
                          IconButton(
                            onPressed: () {}, // Does nothing right now
                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 4.0),

                  // Add item button
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {}, // Does nothing right now
                      icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
