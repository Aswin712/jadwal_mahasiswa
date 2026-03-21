import 'dart:convert';

enum ExamType { midterm, final_, quiz, practical }

class Exam {
  final String id;
  final String courseId;
  final ExamType type;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String room;
  final String notes;

  Exam({
    required this.id,
    required this.courseId,
    required this.type,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.room,
    this.notes = '',
  });

  String get typeLabel {
    switch (type) {
      case ExamType.midterm:
        return 'UTS';
      case ExamType.final_:
        return 'UAS';
      case ExamType.quiz:
        return 'Kuis';
      case ExamType.practical:
        return 'Praktikum';
    }
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'courseId': courseId,
        'type': type.index,
        'date': date.toIso8601String(),
        'startTime': startTime,
        'endTime': endTime,
        'room': room,
        'notes': notes,
      };

  factory Exam.fromMap(Map<String, dynamic> map) => Exam(
        id: map['id'],
        courseId: map['courseId'],
        type: ExamType.values[map['type']],
        date: DateTime.parse(map['date']),
        startTime: map['startTime'],
        endTime: map['endTime'],
        room: map['room'],
        notes: map['notes'] ?? '',
      );

  String toJson() => jsonEncode(toMap());
  factory Exam.fromJson(String source) =>
      Exam.fromMap(jsonDecode(source));
}
