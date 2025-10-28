import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  // 🎥 Grouped video resources
  final Map<String, List<Map<String, String>>> _categories = const {
    "Mindful Meditation 🧘‍♀️": [
      {
        "title": "Finding Clarity in Chaos 🌤️",
        "url": "https://www.youtube.com/watch?v=Fk9EBOOAYiU"
      },
      {
        "title": "Calm Your Mind in 10 Minutes 🌿",
        "url": "https://www.youtube.com/watch?v=inpok4MKVLM"
      },
      {
        "title": "Breathing Space: Guided Meditation 🌬️",
        "url": "https://www.youtube.com/watch?v=SEfs5TJZ6Nk"
      },
      {
        "title": "Morning Mindfulness ☀️",
        "url": "https://www.youtube.com/watch?v=ZToicYcHIOU"
      },
      {
        "title": "Evening Release Meditation 🌙",
        "url": "https://www.youtube.com/watch?v=sG7DBA-mgFY"
      },
    ],
    "Cognitive Balance 🧠": [
      {
        "title": "You Are Enough 💪",
        "url": "https://www.youtube.com/watch?v=pfcEhO6Y9xI"
      },
      {
        "title": "Healing and Growth 🌱",
        "url": "https://www.youtube.com/watch?v=VvPbCKH0qL8"
      },
      {
        "title": "Overcoming Fear and Doubt 💭",
        "url": "https://www.youtube.com/watch?v=6H1h1Qy_iX0"
      },
      {
        "title": "Building Emotional Resilience 🧩",
        "url": "https://www.youtube.com/watch?v=1o30Ps-_8is"
      },
      {
        "title": "Changing Negative Thought Patterns 🔄",
        "url": "https://www.youtube.com/watch?v=G0zJGDokyWQ"
      },
    ],
    "Distraction & Uplift 🌈": [
      {
        "title": "Let Go & Be Present 🍃",
        "url": "https://www.youtube.com/watch?v=cEqZthCaMpo"
      },
      {
        "title": "5-Minute Stress Relief 🕊️",
        "url": "https://www.youtube.com/watch?v=MIr3RsUWrdo"
      },
      {
        "title": "Joyful Focus ✨",
        "url": "https://www.youtube.com/watch?v=O-6f5wQXSu8"
      },
      {
        "title": "Mind Reset for a Better Day 🔆",
        "url": "https://www.youtube.com/watch?v=VaoV1PrYft4"
      },
      {
        "title": "Positive Energy Booster 💫",
        "url": "https://www.youtube.com/watch?v=3qK7m6Pv4lk"
      },
    ],
  };

  Future<void> _openVideo(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not open video.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wellness Videos 🎥"),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: _categories.entries.map((entry) {
          final category = entry.key;
          final videos = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),
                ...videos.map((video) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.play_circle_outline, color: Colors.teal, size: 30),
                      title: Text(video["title"]!),
                      subtitle: Text(category),
                      onTap: () => _openVideo(video["url"]!),
                    ),
                  );
                }),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
