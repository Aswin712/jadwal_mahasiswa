// lib/widgets/course_color_picker.dart

import 'package:flutter/material.dart';

class CourseColorPicker extends StatefulWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final double itemSize;
  final double spacing;

  const CourseColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.itemSize = 36.0,
    this.spacing = 10.0,
  });

  @override
  State<CourseColorPicker> createState() => _CourseColorPickerState();
}

class _CourseColorPickerState extends State<CourseColorPicker> {
  late Color _selected;

  static const List<Color> _courseColors = [
    Color(0xFFEF5350), // Red
    Color(0xFFEC407A), // Pink
    Color(0xFFAB47BC), // Purple
    Color(0xFF7E57C2), // Deep Purple
    Color(0xFF42A5F5), // Blue
    Color(0xFF26C6DA), // Cyan
    Color(0xFF26A69A), // Teal
    Color(0xFF66BB6A), // Green
    Color(0xFFD4E157), // Lime
    Color(0xFFFFCA28), // Amber
    Color(0xFFFFA726), // Orange
    Color(0xFF8D6E63), // Brown
    Color(0xFF78909C), // Blue Grey
    Color(0xFF546E7A), // Dark Blue Grey
    Color(0xFFBDBDBD), // Grey
    Color(0xFF37474F), // Dark Charcoal
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedColor;
  }

  @override
  void didUpdateWidget(CourseColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedColor != widget.selectedColor) {
      _selected = widget.selectedColor;
    }
  }

  void _onTap(Color color) {
    setState(() => _selected = color);
    widget.onColorSelected(color);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Warna Mata Kuliah',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: widget.spacing,
          runSpacing: widget.spacing,
          children: _courseColors.map((color) {
            final isSelected = _selected.value == color.value;
            return GestureDetector(
              onTap: () => _onTap(color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: widget.itemSize,
                height: widget.itemSize,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Colors.white
                        : Colors.transparent,
                    width: 2.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ]
                      : [],
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 18,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        _SelectedColorPreview(color: _selected),
      ],
    );
  }
}

// --- Sub-widget: Preview warna yang dipilih ---
class _SelectedColorPreview extends StatelessWidget {
  final Color color;

  const _SelectedColorPreview({required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
