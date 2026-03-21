import 'dart:convert';

enum TaskPriority { low, medium, high }
enum TaskStatus { pending, inProgress, completed }

class Task {
  final String id;
  final String title;
  final String description;
  final String courseId;
  final DateTime dueDate;
  final TaskPriority priority;
  TaskStatus status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.dueDate,
    required this.priority,
    this.status = TaskStatus.pending,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? courseId,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskStatus? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      courseId: courseId ?? this.courseId,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'courseId': courseId,
        'dueDate': dueDate.toIso8601String(),
        'priority': priority.index,
        'status': status.index,
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        courseId: map['courseId'],
        dueDate: DateTime.parse(map['dueDate']),
        priority: TaskPriority.values[map['priority']],
        status: TaskStatus.values[map['status']],
      );

  String toJson() => jsonEncode(toMap());
  factory Task.fromJson(String source) =>
      Task.fromMap(jsonDecode(source));
}
