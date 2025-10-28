import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../../services/auth_service.dart';
import '../home_screen.dart';

// Premium feature screens
import 'music_screen.dart';
import 'videos_screen.dart';
import 'resources_screen.dart';
import 'journal_screen.dart';
import 'contact_screen.dart';
import 'support_screen.dart';

class UpgradeScreen extends StatefulWidget {
  const UpgradeScreen({super.key});

  @override
  State<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  bool _processing = false;
  final _uuid = const Uuid();
  bool _isPremium = false;

  static const String _sandboxCheckout =
      'https://sandbox.flutterwave.com/pay/ywgvpstxxqi9';

  @override
  void initState() {
    super.initState();
    _loadPremium();
  }

  Future<void> _loadPremium() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _isPremium = prefs.getBool('isPremium') ?? false);
  }

  Future<void> _startCheckout() async {
    final uri = Uri.parse(_sandboxCheckout);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open payment page')),
      );
    }
  }

  Future<void> _confirmPaymentAndUnlock() async {
    setState(() => _processing = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremium', true);

    try {
      await AuthService().markAsPremiumForCurrentUser();
    } catch (_) {}

    setState(() {
      _processing = false;
      _isPremium = true;
    });

    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Upgraded ✅'),
        content: const Text(
          'You have been upgraded to Premium! Your new features are now unlocked.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          )
        ],
      ),
    );

    // Go directly back to Home
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  List<Map<String, dynamic>> get features => [
        {
          "icon": Icons.music_note,
          "title": "Relaxing Music 🎶",
          "desc": "Calming tunes",
          "screen": const MusicScreen()
        },
        {
          "icon": Icons.video_library,
          "title": "Motivational Videos 🎥",
          "desc": "Uplifting clips",
          "screen": const VideosScreen()
        },
        {
          "icon": Icons.menu_book,
          "title": "Articles & Books 📚",
          "desc": "Curated reads",
          "screen": const ResourcesScreen()
        },
        {
          "icon": Icons.book_outlined,
          "title": "Journal 🖋️",
          "desc": "Reflective entries",
          "screen": const JournalScreen()
        },
        {
          "icon": Icons.chat_bubble_outline,
          "title": "Talk to Affy 💬",
          "desc": "Personal contact (WhatsApp)",
          "screen": const ContactScreen()
        },
        {
          "icon": Icons.phone,
          "title": "Support Lines 📞",
          "desc": "Helplines across Africa",
          "screen": const SupportScreen()
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upgrade to Premium 💎"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Unlock Premium content and support",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: features.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final f = features[index];
                  return GestureDetector(
                    onTap: () {
                      if (_isPremium) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => f['screen']));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Locked — upgrade to access 💎')),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.teal, width: 0.6),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(f['icon'], size: 36, color: Colors.teal.shade700),
                          const SizedBox(height: 8),
                          Text(f['title'],
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(f['desc'],
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _startCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.open_in_new),
              label: const Text(
                "Proceed to Payment (Sandbox)",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed:
                  (_processing || _isPremium) ? null : _confirmPaymentAndUnlock,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: _processing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.verified),
              label: const Text(
                "I've paid — Unlock features",
                style: TextStyle(fontSize: 16),
              ),
            ),
            if (_isPremium)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '✅ Premium active — enjoy your features',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
