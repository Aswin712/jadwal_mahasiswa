import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/course.dart';
import '../models/task.dart';
import '../models/exam.dart';
import '../models/study_session.dart';
import '../services/notification_service.dart';

class AppProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final _uuid = const Uuid();

  List<Course> _courses = [];
  List<Task> _tasks = [];
  List<Exam> _exams = [];
  List<StudySession> _studySessions = [];

  List<Course> get courses => _courses;
  List<Task> get tasks => _tasks;
  List<Exam> get exams => _exams;
  List<StudySession> get studySessions => _studySessions;

  List<Task> get pendingTasks =>
      _tasks.where((t) => t.status != TaskStatus.completed).toList();

  List<Exam> get upcomingExams => _exams
      .where((e) => e.date.isAfter(DateTime.now()))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  Course? getCourseById(String id) {
    try {
      return _courses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Courses ──────────────────────────────────────────────
  Future<void> addCourse(Course course) async {
    final newCourse = course.copyWith(id: _uuid.v4());
    _courses.add(newCourse);
    notifyListeners();
    await _save();
  }

  Future<void> updateCourse(Course course) async {
    final index = _courses.indexWhere((c) => c.id == course.id);
    if (index != -1) {
      _courses[index] = course;
      notifyListeners();
      await _save();
    }
  }

  Future<void> deleteCourse(String id) async {
    _courses.removeWhere((c) => c.id == id);
    _tasks.removeWhere((t) => t.courseId == id);
    _exams.removeWhere((e) => e.courseId == id);
    _studySessions.removeWhere((s) => s.courseId == id);
    notifyListeners();
    await _save();
  }

  // ── Tasks ─────────────────────────────────────────────────
  Future<void> addTask(Task task) async {
    final newTask = task.copyWith(id: _uuid.v4());
    _tasks.add(newTask);
    notifyListeners();
    await _notificationService.scheduleTaskReminder(
      id: newTask.id.hashCode,
      title: 'Deadline: ${newTask.title}',
      body: 'Tugas ini deadline dalam 1 jam!',
      scheduledDate: newTask.dueDate,
    );
    await _save();
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
      await _save();
    }
  }

  Future<void> deleteTask(String id) async {
    await _notificationService.cancelNotification(id.hashCode);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    await _save();
  }

  Future<void> toggleTaskStatus(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(
        status: task.status == TaskStatus.completed
            ? TaskStatus.pending
            : TaskStatus.completed,
      );
      notifyListeners();
      await _save();
    }
  }

  // ── Exams ─────────────────────────────────────────────────
  Future<void> addExam(Exam exam) async {
    final newExam = Exam(
      id: _uuid.v4(),
      courseId: exam.courseId,
      type: exam.type,
      date: exam.date,
      startTime: exam.startTime,
      endTime: exam.endTime,
      room: exam.room,
      notes: exam.notes,
    );
    _exams.add(newExam);
    final course = getCourseById(newExam.courseId);
    if (course != null) {
      await _notificationService.scheduleExamReminder(
        id: newExam.id.hashCode,
        courseName: course.name,
        examType: newExam.typeLabel,
        examDate: newExam.date,
      );
    }
    notifyListeners();
    await _save();
  }

  Future<void> deleteExam(String id) async {
    await _notificationService.cancelNotification(id.hashCode);
    _exams.removeWhere((e) => e.id == id);
    notifyListeners();
    await _save();
  }

  // ── Study Sessions ────────────────────────────────────────
  Future<void> addStudySession(StudySession session) async {
    final newSession = StudySession(
      id: _uuid.v4(),
      courseId: session.courseId,
      date: session.date,
      durationMinutes: session.durationMinutes,
      notes: session.notes,
    );
    _studySessions.add(newSession);
    notifyListeners();
    await _save();
  }

  int getTotalStudyMinutes(String courseId) {
    return _studySessions
        .where((s) => s.courseId == courseId)
        .fold(0, (sum, s) => sum + s.durationMinutes);
  }

  // ── Persistence ───────────────────────────────────────────
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final coursesJson = prefs.getStringList('courses') ?? [];
    _courses = coursesJson.map((e) => Course.fromJson(e)).toList();

    final tasksJson = prefs.getStringList('tasks') ?? [];
    _tasks = tasksJson.map((e) => Task.fromJson(e)).toList();

    final examsJson = prefs.getStringList('exams') ?? [];
    _exams = examsJson.map((e) => Exam.fromJson(e)).toList();

    final sessionsJson = prefs.getStringList('study_sessions') ?? [];
    _studySessions =
        sessionsJson.map((e) => StudySession.fromJson(e)).toList();

    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'courses', _courses.map((e) => e.toJson()).toList());
    await prefs.setStringList(
        'tasks', _tasks.map((e) => e.toJson()).toList());
    await prefs.setStringList(
        'exams', _exams.map((e) => e.toJson()).toList());
    await prefs.setStringList(
        'study_sessions', _studySessions.map((e) => e.toJson()).toList());
  }
}
