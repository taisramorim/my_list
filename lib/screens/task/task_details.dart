import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_list/blocs/task_bloc/task_bloc.dart';
import 'package:task_repository/task_repository.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  TaskDetailScreen({super.key, required this.task});

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  void initState() {
    _controller.text = task.title;
    _controllerDescription.text = task.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Tarefa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
            Text(
              'Edite os detalhes da sua tarefa',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 16),
            _buildTextField(_controller, task.title),
            SizedBox(height: 16),
            _buildTextField(_controllerDescription, task.description, maxLines: 5),
            SizedBox(height: 30),
            _buildButton(
              context,
              onPressed: () {
                final updatedTask = Task(
                  id: task.id,
                  title: _controller.text,
                  description: _controllerDescription.text,
                  isCompleted: task.isCompleted,
                );
                BlocProvider.of<TaskBloc>(context).add(UpdateTask(updatedTask));
                Navigator.pop(context);
              },
              icon: Icons.save,
              label: 'Salvar Alterações',
              color: Colors.teal,
            ),
            SizedBox(height: 16),
            _buildButton(
              context,
              onPressed: () {
                _showDeleteConfirmationDialog(context);
              },
              icon: Icons.delete,
              label: 'Deletar Tarefa',
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
        label: Text(label, style: TextStyle(color: Colors.white),),
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
                BlocProvider.of<TaskBloc>(context).add(DeleteTask(task.id));
                Navigator.of(context).pop();
                Navigator.of(context).pop(); 
              },
              child: Text('Deletar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
