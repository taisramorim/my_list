import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_list/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:my_list/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:my_list/blocs/task_bloc/task_bloc.dart';
import 'package:my_list/screens/authentication/welcome_page.dart';
import 'package:my_list/screens/task/task_details.dart';
import 'package:my_list/screens/task/task_screen.dart';
import 'package:task_repository/task_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<SignInBloc>(context).add(SignOutRequired());
              Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          dividerColor: Colors.transparent,
          tabs: [
            Tab(
              text: 'Ativas',
              icon: Icon(Icons.check_circle_outline),
            ),
            Tab(
              text: 'Concluídas',
              icon: Icon(Icons.check_circle),
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) => TaskBloc(FirebaseTaskRepository())..add(LoadTasks()),
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TaskLoadSuccess) {
              return Column(
                children: [
                  SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildActiveTasksList(state.tasks),
                        _buildCompletedTasksList(state.tasks.where((task) => task.isCompleted).toList()),
                      ],
                    ),
                  ),
                  _buildAddTaskButton(),
                  SizedBox(height: 50),
                ],
              );
            } else {
              return Center(child: Text('Erro ao carregar tarefas.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildActiveTasksList(List<Task> tasks) {
    final activeTasks = tasks.where((task) => !task.isCompleted).toList();

    if (activeTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text(
              'Ainda não há tarefas ativas.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Por gentileza, adicione uma tarefa.'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: activeTasks.length,
      itemBuilder: (context, index) {
        final task = activeTasks[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Row(
              children: [
                _buildRoundCheckbox(task),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            subtitle: Text(task.description),
            trailing: Icon(Icons.chevron_right, color: Colors.teal),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailScreen(task: task),
                ),
              );
            },
          ),
        );
      },
    );
  }  

  Widget _buildRoundCheckbox(Task task) {
    return Checkbox(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      value: task.isCompleted,
      onChanged: (value) {
        BlocProvider.of<TaskBloc>(context).add(UpdateTask(task.copyWith(isCompleted: value!)));
      },
      activeColor: Colors.teal,
      checkColor: Colors.white,
    );
  }

  Widget _buildCompletedTasksList(List<Task> completedTasks) {
    if (completedTasks.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma tarefa concluída.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              final task = completedTasks[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  subtitle: Text(task.description),
                  trailing: Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          ),
        ),
      ],
    );
  }  

  Widget _buildAddTaskButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text('Adicionar Nova Tarefa', style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
  
}
