import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_list/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:my_list/blocs/task_bloc/task_bloc.dart';
import 'package:my_list/screens/authentication/welcome_page.dart';
import 'package:my_list/screens/task/task_list.dart';
import 'package:my_list/services/motivational_repository.dart';
import 'package:task_repository/task_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _motivationalQuote = 'Carregando...';

  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  Future<void> _loadQuote() async {
    try {
      final quote = await MotivationalQuoteRepository().fetchQuote();
      setState(() {
        _motivationalQuote = quote;
      });
    } catch (e) {
      setState(() {
        _motivationalQuote = 'Erro ao carregar frase: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<SignInBloc>(context).add(SignOutRequired());
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomePage()));
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => TaskBloc(FirebaseTaskRepository())..add(LoadTasks()),
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TaskLoadSuccess) {
              final totalTasks = state.tasks.length;
              final completedTasks = state.tasks.where((task) => task.isCompleted).length;
              final pendingTasks = totalTasks - completedTasks;

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _motivationalQuote,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'You have ',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: '$pendingTasks',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal,fontSize: 18),
                            ),
                            TextSpan(
                              text: ' pending tasks and ',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: '$completedTasks',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal,fontSize: 18),
                            ),
                            TextSpan(
                              text: ' completed tasks.',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TaskListScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text('Ver Lista de Tarefas', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Erro ao carregar tarefas.'));
            }
          },
        ),
      ),
    );
  }
}

