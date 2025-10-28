// lib/widgets/mood_card.dart
import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import 'package:intl/intl.dart';

class MoodCard extends StatelessWidget {
  final MoodEntry entry;

  const MoodCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM d, y – h:mm a').format(entry.timestamp);

    return Card(
      color: Colors.teal.shade50,
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Text(
          entry.mood,
          style: const TextStyle(fontSize: 28),
        ),
        title: Text(
          entry.note?.isNotEmpty == true ? entry.note! : "No note added 🌿",
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        subtitle: Text(
          formattedDate,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}
