import 'dart:convert';

class Course {
  final String id;
  final String name;
  final String lecturer;
  final int color;
  final List<String> scheduleDays;
  final String startTime;
  final String endTime;
  final String room;
  final int credits;

  Course({
    required this.id,
    required this.name,
    required this.lecturer,
    required this.color,
    required this.scheduleDays,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.credits,
  });

  Course copyWith({
    String? id,
    String? name,
    String? lecturer,
    int? color,
    List<String>? scheduleDays,
    String? startTime,
    String? endTime,
    String? room,
    int? credits,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      lecturer: lecturer ?? this.lecturer,
      color: color ?? this.color,
      scheduleDays: scheduleDays ?? this.scheduleDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      credits: credits ?? this.credits,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'lecturer': lecturer,
        'color': color,
        'scheduleDays': scheduleDays,
        'startTime': startTime,
        'endTime': endTime,
        'room': room,
        'credits': credits,
      };

  factory Course.fromMap(Map<String, dynamic> map) => Course(
        id: map['id'],
        name: map['name'],
        lecturer: map['lecturer'],
        color: map['color'],
        scheduleDays: List<String>.from(map['scheduleDays']),
        startTime: map['startTime'],
        endTime: map['endTime'],
        room: map['room'],
        credits: map['credits'],
      );

  String toJson() => jsonEncode(toMap());
  factory Course.fromJson(String source) =>
      Course.fromMap(jsonDecode(source));
}
