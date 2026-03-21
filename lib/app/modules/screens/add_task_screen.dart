import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/app_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String? _selectedCourseId;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  TaskPriority _priority = TaskPriority.medium;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCourseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih mata kuliah')),
      );
      return;
    }

    final task = Task(
      id: '',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      courseId: _selectedCourseId!,
      dueDate: _dueDate,
      priority: _priority,
    );

    await context.read<AppProvider>().addTask(task);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final courses = context.watch<AppProvider>().courses;

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Tugas')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Judul Tugas'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCourseId,
              decoration:
                  const InputDecoration(labelText: 'Mata Kuliah'),
              items: courses
                  .map((c) => DropdownMenuItem(
                      value: c.id, child: Text(c.name)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _selectedCourseId = v),
              validator: (v) => v == null ? 'Pilih mata kuliah' : null,
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Deadline'),
              subtitle: Text(
                '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _pickDate,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Prioritas:',
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            SegmentedButton<TaskPriority>(
              segments: const [
                ButtonSegment(
                    value: TaskPriority.low, label: Text('Rendah')),
                ButtonSegment(
                    value: TaskPriority.medium, label: Text('Sedang')),
                ButtonSegment(
                    value: TaskPriority.high, label: Text('Tinggi')),
              ],
              selected: {_priority},
              onSelectionChanged: (s) =>
                  setState(() => _priority = s.first),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _submit,
              child: const Text('Tambah Tugas'),
            ),
          ],
        ),
      ),
    );
  }
}
