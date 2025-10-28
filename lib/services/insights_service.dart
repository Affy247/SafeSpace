// lib/services/insights_service.dart
import 'dart:math';
import 'package:hive/hive.dart';
import '../models/mood_entry.dart';
import 'auth_service.dart';

class InsightService {
  Future<String> generateReflection() async {
    try {
      if (!Hive.isBoxOpen('moods')) {
        await Hive.openBox('moods');
      }
      final box = Hive.box('moods');
      final moods = box.values.map((v) => MoodEntry.fromMap(Map<String, dynamic>.from(v))).toList();

      final userId = AuthService().currentUserId;
      if (userId == null) return "Please log in to get personalized insights.";

      final userMoods = moods.where((m) => m.uid == userId).toList();
      if (userMoods.isEmpty) {
        return "You haven’t tracked any moods yet 🌱. Start adding how you feel to unlock your personal insights!";
      }

      final moodCounts = <String, int>{};
      for (var m in userMoods) {
        moodCounts[m.mood] = (moodCounts[m.mood] ?? 0) + 1;
      }

      final topMood = moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

      final reflections = {
        '😊': "You’ve been having brighter moments lately 🌞. Celebrate small wins.",
        '😢': "Sadness is present — be gentle with yourself. Consider speaking to someone you trust.",
        '😠': "Anger shows up — try a grounding or breathing exercise when it rises.",
        '😴': "Feeling tired or withdrawn — your body might be asking for rest.",
        '😕': "Confusion shows up — journaling or talking it out could help.",
        '🤩': "Excited! Consider channeling that energy into creative action.",
      };

      final reflection = reflections[topMood] ?? "You’ve shown emotional variety — keeping track already helps.";

      final closers = [
        "Take a breath and give yourself credit for showing up 🌼.",
        "Progress, not perfection 🌱.",
        "You’re learning yourself better each day 💫."
      ];

      return "$reflection\n\n${closers[Random().nextInt(closers.length)]}";
    } catch (e) {
      return "⚠️ Could not generate reflection. Try reopening the screen.";
    }
  }
}
