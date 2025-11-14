import 'package:easy_list/features/auth/bloc/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../auth/bloc/bloc.dart';
import '../auth/bloc/state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, String>> notes = const [
    {'title': 'My List', 'content': 'description'}
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {

        if (state is! AuthenticationAuthenticated) {
          // This is a fallback safeguard
          return const SizedBox.shrink();
        }
    
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
        
              },
            ),
            title: SizedBox(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search notes...',
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
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.account_circle, color: Colors.black),
                onSelected: (value) {
                  if (value == 'signout') {
                    context.read<AuthenticationBloc>().add(LoggedOut());
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'signout',
                    child: Text("Sign Out"),
                  ),
                ],
              ),
            ],
          ),

          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, 
                  children: [
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(20),
                      selectedColor: Colors.white,
                      fillColor: Colors.blue,
                      color: Colors.black,
                      isSelected: [true, false], 
                      onPressed: (index) {
                        
                      },
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Image.asset('assets/private.png', width: 60, height: 60),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Image.asset('assets/public.png', width: 60, height: 60),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8), 

                
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return GestureDetector(
                        onTap: () {
                          context.push('/list/${note['title']}');
                        },
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.lime,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note['title']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: Text(
                                    note['content']!,
                                    style: const TextStyle(fontSize: 14),
                                  ),
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
                      icon: Image.asset('assets/print.png', width: 60, height: 60),
                      onPressed: () => context.go('/print'),
                    ),
                  ),
                  Builder(
                    builder: (context) => IconButton(
                      icon: Image.asset('assets/person_add.png', width: 60, height: 60),
                      onPressed: () => context.go('/addfriend'),
                    ),
                  ),
                  Builder(
                    builder: (context) => IconButton(
                      icon: Image.asset('assets/share.png', width: 60, height: 60),
                      onPressed: () => context.go('/share'),
                    ),
                  ),
                  Builder(
                    builder: (context) => IconButton(
                      icon: Image.asset('assets/add_circle.png', width: 60, height: 60),
                      onPressed: () => context.go('/addnote'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}