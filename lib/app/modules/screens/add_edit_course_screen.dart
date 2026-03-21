import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/app_provider.dart';
import '../widgets/course_color_picker.dart';

class AddEditCourseScreen extends StatefulWidget {
  final Course? course;
  const AddEditCourseScreen({super.key, this.course});

  @override
  State<AddEditCourseScreen> createState() => _AddEditCourseScreenState();
}

class _AddEditCourseScreenState extends State<AddEditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _lecturerCtrl;
  late final TextEditingController _roomCtrl;
  late final TextEditingController _startTimeCtrl;
  late final TextEditingController _endTimeCtrl;
  late int _selectedColor;
  late int _credits;
  late List<String> _selectedDays;

  final List<String> _days = [
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'
  ];

  bool get _isEdit => widget.course != null;

  @override
  void initState() {
    super.initState();
    final c = widget.course;
    _nameCtrl = TextEditingController(text: c?.name ?? '');
    _lecturerCtrl = TextEditingController(text: c?.lecturer ?? '');
    _roomCtrl = TextEditingController(text: c?.room ?? '');
    _startTimeCtrl = TextEditingController(text: c?.startTime ?? '');
    _endTimeCtrl = TextEditingController(text: c?.endTime ?? '');
    _selectedColor = c?.color ?? 0xFF2196F3;
    _credits = c?.credits ?? 2;
    _selectedDays = List.from(c?.scheduleDays ?? []);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lecturerCtrl.dispose();
    _roomCtrl.dispose();
    _startTimeCtrl.dispose();
    _endTimeCtrl.dispose();
    super.dispose();
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
    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih minimal 1 hari kuliah')),
      );
      return;
    }

    final provider = context.read<AppProvider>();
    final course = Course(
      id: widget.course?.id ?? '',
      name: _nameCtrl.text.trim(),
      lecturer: _lecturerCtrl.text.trim(),
      color: _selectedColor,
      scheduleDays: _selectedDays,
      startTime: _startTimeCtrl.text,
      endTime: _endTimeCtrl.text,
      room: _roomCtrl.text.trim(),
      credits: _credits,
    );

    if (_isEdit) {
      await provider.updateCourse(course);
    } else {
      await provider.addCourse(course);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Mata Kuliah' : 'Tambah Mata Kuliah'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration:
                  const InputDecoration(labelText: 'Nama Mata Kuliah'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lecturerCtrl,
              decoration: const InputDecoration(labelText: 'Dosen'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _roomCtrl,
              decoration: const InputDecoration(labelText: 'Ruangan'),
            ),
            const SizedBox(height: 16),
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
            // Credits
            Row(
              children: [
                const Text('SKS:',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: _credits,
                  items: List.generate(6, (i) => i + 1)
                      .map((v) => DropdownMenuItem(
                          value: v, child: Text('$v SKS')))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _credits = v ?? 2),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Days
            const Text('Hari Kuliah:',
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _days.map((day) {
                final selected = _selectedDays.contains(day);
                return FilterChip(
                  label: Text(day),
                  selected: selected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedDays.add(day);
                      } else {
                        _selectedDays.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Color picker
            CourseColorPicker(
              selectedColor: Color(_selectedColor),     // int → Color ✅
              onColorSelected: (color) {
                setState(() => _selectedColor = color.value); // Color → int ✅
              },
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _submit,
              child: Text(
                  _isEdit ? 'Simpan Perubahan' : 'Tambah Mata Kuliah'),
            ),
          ],
        ),
      ),
    );
  }
}
