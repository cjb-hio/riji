import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final String selectedMood;
  final ValueChanged<String> onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  static const List<Map<String, dynamic>> moods = [
    {'value': 'happy', 'label': '开心', 'icon': Icons.sentiment_very_satisfied, 'color': Colors.amber},
    {'value': 'sad', 'label': '难过', 'icon': Icons.sentiment_very_dissatisfied, 'color': Colors.blue},
    {'value': 'angry', 'label': '生气', 'icon': Icons.sentiment_very_dissatisfied_outlined, 'color': Colors.red},
    {'value': 'calm', 'label': '平静', 'icon': Icons.sentiment_satisfied, 'color': Colors.green},
    {'value': 'anxious', 'label': '焦虑', 'icon': Icons.sentiment_neutral, 'color': Colors.orange},
    {'value': 'excited', 'label': '兴奋', 'icon': Icons.celebration, 'color': Colors.pink},
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: moods.map((mood) {
        final isSelected = selectedMood == mood['value'];
        return GestureDetector(
          onTap: () => onMoodSelected(mood['value']),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? mood['color'].withOpacity(0.2) : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? mood['color'] : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(mood['icon'], color: mood['color'], size: 20),
                const SizedBox(width: 4),
                Text(
                  mood['label'],
                  style: TextStyle(
                    color: isSelected ? mood['color'] : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
