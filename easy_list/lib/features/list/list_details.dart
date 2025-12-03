import 'dart:async'; // StreamSubscription
import 'dart:math';  // Calculate shake amount
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sensors_plus/sensors_plus.dart'; // Sensor package

class ListDetailsScreen extends StatefulWidget {
  final String listName;

  const ListDetailsScreen({super.key, required this.listName});

  @override
  State<ListDetailsScreen> createState() => _ListDetailsScreenState();
}

class _ListDetailsScreenState extends State<ListDetailsScreen> {
  List<Map<String, String>> items = [
    {'name': 'Milk', 'description': 'Get 2% milk.'},
    {'name': 'Bread', 'description': 'Whole wheat.'},
    {'name': 'Eggs', 'description': 'A dozen, free-range.'},
  ];

  StreamSubscription? _accelerometerSubscription;
  DateTime? _lastShakeTime;

  @override
  void initState() {
    super.initState();
    _startListeningToShake();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  void _startListeningToShake() {
    // Listen to accelerometer events
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      double acceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      if (acceleration > 25) {
        final now = DateTime.now();
        // Simple debounce to prevent triggering 10 times in 1 second
        if (_lastShakeTime == null || 
            now.difference(_lastShakeTime!) > const Duration(seconds: 1)) {
          _lastShakeTime = now;
          _clearList();
        }
      }
    });
  }

  void _clearList() {
    if (items.isNotEmpty) {
      setState(() {
        items.clear();
      });
      
      // Optional: Give user feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("List cleared by shaking!"),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {}, 
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {}, 
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                  onPressed: () {}, 
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
                    widget.listName, // Use widget.listName because we are in State class
                    style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 30.0),

                  // Real list of items
                  // We check if items is empty to show a placeholder or the list
                  items.isEmpty 
                  ? const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: Text("List cleared! Shake to clear again?")),
                    )
                  : Column(
                    children: items.map((item) {
                      return Row(
                        children: [
                          Expanded(child: Text('• ${item['name']}')),
                          TextButton(
                            onPressed: () => _showViewItemDialog(context, item),
                            child: const Text('View'),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                items.remove(item);
                              });
                            }, 
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
                      onPressed: () {
                        // Logic to add item
                      }, 
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
