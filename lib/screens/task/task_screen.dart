import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_list/blocs/task_bloc/task_bloc.dart';
import 'package:my_list/screens/home/home_screen.dart';
import 'package:task_repository/task_repository.dart';

class TaskScreen extends StatelessWidget {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Tarefa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
            Text(
              'Crie uma nova tarefa',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 20),
            _buildTextField(_controllerTitle, 'Título da Tarefa'),
            SizedBox(height: 16),
            _buildTextField(_controllerDescription, 'Descrição da Tarefa', maxLines: 5),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  id: '', 
                  title: _controllerTitle.text,
                  description: _controllerDescription.text,
                );

                if (newTask.title.isNotEmpty) {
                  BlocProvider.of<TaskBloc>(context).add(AddTask(newTask));
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tarefa adicionada com sucesso!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, insira um título.'),
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
              child: Text('Criar Tarefa', style: TextStyle(color: Colors.white, fontSize: 16),),
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
