import '../models/course.dart';

class ScheduleGenerator {
  static const List<String> days = [
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'
  ];

  static Map<String, List<Course>> generateWeeklySchedule(
      List<Course> courses) {
    final Map<String, List<Course>> schedule = {
      for (var day in days) day: [],
    };

    for (final course in courses) {
      for (final day in course.scheduleDays) {
        if (schedule.containsKey(day)) {
          schedule[day]!.add(course);
        }
      }
    }

    // Sort each day by start time
    for (final day in schedule.keys) {
      schedule[day]!.sort((a, b) => a.startTime.compareTo(b.startTime));
    }

    return schedule;
  }

  static List<Course> getCoursesForDay(
      List<Course> courses, String day) {
    return courses
        .where((c) => c.scheduleDays.contains(day))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  static bool hasConflict(Course newCourse, List<Course> existing) {
    for (final course in existing) {
      if (course.id == newCourse.id) continue;
      final sharedDays = newCourse.scheduleDays
          .where((d) => course.scheduleDays.contains(d))
          .toList();
      if (sharedDays.isEmpty) continue;

      if (_timeOverlaps(
        newCourse.startTime, newCourse.endTime,
        course.startTime, course.endTime,
      )) {
        return true;
      }
    }
    return false;
  }

  static bool _timeOverlaps(
    String start1, String end1,
    String start2, String end2,
  ) {
    return start1.compareTo(end2) < 0 && start2.compareTo(end1) < 0;
  }
}
