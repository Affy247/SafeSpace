import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  // 📚 Grouped mental wellness resources (16 total)
  final Map<String, List<Map<String, String>>> _categories = const {
    "Mindset & Growth 🧘‍♀️": [
      {
        "title": "How to Reset a Tough Day",
        "url": "https://tinybuddha.com/blog/how-to-reset-your-day-when-everything-goes-wrong/"
      },
      {
        "title": "Building Self-Belief & Confidence",
        "url": "https://jamesclear.com/self-confidence"
      },
      {
        "title": "The Gifts of Imperfection – Brené Brown",
        "url": "https://www.goodreads.com/book/show/7015403-the-gifts-of-imperfection"
      },
      {
        "title": "Daily Growth Tips: Tiny Wins Matter",
        "url": "https://jamesclear.com/atomic-habits"
      },
      {
        "title": "Mini Affirmations to Start Your Morning 🌤️",
        "url": "https://www.healthline.com/health/mental-health/positive-affirmations"
      },
      {
        "title": "Ikigai – The Japanese Secret to a Long and Happy Life",
        "url": "https://www.goodreads.com/book/show/40534545-ikigai"
      },
    ],
    "Healing & Emotional Wellness 💚": [
      {
        "title": "Understanding Emotional Burnout",
        "url": "https://psychcentral.com/health/emotional-burnout"
      },
      {
        "title": "Healing from Overwhelm & Anxiety",
        "url": "https://www.mindful.org/meditation-for-anxiety/"
      },
      {
        "title": "The Power of Now – Eckhart Tolle",
        "url": "https://www.goodreads.com/book/show/6708.The_Power_of_Now"
      },
      {
        "title": "Emotional Agility – Susan David",
        "url": "https://www.goodreads.com/book/show/29093331-emotional-agility"
      },
      {
        "title": "Mindfulness for Beginners",
        "url": "https://www.mindful.org/meditation/mindfulness-getting-started/"
      },
    ],
    "Focus & Productivity 🎯": [
      {
        "title": "Atomic Habits – James Clear",
        "url": "https://jamesclear.com/atomic-habits"
      },
      {
        "title": "How to Regain Focus in a Distracted World",
        "url": "https://www.nytimes.com/guides/smarterliving/how-to-focus-at-work"
      },
      {
        "title": "Deep Work – Cal Newport Summary",
        "url": "https://www.samuelthomasdavies.com/book-summaries/self-help/deep-work/"
      },
      {
        "title": "The Subtle Art of Not Giving a F*ck – Mark Manson",
        "url": "https://markmanson.net/books/subtle-art"
      },
      {
        "title": "Digital Detox: How to Unplug & Recharge",
        "url": "https://www.verywellmind.com/benefits-of-a-digital-detox-4769961"
      },
    ],
  };

  Future<void> _openResource(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not open resource.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resources 📚"),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: _categories.entries.map((entry) {
          final category = entry.key;
          final items = entry.value;
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
                ...items.map((item) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.menu_book, color: Colors.teal, size: 28),
                      title: Text(item["title"]!),
                      subtitle: Text(category),
                      onTap: () => _openResource(item["url"]!),
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
