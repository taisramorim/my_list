import 'package:flutter/material.dart';
import 'package:my_list/screens/authentication/sign_in_page.dart';
import 'package:my_list/screens/authentication/sign_up_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    super.initState();    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(              
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 0, 196, 176),
                  Colors.teal,
                  Color.fromARGB(255, 0, 102, 92),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: ClipOval(
                          child: Image.network(
                            'https://plus.unsplash.com/premium_photo-1681487870238-4a2dfddc6bcb?q=80&w=1160&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            width: 150, 
                            height: 150, 
                            fit: BoxFit.cover, 
                          ),
                        ),
                      ),
                      SizedBox(height: 200),
                      _buildActionButton(
                        context,
                        label: 'Sign In',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignInPage()),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildActionButton(
                        context,
                        label: 'Register',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpPage()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.08,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: Colors.white.withOpacity(0.8), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.teal,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}