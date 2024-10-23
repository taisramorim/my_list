import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_list/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:my_list/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:my_list/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:my_list/screens/home/home_screen.dart';
import 'package:my_list/screens/authentication/welcome_page.dart';
class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Tarefas',
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return MultiBlocProvider(providers: [
              BlocProvider(
                create: (context) => SignInBloc(
                  userRepository: context.read<AuthenticationBloc>().userRepository
                  ),
              ),
              BlocProvider(create: (context) => MyUserBloc(
                myUserRepository: context.read<AuthenticationBloc>().userRepository
                )..add(GetMyUser(
                  myUserId: context.read<AuthenticationBloc>().state.user!.uid
                )),
              ),
            ], child: HomeScreen());
          } else {
            return const WelcomePage();
          }
        },
      ) ,
    );
  }
}