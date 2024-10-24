import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:my_list/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:my_list/blocs/task_bloc/task_bloc.dart';
import 'package:my_list/screens/authentication/welcome_page.dart';
import 'package:my_list/screens/task/task_list.dart';
import 'package:my_list/screens/weather/weather_screen.dart'; 
import 'package:my_list/services/motivational_repository.dart';
import 'package:my_list/services/weather_service.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _motivationalQuote = '';
  String _userName = ''; 
  bool _isLoading = true;
  String _weatherDescription = '';
  double _temperature = 0.0; 
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    _loadData();
    _fetchWeather("Vila Velha");
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
        _isLoading = false; 
      });

      BlocProvider.of<TaskBloc>(context).add(LoadTasks());
    } catch (e) {
      setState(() {
        _motivationalQuote = 'Erro: $e';
        _isLoading = false;
      });
    }
  }

  Future<String> _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return userDoc['name'] ?? 'Usuário';
    }
    return 'Usuário';
  }

  Future<void> _fetchWeather(String city) async {
    try {
      final weatherService = WeatherService();
      final data = await weatherService.fetchWeather(city);
      setState(() {
        _weatherData = data;
        _temperature = data['main']['temp']; // Armazena a temperatura
        _weatherDescription = data['weather'][0]['description']; // Armazena a descrição do clima
      });
    } catch (e) {
      log('Erro ao buscar clima: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo(a)', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : BlocBuilder<TaskBloc, TaskState>(
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
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            '👋 Olá, $_userName!',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                        ),
                        SizedBox(height: 15),
                        Center(
                          child: Text(
                            DateFormat('EEEE, d MMMM').format(DateTime.now()),
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WeatherScreen()), 
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Text(
                                    '🌤️ Previsão do Clima',
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Temperatura: ${_temperature.toStringAsFixed(1)} °C',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'Condições: $_weatherDescription',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TaskListScreen()), 
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [                           
                                  Text(
                                    '📝 Status das suas Tarefas',
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '$pendingTasks Tarefas Pendentes',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                                  ),
                                  Text(
                                    '$completedTasks Tarefas Concluídas',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
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
                                SizedBox(height: 10),
                                Text(
                                  '🚀 Frase Motivacional',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  _motivationalQuote,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text('Erro ao carregar as tarefas.'));
                }
              },
            ),
    );
  }
}
