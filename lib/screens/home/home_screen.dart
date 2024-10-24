import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
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
  String _motivationalQuote = 'Loading...';
  String _userName = ''; 
  String _userId = ''; 

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        _fetchUserName(),
        MotivationalQuoteRepository().fetchQuote(),
      ]);

      setState(() {
        _userName = results[0]; 
        _motivationalQuote = results[1]; 
      });
    } catch (e) {
      setState(() {
        _motivationalQuote = 'Erro: $e';
      });
    }
  }

  Future<String> _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser; 
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      _userId = user.uid; 
      return userDoc['name'] ?? 'User'; 
    }
    return 'User';
  }

  void _refreshQuote() {
    setState(() {
      _motivationalQuote = 'Loading...';
    });
    _loadData(); 
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
        create: (context) => TaskBloc(FirebaseTaskRepository(), _userId)..add(LoadTasks()), 
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
                    Center(
                      child: Text(
                        DateFormat('EEEE, d MMMM').format(DateTime.now()),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '👋 Hello, $_userName!',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              _motivationalQuote,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              '📝 Your Task Status',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'You have:',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '$pendingTasks Pending Tasks',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                            ),
                            Text(
                              '$completedTasks Completed Tasks',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
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
                      child: Text('See Your Tasks', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Erro ao carregar as tarefas.'));
            }
          },
        ),
      ),
    );
  }
}
