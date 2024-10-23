import 'package:bloc/bloc.dart';
import 'package:task_repository/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc(this.taskRepository) : super(TaskLoadInProgress()) {
    on<LoadTasks>((event, emit) async {
      emit(TaskLoadInProgress());
      try {
        final tasks = await taskRepository.getTasks().first; 
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
        add(LoadTasks()); 
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