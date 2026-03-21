import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import 'add_exam_screen.dart';

class ExamListScreen extends StatelessWidget {
  const ExamListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exams = context.watch<AppProvider>().upcomingExams;
    final provider = context.read<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ujian'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddExamScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: exams.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.quiz_outlined,
                      size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text('Belum ada jadwal ujian',
                      style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: exams.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final exam = exams[index];
                final course = provider.getCourseById(exam.courseId);
                final daysLeft =
                    exam.date.difference(DateTime.now()).inDays;

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor:
                          Color(course?.color ?? 0xFF9E9E9E),
                      child: Text(
                        exam.typeLabel.substring(0, 1),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      '${exam.typeLabel} - ${course?.name ?? '-'}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                            .format(exam.date)),
                        Text(
                            '${exam.startTime} - ${exam.endTime} • ${exam.room}'),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(
                        daysLeft == 0
                            ? 'Hari ini'
                            : '$daysLeft hari lagi',
                        style: TextStyle(
                          fontSize: 11,
                          color: daysLeft <= 3
                              ? Colors.red
                              : Colors.green[700],
                        ),
                      ),
                      backgroundColor: daysLeft <= 3
                          ? Colors.red.shade50
                          : Colors.green.shade50,
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
