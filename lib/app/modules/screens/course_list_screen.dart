import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/course.dart';
import 'add_edit_course_screen.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = context.watch<AppProvider>().courses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mata Kuliah'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const AddEditCourseScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: courses.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.school_outlined,
                      size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text('Belum ada mata kuliah',
                      style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final course = courses[index];
                return _CourseCard(course: course);
              },
            ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;
  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Color(course.color),
          child: Text(
            course.name.substring(0, 1).toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(course.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${course.lecturer} • ${course.credits} SKS'),
        trailing: PopupMenuButton(
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(
                value: 'delete',
                child: Text('Hapus',
                    style: TextStyle(color: Colors.red))),
          ],
          onSelected: (value) async {
            if (value == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      AddEditCourseScreen(course: course),
                ),
              );
            } else if (value == 'delete') {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Hapus Mata Kuliah?'),
                  content: Text(
                      'Semua tugas dan ujian "${course.name}" juga akan dihapus.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await provider.deleteCourse(course.id);
              }
            }
          },
        ),
      ),
    );
  }
}
