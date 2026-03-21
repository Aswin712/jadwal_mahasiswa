import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'course_list_screen.dart';
import 'task_list_screen.dart';
import 'exam_list_screen.dart';
import 'schedule_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ScheduleScreen(),
    CourseListScreen(),
    TaskListScreen(),
    ExamListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) =>
            setState(() => _currentIndex = index),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Jadwal',
          ),
          const NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Mata Kuliah',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: provider.pendingTasks.isNotEmpty,
              label: Text('${provider.pendingTasks.length}'),
              child: const Icon(Icons.task_outlined),
            ),
            selectedIcon: const Icon(Icons.task),
            label: 'Tugas',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: provider.upcomingExams.isNotEmpty,
              label: Text('${provider.upcomingExams.length}'),
              child: const Icon(Icons.quiz_outlined),
            ),
            selectedIcon: const Icon(Icons.quiz),
            label: 'Ujian',
          ),
        ],
      ),
    );
  }
}
