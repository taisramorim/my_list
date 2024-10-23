part of 'task_bloc.dart';

abstract class TaskState {}

class TaskLoadInProgress extends TaskState {}

class TaskLoadSuccess extends TaskState {
  final List<Task> tasks;
  TaskLoadSuccess(this.tasks);
}

class TaskLoadFailure extends TaskState {
  final String error;
  TaskLoadFailure(this.error);
}