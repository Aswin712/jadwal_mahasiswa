import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exam.dart';
import '../providers/app_provider.dart';

class AddExamScreen extends StatefulWidget {
  const AddExamScreen({super.key});

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roomCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _startTimeCtrl = TextEditingController();
  final _endTimeCtrl = TextEditingController();
  String? _selectedCourseId;
  ExamType _examType = ExamType.midterm;
  DateTime _examDate = DateTime.now().add(const Duration(days: 14));

  @override
  void dispose() {
    _roomCtrl.dispose();
    _notesCtrl.dispose();
    _startTimeCtrl.dispose();
    _endTimeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _examDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _examDate = picked);
  }

  Future<void> _pickTime(TextEditingController ctrl) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      ctrl.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCourseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih mata kuliah')),
      );
      return;
    }

    final exam = Exam(
      id: '',
      courseId: _selectedCourseId!,
      type: _examType,
      date: _examDate,
      startTime: _startTimeCtrl.text,
      endTime: _endTimeCtrl.text,
      room: _roomCtrl.text.trim(),
      notes: _notesCtrl.text.trim(),
    );

    await context.read<AppProvider>().addExam(exam);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final courses = context.watch<AppProvider>().courses;

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Jadwal Ujian')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
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
            DropdownButtonFormField<ExamType>(
              value: _examType,
              decoration: const InputDecoration(labelText: 'Jenis Ujian'),
              items: ExamType.values
                  .map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(Exam(
                        id: '', courseId: '', type: t,
                        date: DateTime.now(),
                        startTime: '', endTime: '', room: '',
                      ).typeLabel)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _examType = v ?? ExamType.midterm),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Tanggal Ujian'),
              subtitle: Text(
                  '${_examDate.day}/${_examDate.month}/${_examDate.year}'),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _pickDate,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startTimeCtrl,
                    readOnly: true,
                    decoration:
                        const InputDecoration(labelText: 'Jam Mulai'),
                    onTap: () => _pickTime(_startTimeCtrl),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Wajib diisi' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _endTimeCtrl,
                    readOnly: true,
                    decoration:
                        const InputDecoration(labelText: 'Jam Selesai'),
                    onTap: () => _pickTime(_endTimeCtrl),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Wajib diisi' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _roomCtrl,
              decoration: const InputDecoration(labelText: 'Ruangan'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(labelText: 'Catatan'),
              maxLines: 2,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _submit,
              child: const Text('Tambah Jadwal Ujian'),
            ),
          ],
        ),
      ),
    );
  }
}
