import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

class WellnessScreen extends StatefulWidget {
  const WellnessScreen({super.key});

  @override
  State<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen> {
  final localAffirmations = [
    "You are enough 🌸",
    "Peace begins with a deep breath 🌿",
    "You’re doing your best — and that’s enough 💖",
    "Every emotion is valid 🌦️",
    "Bad days don’t define you 🌙",
    "You have survived 100% of your worst days 🌼",
  ];

  String currentAffirmation = "Loading inspiration... 🌤️";
  int _index = 0;
  bool _fetching = false;
  late Box _affirmationBox;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _initWellness();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _initWellness() async {
    // Open Hive box for caching quotes
    _affirmationBox = await Hive.openBox('affirmationBox');

    // Load from cache if available
    final cachedQuote = _affirmationBox.get('lastAffirmation');
    if (cachedQuote != null) {
      setState(() => currentAffirmation = cachedQuote);
    } else {
      setState(() => currentAffirmation = localAffirmations[_index]);
    }

    // Fetch new quote on start
    _fetchOnlineAffirmation();

    // Refresh new online quotes every 30 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _fetchOnlineAffirmation();
    });

    // Rotate local affirmations every 10 seconds as fallback
    Timer.periodic(const Duration(seconds: 10), (_) {
      _showNextAffirmation();
    });
  }

  Future<void> _fetchOnlineAffirmation() async {
    if (_fetching) return;
    setState(() => _fetching = true);

    try {
      final response =
          await http.get(Uri.parse('https://type.fit/api/quotes')).timeout(
                const Duration(seconds: 8),
                onTimeout: () => throw Exception('Timeout'),
              );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final randomQuote = (data..shuffle()).first;
        final quote =
            "${randomQuote['text']} — ${randomQuote['author'] ?? 'Unknown'}";

        setState(() => currentAffirmation = quote);
        await _affirmationBox.put('lastAffirmation', quote);
      } else {
        _useLocalFallback();
      }
    } catch (e) {
      _useLocalFallback();
    } finally {
      setState(() => _fetching = false);
    }
  }

  void _useLocalFallback() {
    setState(() {
      currentAffirmation = localAffirmations[_index];
    });
  }

  void _showNextAffirmation() {
    _index = (_index + 1) % localAffirmations.length;
    if (!_fetching) _useLocalFallback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Wellness 🌺"), backgroundColor: Colors.teal),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Take a mindful pause 🧘🏽‍♀️",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  currentAffirmation,
                  key: ValueKey(currentAffirmation),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _fetching ? null : _fetchOnlineAffirmation,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                icon: _fetching
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.refresh),
                label: const Text("New Affirmation"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
