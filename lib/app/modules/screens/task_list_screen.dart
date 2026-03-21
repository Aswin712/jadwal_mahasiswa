import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/task.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  Color _priorityColor(TaskPriority p) {
    switch (p) {
      case TaskPriority.high: return Colors.red;
      case TaskPriority.medium: return Colors.orange;
      case TaskPriority.low: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<AppProvider>().tasks;

    return Scaffold(
      appBar: AppBar(title: const Text('Tugas'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTaskScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.task_outlined,
                      size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text('Belum ada tugas',
                      style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final task = tasks[index];
                final provider = context.read<AppProvider>();
                final course = provider.getCourseById(task.courseId);

                return Dismissible(
                  key: Key(task.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => provider.deleteTask(task.id),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.status == TaskStatus.completed,
                        onChanged: (_) =>
                            provider.toggleTaskStatus(task.id),
                        activeColor: Colors.green,
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          decoration:
                              task.status == TaskStatus.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                        ),
                      ),
                      subtitle: Text(
                        '${course?.name ?? '-'} • ${DateFormat('dd MMM yyyy').format(task.dueDate)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _priorityColor(task.priority)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          task.priority.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            color: _priorityColor(task.priority),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
