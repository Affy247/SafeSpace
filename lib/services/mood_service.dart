// lib/services/mood_service.dart
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/mood_entry.dart';
import 'auth_service.dart';

class MoodService {
  final _uuid = const Uuid();

  Future<void> saveMood(String mood, String? note) async {
    final userId = AuthService().currentUserId;
    final email = AuthService().currentUserEmail;
    if (userId == null) throw Exception("No logged-in user");

    final box = Hive.box('moods');
    final entry = MoodEntry(
      id: _uuid.v4(),
      uid: userId,
      mood: mood,
      note: note,
      timestamp: DateTime.now(),
      userEmail: email,
    );
    await box.put(entry.id, entry.toMap());
  }

  /// returns newest first
  List<MoodEntry> getUserMoods() {
    final userId = AuthService().currentUserId;
    if (userId == null) return [];

    final box = Hive.box('moods');
    final items = box.values.map((v) => MoodEntry.fromMap(Map<String, dynamic>.from(v))).toList();
    final filtered = items.where((m) => m.uid == userId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return filtered;
  }
}
