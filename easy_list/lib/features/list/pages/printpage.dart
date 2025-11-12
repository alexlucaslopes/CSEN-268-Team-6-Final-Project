import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrintPage extends StatefulWidget {
  const PrintPage({super.key});
  @override
  State<PrintPage> createState() => _PrintPage();
}



class _PrintPage extends State<PrintPage> {
  final List<String> printers = ['Printer 1', 'Printer 2', 'Printer 3', 'Printer 4'];
  @override
  Widget build(BuildContext context) {
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
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: printers.length,
          itemBuilder: (context, index) {
            final label = printers[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final controllers = List.generate(4, (_) => TextEditingController());
                      return AlertDialog(
                        title: Text('$label'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // number
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Print Number',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      TextField(
                                        controller: controllers[0],
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: '1',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Color
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Color',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      TextField(
                                        controller: controllers[1],
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'No Color',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Size
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Size',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      TextField(
                                        controller: controllers[2],
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'A4',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Pages
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Pages',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      TextField(
                                        controller: controllers[3],
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'All',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => context.go('/home'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => context.go('/home'),
                            child: const Text('Print'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}