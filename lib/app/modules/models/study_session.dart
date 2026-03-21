import 'dart:convert';

class StudySession {
  final String id;
  final String courseId;
  final DateTime date;
  final int durationMinutes;
  final String notes;

  StudySession({
    required this.id,
    required this.courseId,
    required this.date,
    required this.durationMinutes,
    this.notes = '',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'courseId': courseId,
        'date': date.toIso8601String(),
        'durationMinutes': durationMinutes,
        'notes': notes,
      };

  factory StudySession.fromMap(Map<String, dynamic> map) => StudySession(
        id: map['id'],
        courseId: map['courseId'],
        date: DateTime.parse(map['date']),
        durationMinutes: map['durationMinutes'],
        notes: map['notes'] ?? '',
      );

  String toJson() => jsonEncode(toMap());
  factory StudySession.fromJson(String source) =>
      StudySession.fromMap(jsonDecode(source));
}
