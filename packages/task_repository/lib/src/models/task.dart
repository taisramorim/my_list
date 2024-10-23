import '../entities/entities.dart';

class Task {
  String id;
  String title;
  String description;
  bool isCompleted;

  Task({required this.id, required this.title, required this.description, this.isCompleted = false});


  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  TaskEntity toEntity(){
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
    );
  }

  static Task fromEntity(TaskEntity entity, Map<String, dynamic> map) {
    return Task(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
    );
  }
}

