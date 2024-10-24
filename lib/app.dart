import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_list/app_view.dart';
import 'package:my_list/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:my_list/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:my_list/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:my_list/blocs/task_bloc/task_bloc.dart';
import 'package:task_repository/task_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainApp extends StatelessWidget {
  final UserRepository userRepository;

  const MainApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(
            myUserRepository: userRepository,
          ),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => userRepository,
        ),
        RepositoryProvider<FirebaseTaskRepository>(
          create: (_) => FirebaseTaskRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SignInBloc>(
            create: (context) => SignInBloc(
              userRepository: context.read<AuthenticationBloc>().userRepository,
            ),
          ),
          BlocProvider<SignUpBloc>(
            create: (context) => SignUpBloc(
              userRepository: context.read<AuthenticationBloc>().userRepository,
            ),
          ),
          BlocProvider<TaskBloc>(
            create: (context) {
              final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
              return TaskBloc(FirebaseTaskRepository(), userId);
            },
          ),
        ],
        child: const MyAppView(),
      ),
    );
  }
}
