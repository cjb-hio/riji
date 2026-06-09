import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:riji_flutter/data/models/diary.dart';

class DiaryCard extends StatelessWidget {
  final Diary diary;
  final VoidCallback onTap;

  const DiaryCard({super.key, required this.diary, required this.onTap});

  IconData _getMoodIcon(String mood) {
    switch (mood) {
      case 'happy':
        return Icons.sentiment_very_satisfied;
      case 'sad':
        return Icons.sentiment_very_dissatisfied;
      case 'angry':
        return Icons.sentiment_very_dissatisfied_outlined;
      case 'calm':
        return Icons.sentiment_satisfied;
      case 'anxious':
        return Icons.sentiment_neutral;
      case 'excited':
        return Icons.celebration;
      default:
        return Icons.sentiment_neutral;
    }
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'happy':
        return Colors.amber;
      case 'sad':
        return Colors.blue;
      case 'angry':
        return Colors.red;
      case 'calm':
        return Colors.green;
      case 'anxious':
        return Colors.orange;
      case 'excited':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_getMoodIcon(diary.mood), color: _getMoodColor(diary.mood), size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      diary.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                diary.content,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                dateFormat.format(diary.createdAt),
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
