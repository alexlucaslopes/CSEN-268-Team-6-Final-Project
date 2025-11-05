import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'list_details.dart';

void main() {
  runApp(const EasyListerApp());
}

class EasyListerApp extends StatelessWidget {
  const EasyListerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const WelcomePage(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        // list details
        GoRoute(
          path: '/list/:listName',
          builder: (context, state) {
            final listName = state.pathParameters['listName']!;
            return ListDetailsScreen(listName: listName);
          },
        ),
        GoRoute(
          path: '/addnote', 
          builder: (context, state) => const AddNotePage()),
        GoRoute(
          path: '/share', 
          builder: (context, state) => const SharePage()),
        GoRoute(
          path: '/addfriend', 
          builder: (context, state) => const AddFriendPage()),
        GoRoute(
          path: '/print', 
          builder: (context, state) => const PrintPage()),
      ],
    );

    return MaterialApp.router(
      title: 'EasyLister',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

// ------------------ WELCOME PAGE ------------------

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to EasyLister!!!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildButton(
                label: 'Get Started',
                onPressed: () => context.go('/signup'),
              ),
              const SizedBox(height: 20),
              _buildButton(
                label: 'Log In',
                onPressed: () => context.go('/login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade500,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

// ------------------ SIGN UP PAGE ------------------

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const Icon(Icons.person, size: 100, color: Colors.black54),
              const SizedBox(height: 40),
              _buildTextField('username', controller: usernameController),
              const SizedBox(height: 15),
              _buildTextField('email', controller: emailController),
              const SizedBox(height: 15),
              _buildTextField('password', controller: passwordController, obscure: true),
              const SizedBox(height: 30),
              _buildButton(
                label: 'Sign Up',
                onPressed: () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint,
      {required TextEditingController controller, bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blue.shade100,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildButton({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade500,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

// ------------------ LOGIN PAGE ------------------

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              _buildTextField('username or email', controller: emailController),
              const SizedBox(height: 15),
              _buildTextField('password', controller: passwordController, obscure: true),
              const SizedBox(height: 30),
              _buildButton(
                label: 'Login',
                onPressed: () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint,
      {required TextEditingController controller, bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blue.shade100,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildButton({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade500,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

// ------------------ HOME PAGE ------------------

/*
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Text(
          'Welcome to EasyLister!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
*/


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, String>> notes = const [
    {'title': 'My List', 'content': 'description'}
  ];

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {
              
            },
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
                  return Card(
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
  }
}

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}


class _AddNotePageState extends State<AddNotePage> {
  final FocusNode _titleFocusNode = FocusNode(); 
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          FocusScope.of(context).requestFocus(_titleFocusNode);
        }
      });
    });
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
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
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Title',
                ),
                maxLines: null,
                focusNode: _titleFocusNode,
              ),
            ),
            const SizedBox(height: 4), 
            SizedBox(
              height: 80,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'content',
                ),
                maxLines: null,
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
                    'Confirm',            
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  onPressed: () => context.go('/home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SharePage extends StatefulWidget {
  const SharePage({super.key});

  @override
  State<SharePage> createState() => _SharePage();
}

class _SharePage extends State<SharePage> {
  List<bool> _selected_friends = [false, false, false, false]; 

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
          children: List.generate(_selected_friends.length, (index) {
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
                  child: 
                    Text(
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
                  onPressed: () => context.go('/home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class AddFriendPage extends StatefulWidget {
  const AddFriendPage({super.key});

  @override
  State<AddFriendPage> createState() => _AddFriendPage();
}


class _AddFriendPage extends State<AddFriendPage> {
  List<bool> _new_friends = [false, false, false, false, false, false];
  List<String> _invited_friends = ['Friend A', 'Friend B', 'Friend C', 'Friend D', 'Friend E', 'Friend F'];


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
        title: SizedBox(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Add new friends..',
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

      
      body: Column(
        children: [
          
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Results', 
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _new_friends.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _new_friends[index] = !_new_friends[index];
                            });
                          },
                          child: Container(
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _new_friends[index] ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Friend ${index + 1}',
                              style: TextStyle(
                                color: _new_friends[index] ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
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

          const Divider(height: 1, color: Colors.black),

          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "Friends you're inviting", 
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              
                Expanded(
                  flex: 1, 
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _invited_friends.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          height: 60,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _invited_friends[index],
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.normal,
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
        ],
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
                    'Add',            
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  onPressed: () => context.go('/home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class PrintPage extends StatelessWidget {
  const PrintPage({super.key});
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
    );
  }
}






