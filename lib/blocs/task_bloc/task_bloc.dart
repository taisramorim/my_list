import 'package:bloc/bloc.dart';
import 'package:task_repository/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  final String userId;  

  TaskBloc(this.taskRepository, this.userId) : super(TaskLoadInProgress()) {
    on<LoadTasks>((event, emit) async {
      emit(TaskLoadInProgress());
      try {
        final tasks = await taskRepository.getTasks(userId).first; // Passa o userId para buscar tarefas
        emit(TaskLoadSuccess(tasks));
      } catch (e) {
        emit(TaskLoadFailure(e.toString()));
      }
    });

    on<AddTask>((event, emit) async {
      try {
        await taskRepository.addTask(event.task);
        add(LoadTasks()); 
      } catch (e) {
        emit(TaskLoadFailure(e.toString()));
      }
    });

    on<UpdateTask>((event, emit) async {
      try {
        await taskRepository.updateTask(event.task);
        final tasks = await taskRepository.getTasks(userId).first;         
        emit(TaskLoadSuccess(tasks)); 
      } catch (e) {
        emit(TaskLoadFailure(e.toString()));
      }
    });

    on<DeleteTask>((event, emit) async {
      try {
        await taskRepository.deleteTask(event.id);
        add(LoadTasks()); 
      } catch (e) {
        emit(TaskLoadFailure(e.toString()));
      }
    });
  }
}