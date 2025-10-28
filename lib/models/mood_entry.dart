// lib/models/mood_entry.dart
class MoodEntry {
  final String id;
  final String uid;
  final String mood;
  final String? note;
  final DateTime timestamp;
  final String? userEmail;

  MoodEntry({
    required this.id,
    required this.uid,
    required this.mood,
    this.note,
    required this.timestamp,
    this.userEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'mood': mood,
      'note': note,
      'timestamp': timestamp.toIso8601String(),
      'userEmail': userEmail,
    };
  }

  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      mood: map['mood'] ?? '',
      note: map['note'],
      timestamp: DateTime.parse(map['timestamp']),
      userEmail: map['userEmail'],
    );
  }
}
