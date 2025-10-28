import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final AudioPlayer _player = AudioPlayer();
  String? _currentTrack;

  final List<Map<String, String>> _tracks = [
    // 🌿 Calm & Clarity
    {"title": "Peaceful Morning ☀️", "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"},
    {"title": "Calm Waters 🌊", "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3"},
    {"title": "Mindful Breeze 🍃", "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3"},
    {"title": "Still Reflections 💧", "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3"},
    {"title": "Moments of Clarity 🌤️", "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3"},

    // ⚡ Energy & Focus
    {"title": "Creative Flow 🔥", "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3"},
    {"title": "Rise & Grind 💪", "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3"},
    {"title": "Motivated Mind 🧠", "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3"},
    {"title": "Purpose Drive 🚀", "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3"},
    {"title": "Energy Flow ⚡", "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3"},

    // 🌙 Sleep & Healing
    {"title": "Night Serenity 🌙", "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3"},
    {"title": "Dream Drift ✨", "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3"},
    {"title": "Deep Rest 💤", "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3"},
    {"title": "Healing Vibes 🌺", "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3"},
    {"title": "Tranquil Dreams ☁️", "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3"},
  ];

  Future<void> _playMusic(String url, String title) async {
    try {
      await _player.stop();
      await _player.play(UrlSource(url));
      setState(() => _currentTrack = title);
    } catch (e) {
      // Fallback handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't play this track. Try another!")),
      );
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relaxing Music 🎧"),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: _tracks.length,
        itemBuilder: (context, index) {
          final track = _tracks[index];
          return ListTile(
            leading: const Icon(Icons.music_note, color: Colors.teal),
            title: Text(track["title"]!),
            trailing: _currentTrack == track["title"]
                ? const Icon(Icons.pause_circle_filled, color: Colors.teal)
                : const Icon(Icons.play_circle_fill, color: Colors.teal),
            onTap: () => _playMusic(track["url"]!, track["title"]!),
          );
        },
      ),
    );
  }
}
