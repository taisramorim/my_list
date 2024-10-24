import '../entities/entities.dart';

class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  String userId;

  Task({required this.id, required this.title, required this.description, required this.userId, this.isCompleted = false});


  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? userId
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId
    );
  }

  TaskEntity toEntity(){
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      userId: userId
    );
  }

  static Task fromEntity(TaskEntity entity, Map<String, dynamic> map) {
    return Task(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
      userId: entity.userId
    );
  }
}

