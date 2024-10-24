import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_list/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:my_list/blocs/task_bloc/task_bloc.dart';
import 'package:my_list/screens/task/task_list.dart';
import 'package:task_repository/task_repository.dart';

class TaskScreen extends StatelessWidget {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthenticationBloc>().state.user?.uid ?? ''; 

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Task',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            _buildTextField(_controllerTitle, 'Title'),
            SizedBox(height: 16),
            _buildTextField(_controllerDescription, 'Description', maxLines: 5),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  id: '', 
                  title: _controllerTitle.text,
                  description: _controllerDescription.text,
                  userId: userId, 
                );

                if (newTask.title.isNotEmpty) {
                  BlocProvider.of<TaskBloc>(context).add(AddTask(newTask));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TaskListScreen()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Task added successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please insert a title.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Add task', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      style: TextStyle(fontSize: 18),
    );
  }
}
