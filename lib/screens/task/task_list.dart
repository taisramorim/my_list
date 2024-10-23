import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_list/blocs/task_bloc/task_bloc.dart';
import 'package:my_list/screens/task/task_details.dart';
import 'package:my_list/screens/task/task_screen.dart';
import 'package:task_repository/task_repository.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          title: Text('Minhas Tarefas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          bottom: TabBar(
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.black,
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'Não Concluídas'),
              Tab(text: 'Concluídas'),
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
                final tasks = state.tasks;
                final completedTasks = tasks.where((task) => task.isCompleted).toList();
                final pendingTasks = tasks.where((task) => !task.isCompleted).toList();

                return TabBarView(
                  children: [
                    _buildTaskList(pendingTasks, context),
                    _buildTaskList(completedTasks, context),
                  ],
                );
              } else {
                return Center(child: Text('Erro ao carregar tarefas.'));
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TaskScreen()));
          },
          backgroundColor: Colors.teal,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks, BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: EdgeInsets.all(16), 
            leading: _buildRoundCheckbox(task, context), 
            title: Text(
              task.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              overflow: TextOverflow.ellipsis, 
            ),
            subtitle: Text(
              task.description,
              style: TextStyle(color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
              maxLines: 1, 
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.teal), 
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task,)));
            },
          ),
        );
      },
    );
  }

  Widget _buildRoundCheckbox(Task task, BuildContext context) {
    return Checkbox(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      value: task.isCompleted,
      onChanged: (value) {
        BlocProvider.of<TaskBloc>(context).add(UpdateTask(task.copyWith(isCompleted: value)));
      },
      activeColor: Colors.teal,
      checkColor: Colors.white,
    );
  }
}
