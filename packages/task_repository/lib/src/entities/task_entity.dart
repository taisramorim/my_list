class TaskEntity{
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String userId;

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.userId
  });

  Map<String, dynamic> toDocument(){
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'userId': userId
    };
  }

  static TaskEntity fromDocument(String id, Map<String, dynamic> doc){
    return TaskEntity(
      id: id,
      title: doc['title'],
      description: doc['description'],
      isCompleted: doc['isCompleted'] ?? false,
      userId: doc['userId']
    );
  }

  @override
  String toString(){
    return '''TaskEntity: {
      id: $id
      title: $title
      description: $description
      isCompleted: $isCompleted
      userId: $userId
    }''';
  }
}