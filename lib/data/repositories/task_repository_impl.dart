import 'package:kalmar_driver_app/domain/entities/task.dart';
import 'package:kalmar_driver_app/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  @override
  Future<List<Task>> getTasks() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Task(
        id: '1',
        title: 'Переместить трейлер A123',
        description: 'Переместить трейлер с парковки на рампу 5',
        status: 'pending',
        createdAt: DateTime.now(),
      ),
      Task(
        id: '2',
        title: 'Переместить трейлер B456',
        description: 'Переместить трейлер с рампы 3 на парковку',
        status: 'in_progress',
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<void> updateTaskStatus(String taskId, String status) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
} 