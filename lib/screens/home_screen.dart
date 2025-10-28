import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';
import 'Upgrade/upgrade_screen.dart';

// Existing screens
import 'insights_screen.dart';
import 'mood_screen.dart';
import 'wellness_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

// Premium screens
import 'Upgrade/music_screen.dart';
import 'Upgrade/videos_screen.dart';
import 'Upgrade/resources_screen.dart';
import 'Upgrade/support_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isPremium = false;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _loadPremiumStatus();
  }

  Future<void> _loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _isPremium = prefs.getBool('isPremium') ?? false);
  }

  Future<void> _logout() async {
    await _auth.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {
        'title': 'Insights 💡',
        'icon': Icons.analytics_outlined,
        'color': Colors.teal.shade100,
        'screen': const InsightScreen(),
        'premium': false,
      },
      {
        'title': 'Mood Journal 📝',
        'icon': Icons.edit_note_outlined,
        'color': Colors.pink.shade100,
        'screen': const MoodScreen(),
        'premium': false,
      },
      {
        'title': 'Wellness 🌿',
        'icon': Icons.spa_outlined,
        'color': Colors.green.shade100,
        'screen': const WellnessScreen(),
        'premium': false,
      },
      {
        'title': 'Chat Companion 🤖',
        'icon': Icons.chat_bubble_outline,
        'color': Colors.blue.shade100,
        'screen': const ChatScreen(),
        'premium': false,
      },
      {
        'title': 'Profile 👤',
        'icon': Icons.person_outline,
        'color': Colors.orange.shade100,
        'screen': const ProfileScreen(),
        'premium': false,
      },

      // PREMIUM FEATURES
      {
        'title': 'Relaxing Music 🎶',
        'icon': Icons.music_note_outlined,
        'color': Colors.purple.shade100,
        'screen': const MusicScreen(),
        'premium': true,
      },
      {
        'title': 'Therapy Videos 🎬',
        'icon': Icons.video_library_outlined,
        'color': Colors.indigo.shade100,
        'screen': const VideosScreen(),
        'premium': true,
      },
      {
        'title': 'Resources 📚',
        'icon': Icons.menu_book_outlined,
        'color': Colors.amber.shade100,
        'screen': const ResourcesScreen(),
        'premium': true,
      },
      {
        'title': 'Support ☎️',
        'icon': Icons.support_agent_outlined,
        'color': Colors.red.shade100,
        'screen': const SupportScreen(),
        'premium': true,
      },
      {
        'title': 'Upgrade 🌟',
        'icon': Icons.upgrade_rounded,
        'color': Colors.teal.shade100,
        'screen': const UpgradeScreen(),
        'premium': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("SafeSpace 🪷"),
        backgroundColor: Colors.teal,
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 2;
            double width = constraints.maxWidth;

            if (width > 1200) crossAxisCount = 5;
            else if (width > 800) crossAxisCount = 4;
            else if (width > 600) crossAxisCount = 3;

            return GridView.builder(
              itemCount: features.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final feature = features[index];
                final isLocked = feature['premium'] && !_isPremium;

                return GestureDetector(
                  onTap: () {
                    if (isLocked) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UpgradeScreen()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => feature['screen']),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: feature['color'],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(feature['icon'], size: 40, color: Colors.teal.shade700),
                            const SizedBox(height: 12),
                            Text(
                              feature['title'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (isLocked)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.lock, color: Colors.grey, size: 30),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
