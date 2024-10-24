import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_list/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:my_list/screens/authentication/forgot_password.dart';
import 'package:my_list/screens/home/home_screen.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? _errorMsg;
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false, 
        );
        } else if (state is SignInFailure) {
          setState(() {
            _errorMsg = 'Name or Password invalid';
          });
        }
      },
      child: Scaffold(
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
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField(
                              context,
                              controller: emailController,
                              hintText: 'Email',
                              icon: Icons.email,
                              keyboardType: TextInputType.name,
                              errorMsg: _errorMsg,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Por favor, preencha este campo';
                                }
                                return null;
                              }
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              context,
                              controller: passwordController,
                              hintText: 'Password',
                              icon: Icons.lock,
                              obscureText: obscurePassword,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Por favor, preencha este campo';
                                } 
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            BlocBuilder<SignInBloc, SignInState>(
                              builder: (context, state) {
                                if (state is SignInProcess) {
                                  return const CircularProgressIndicator(
                                    color: Colors.white,
                                  );
                                }
                                return _buildActionButton(
                                  context,
                                  label: "Enter",
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<SignInBloc>().add(SignInRequired(
                                        emailController.text,
                                        passwordController.text,
                                      ));
                                    }
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ForgotPassword(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Forgot Passowrd?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? errorMsg,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        errorText: errorMsg,
      ),
      validator: validator,
    );
  }

  Widget _buildActionButton(BuildContext context, {required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.teal,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}