import 'package:equatable/equatable.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TasksEvent {}

class UpdateTaskStatus extends TasksEvent {
  final String taskId;
  final String status;

  const UpdateTaskStatus({
    required this.taskId,
    required this.status,
  });

  @override
  List<Object> get props => [taskId, status];
} 