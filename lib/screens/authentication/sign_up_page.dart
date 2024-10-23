import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_list/screens/home/home_screen.dart';
import 'package:user_repository/user_repository.dart';
import '../../blocs/sign_up_bloc/sign_up_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final documentController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final nameController = TextEditingController();
  final recruiterIdController = TextEditingController();
  final usernameController = TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Conta criada!')),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false, // Remove todas as rotas
          );
        } else if (state is SignUpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro, tente novamente')),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Gradient Background
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
                      const SizedBox(height: 20),
                      const Text(
                        "Cadastrar",
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
                              controller: nameController,
                              hintText: 'Nome',
                              icon: Icons.person,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Por favor, preencha este campo';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              context,
                              controller: emailController,
                              hintText: 'Email',
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Por favor, preencha este campo';
                                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
                                  return 'Por favor, insira um email válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              context,
                              controller: passwordController,
                              hintText: 'Senha',
                              icon: Icons.lock,
                              obscureText: obscurePassword,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Por favor, preencha este campo';
                                } else if (val.length < 8) {
                                  return 'A senha deve ter pelo menos 8 caracteres';
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
                            const SizedBox(height: 20),
                            _buildTextField(
                              context,
                              controller: confirmpasswordController,
                              hintText: 'Confirmar Senha',
                              icon: Icons.lock,
                              obscureText: obscureConfirmPassword,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Por favor, preencha este campo';
                                } else if (val != passwordController.text) {
                                  return 'As senhas não coincidem';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscureConfirmPassword = !obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),                            
                            BlocBuilder<SignUpBloc, SignUpState>(
                              builder: (context, state) {
                                if (state is SignUpProcess) {
                                  return const CircularProgressIndicator(
                                    color: Colors.white,
                                  );
                                }

                                return _buildActionButton(
                                  context,
                                  label: "Criar Conta",
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      MyUser myUser = MyUser.empty.copyWith(
                                        email: emailController.text,
                                        name: nameController.text,
                                      );
                                      context.read<SignUpBloc>().add(
                                            SignUpRequired(
                                              myUser,
                                              passwordController.text,
                                            ),
                                      );
                                    }
                                  },
                                );
                              },
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
        errorStyle: const TextStyle(color: Colors.redAccent),
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
            color:  Color(0xFF7B4397),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}