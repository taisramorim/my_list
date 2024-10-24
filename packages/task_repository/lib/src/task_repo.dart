import 'package:task_repository/task_repository.dart';

abstract class TaskRepository {

  Stream<List<Task>> getTasks(String userId);

  Future<void> addTask(Task task);

  Future<void> updateTask(Task task);

  Future<void> deleteTask(String id);
}