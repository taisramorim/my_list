import 'package:cloud_firestore/cloud_firestore.dart';
import '../task_repository.dart';

class FirebaseTaskRepository implements TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addTask(Task task) {
    return _firestore.collection('tasks').add(task.toEntity().toDocument());
  }

  @override
  Future<void> updateTask(Task task) {
    return _firestore.collection('tasks').doc(task.id).update(task.toEntity().toDocument());
  }

  @override
  Future<void> deleteTask(String id) {
    return _firestore.collection('tasks').doc(id).delete();
  }

  @override
  Stream<List<Task>> getTasks() {
    return _firestore.collection('tasks').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskEntity.fromDocument(doc.id, doc.data()).toTask(); 
      }).toList();
    });
  }
}

extension TaskEntityX on TaskEntity {
  Task toTask() {
    return Task(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
    );
  }
}