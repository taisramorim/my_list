import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_list/blocs/authentication_bloc/authentication_bloc.dart'; 
import 'package:my_list/blocs/task_bloc/task_bloc.dart';
import 'package:task_repository/task_repository.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  TaskDetailScreen({super.key, required this.task});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _controller;
  late TextEditingController _controllerDescription;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.title);
    _controllerDescription = TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthenticationBloc>().state.user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            _buildTextField(_controller, 'Title'),
            SizedBox(height: 16),
            _buildTextField(_controllerDescription, 'Description', maxLines: 5),
            SizedBox(height: 30),
            _buildButton(
              context,
              onPressed: () {
                final updatedTask = Task(
                  id: widget.task.id,
                  title: _controller.text,
                  description: _controllerDescription.text,
                  isCompleted: widget.task.isCompleted,
                  userId: userId, 
                );

                BlocProvider.of<TaskBloc>(context).add(UpdateTask(updatedTask));

                Navigator.pop(context, true);
              },
              icon: Icons.save_as_outlined,
              label: 'Save',
              color: Colors.teal,
            ),
            SizedBox(height: 16),
            _buildButton(
              context,
              onPressed: () {
                _showDeleteConfirmationDialog(context);
              },
              icon: Icons.delete,
              label: 'Delete',
              color: Colors.red,
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
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
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
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildButton(BuildContext context, {required VoidCallback onPressed, required IconData icon, required String label, required Color color}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Deletar Tarefa', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Você tem certeza que deseja deletar esta tarefa?', style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<TaskBloc>(context).add(DeleteTask(widget.task.id));
                Navigator.of(context).pop(); 
                Navigator.of(context).pop(true); 
              },
              child: Text('Deletar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
