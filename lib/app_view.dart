import 'package:flutter/material.dart';
import 'package:my_list/screens/splash_screen.dart';
class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Tarefas',
      home: const SplashScreen()
    );
  }
}