import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalmar_driver_app/domain/repositories/task_repository.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TaskRepository taskRepository;

  TasksBloc({required this.taskRepository}) : super(TasksInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<UpdateTaskStatus>(_onUpdateTaskStatus);
  }

  Future<void> _onLoadTasks(
    LoadTasks event,
    Emitter<TasksState> emit,
  ) async {
    emit(TasksLoading());
    try {
      final tasks = await taskRepository.getTasks();
      emit(TasksLoaded(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> _onUpdateTaskStatus(
    UpdateTaskStatus event,
    Emitter<TasksState> emit,
  ) async {
    try {
      await taskRepository.updateTaskStatus(event.taskId, event.status);
      add(LoadTasks());
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }
} 