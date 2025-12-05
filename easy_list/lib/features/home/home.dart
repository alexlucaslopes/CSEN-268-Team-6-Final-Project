import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_list/features/auth/bloc/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../auth/bloc/bloc.dart';
import '../auth/bloc/state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; 

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is! AuthenticationAuthenticated || currentUser == null) {
          return const SizedBox.shrink();
        }

        Query<Map<String, dynamic>> notesQuery;
        if (_selectedIndex == 0) {
          notesQuery = FirebaseFirestore.instance.collection('lists').where('ownerId', isEqualTo: currentUser.uid);
        } else {
          notesQuery = FirebaseFirestore.instance.collection('lists').where('sharedWith', arrayContains: currentUser.email);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("EasyLister"),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: PopupMenuButton<String>(
                  icon: const CircleAvatar(
                    backgroundColor: AppTheme.secondary,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  onSelected: (value) {
                    if (value == 'signout') context.read<AuthenticationBloc>().add(LoggedOut());
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'profile', child: Text(currentUser.email ?? "User")),
                    const PopupMenuItem(value: 'signout', child: Text("Sign Out")),
                  ],
                ),
              ),
            ],
          ),

          body: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    _buildToggleItem("Personal", Icons.lock_outline, 0),
                    _buildToggleItem("Shared", Icons.people_outline, 1),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: notesQuery.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                    final docs = snapshot.data?.docs ?? [];
                    
                    if (docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.note_alt_outlined, size: 80, color: Colors.grey[300]),
                            const SizedBox(height: 10),
                            Text(
                              _selectedIndex == 0 ? "No personal lists" : "No lists shared with you",
                              style: TextStyle(color: Colors.grey[500], fontSize: 16)
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.80,
                      ),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        return _buildListCard(context, docs[index].id, data);
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            heroTag: 'home_fab', 
            backgroundColor: AppTheme.secondary,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.white, size: 30),
            onPressed: () => context.push('/addnote'),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            color: Colors.white,
            elevation: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.person_add_outlined), 
                  onPressed: () => context.push('/addfriend')
                ),
                const SizedBox(width: 48), 
                IconButton(
                  icon: const Icon(Icons.share_outlined), 
                  onPressed: () => context.push('/share')
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleItem(String label, IconData icon, int index) {
    final bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? AppTheme.primary : Colors.grey),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppTheme.primary : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCard(BuildContext context, String docId, Map<String, dynamic> data) {
    List<dynamic> previewItems = [];
    if (data['items'] != null && data['items'] is List) {
      previewItems = data['items'];
    }
    final String ownerEmail = data['ownerEmail'] ?? 'Unknown';

    return GestureDetector(
      onTap: () => context.push('/list/$docId'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5)),
          ],
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['title'] ?? 'No Title',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.textDark),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Container(width: 40, height: 3, color: AppTheme.secondary.withValues(alpha: 0.5)),
              const SizedBox(height: 12),
              Expanded(
                child: previewItems.isNotEmpty 
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: previewItems.take(3).map((item) {
                      final isDone = item['done'] ?? false;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          children: [
                            Icon(isDone ? Icons.check_circle : Icons.circle_outlined, size: 12, color: isDone ? Colors.grey : AppTheme.primary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item['task'] ?? '',
                                style: TextStyle(
                                  fontSize: 12, 
                                  color: isDone ? Colors.grey : AppTheme.textDark,
                                  decoration: isDone ? TextDecoration.lineThrough : null,
                                ),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                : Text("Empty list", style: TextStyle(color: Colors.grey[400], fontSize: 12, fontStyle: FontStyle.italic)),
              ),
              if(_selectedIndex == 1) 
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_outline, size: 12, color: AppTheme.secondary),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            ownerEmail, 
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.secondary),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
