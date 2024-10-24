import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_list/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:my_list/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:my_list/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:my_list/screens/authentication/welcome_page.dart';
import 'package:my_list/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SignInBloc(
                      userRepository:
                          context.read<AuthenticationBloc>().userRepository,
                    ),
                  ),                  
                  BlocProvider(
                    create: (context) => MyUserBloc(
                      myUserRepository:
                          context.read<AuthenticationBloc>().userRepository,
                    )..add(GetMyUser(
                        myUserId:
                            context.read<AuthenticationBloc>().state.user!.uid,
                      )),
                  ),
                ],
                child: HomeScreen(),
              );
            } else {
              return const WelcomePage();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}