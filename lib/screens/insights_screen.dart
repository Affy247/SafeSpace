// lib/screens/insights_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/insights_service.dart';
import '../models/mood_entry.dart';
import '../services/auth_service.dart';

class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key});
  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  final _insightService = InsightService();
  Box? _moodBox;
  bool _loading = true;
  String? _aiReflection;
  String? _summary;

  @override
  void initState() {
    super.initState();
    _initBoxes();
  }

  Future<void> _initBoxes() async {
    try {
      if (!Hive.isBoxOpen('moods')) await Hive.openBox('moods');
      _moodBox = Hive.box('moods');
      await _generateSummary();
    } catch (e) {
      setState(() => _summary = "Unable to load insights ❌");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _generateSummary() async {
    final auth = AuthService();
    final userId = auth.currentUserId;
    if (userId == null) {
      setState(() => _summary = "Please log in to view insights.");
      return;
    }

    final items = _moodBox!.values.map((v) => MoodEntry.fromMap(Map<String, dynamic>.from(v))).where((m) => m.uid == userId).toList();
    if (items.isEmpty) {
      setState(() => _summary = "No mood data yet 📝\nStart tracking your emotions!");
      return;
    }

    final counts = <String, int>{};
    for (var m in items) {
      counts[m.mood] = (counts[m.mood] ?? 0) + 1;
    }

    final top = counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    setState(() => _summary = "You’ve been feeling mostly $top lately 💫\nKeep reflecting to boost your emotional wellbeing!");
  }

  Future<void> _generateAIInsight() async {
    setState(() => _loading = true);
    final result = await _insightService.generateReflection();
    setState(() {
      _aiReflection = result;
      _loading = false;
    });
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case '😊':
        return Colors.yellow.shade700;
      case '😢':
        return Colors.blue.shade400;
      case '😠':
        return Colors.red.shade400;
      case '😴':
        return Colors.grey.shade400;
      case '😕':
        return Colors.purple.shade300;
      case '🤩':
        return Colors.orange.shade400;
      default:
        return Colors.teal.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _summary == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.teal)));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Insights 🌿"), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Mood Summary 📊", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (_moodBox != null && _moodBox!.isNotEmpty)
            SizedBox(height: 160, child: _buildMoodChart()),
          const SizedBox(height: 16),
          Text(_summary ?? "No data available.", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loading ? null : _generateAIInsight,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, minimumSize: const Size(double.infinity, 50)),
            icon: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.psychology_alt),
            label: const Text("Generate AI Reflection"),
          ),
          const SizedBox(height: 16),
          if (_aiReflection != null)
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(12)), child: Text(_aiReflection!, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic))),
        ]),
      ),
    );
  }

  Widget _buildMoodChart() {
    final auth = AuthService();
    final userId = auth.currentUserId;
    if (userId == null || _moodBox == null) return const SizedBox.shrink();

    final items = _moodBox!.values.map((v) => MoodEntry.fromMap(Map.from(v))).where((m) => m.uid == userId).toList();
    if (items.isEmpty) return const SizedBox.shrink();

    final counts = <String, int>{};
    for (var m in items) counts[m.mood] = (counts[m.mood] ?? 0) + 1;
    final total = counts.values.fold<int>(0, (a, b) => a + b);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: counts.entries.map((e) {
      final pct = (e.value / total * 100).toStringAsFixed(1);
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 70, height: 70, decoration: BoxDecoration(color: _getMoodColor(e.key), shape: BoxShape.circle), child: Center(child: Text("$pct%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
        const SizedBox(height: 8),
        Text(e.key),
      ]);
    }).toList());
  }
}
