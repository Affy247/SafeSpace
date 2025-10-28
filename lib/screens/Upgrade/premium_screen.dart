import 'package:flutter/material.dart';
import 'music_screen.dart';
import 'videos_screen.dart';
import 'resources_screen.dart';
import 'journal_screen.dart';
import 'contact_screen.dart';
import 'support_screen.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {"icon": Icons.music_note, "title": "Relaxing Music", "screen": const MusicScreen()},
      {"icon": Icons.video_library, "title": "Motivational Videos", "screen": const VideosScreen()},
      {"icon": Icons.menu_book, "title": "Articles & Books", "screen": const ResourcesScreen()},
      {"icon": Icons.book_outlined, "title": "Journal", "screen": const JournalScreen()},
      {"icon": Icons.chat_bubble_outline, "title": "Talk to Nana", "screen": const ContactScreen()},
      {"icon": Icons.phone, "title": "Support Lines", "screen": const SupportScreen()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Premium Hub 💎"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final f = features[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => f["screen"] as Widget));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(f["icon"] as IconData, size: 40, color: Colors.teal.shade700),
                    const SizedBox(height: 12),
                    Text(f["title"] as String,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
