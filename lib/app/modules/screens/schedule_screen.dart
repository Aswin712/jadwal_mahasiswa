import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/schedule_generator.dart';
import '../models/course.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String _selectedDay = ScheduleGenerator.days[DateTime.now().weekday - 1 < 6
      ? DateTime.now().weekday - 1
      : 0];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final schedule =
        ScheduleGenerator.generateWeeklySchedule(provider.courses);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Kuliah'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Day selector
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: ScheduleGenerator.days.length,
              itemBuilder: (context, index) {
                final day = ScheduleGenerator.days[index];
                final isSelected = day == _selectedDay;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 6),
                  child: ChoiceChip(
                    label: Text(day),
                    selected: isSelected,
                    onSelected: (_) =>
                        setState(() => _selectedDay = day),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          // Course list for selected day
          Expanded(
            child: schedule[_selectedDay]!.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_available,
                            size: 64,
                            color: Colors.grey[300]),
                        const SizedBox(height: 12),
                        Text(
                          'Tidak ada kuliah $_selectedDay',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: schedule[_selectedDay]!.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final course = schedule[_selectedDay]![index];
                      return _CourseScheduleCard(course: course);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CourseScheduleCard extends StatelessWidget {
  final Course course;
  const _CourseScheduleCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: Color(course.color),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.lecturer,
                      style: TextStyle(
                          color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '${course.startTime} - ${course.endTime}',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.room,
                            size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          course.room,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
