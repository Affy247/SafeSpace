import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  // 📞 Regional Helplines (2 per country)
  final Map<String, List<Map<String, String>>> _regionalHelplines = const {
    "Nigeria 🇳🇬": [
      {"title": "Lifeline Nigeria", "number": "+234 809 111 1262"},
      {"title": "Mentally Aware Nigeria Initiative (MANI)", "number": "+234 706 245 5399"},
    ],
    "Kenya 🇰🇪": [
      {"title": "Befrienders Kenya", "number": "+254 722 178 177"},
      {"title": "Chiromo Mental Health Line", "number": "+254 790 502 376"},
    ],
    "South Africa 🇿🇦": [
      {"title": "SADAG Mental Health Line", "number": "+27 800 567 567"},
      {"title": "LifeLine South Africa", "number": "+27 861 322 322"},
    ],
    "Ghana 🇬🇭": [
      {"title": "MindIT Ghana", "number": "+233 302 246 140"},
      {"title": "Lifeline Ghana", "number": "+233 20 999 9993"},
    ],
  };

  // 💬 Therapy Chat & Online Support (links)
  final List<Map<String, String>> _therapyChats = const [
    {
      "title": "7 Cups – Free Online Chat with Trained Listeners",
      "url": "https://www.7cups.com/"
    },
    {
      "title": "iCall (Free Confidential Online Counseling)",
      "url": "https://icallhelpline.org/"
    },
    {
      "title": "Mental Health Foundation – Chat Support",
      "url": "https://www.mentalhealth.org.uk/getting-help"
    },
    {
      "title": "BetterHelp (Professional Therapy Online)",
      "url": "https://www.betterhelp.com/"
    },
    {
      "title": "Manas Foundation – NGO Counseling Chat",
      "url": "https://www.manas.org.in/"
    },
  ];

  Future<void> _callNumber(String number) async {
    final uri = Uri(scheme: "tel", path: number);
    if (!await launchUrl(uri)) {
      throw 'Could not dial $number';
    }
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not open link.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Support & Helplines ☎️"),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: [
          // 🧭 Regional Helplines
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Regional Helplines 🌍",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          ..._regionalHelplines.entries.map((entry) {
            final country = entry.key;
            final lines = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    country,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...lines.map((line) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.phone, color: Colors.teal),
                        title: Text(line["title"]!),
                        subtitle: Text(line["number"]!),
                        onTap: () => _callNumber(line["number"]!),
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                ],
              ),
            );
          }),

          const Divider(thickness: 1.2, color: Colors.teal),

          // 💬 Therapy Chat & Online Support
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Therapy Chat & Online Support 💬",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          ..._therapyChats.map((chat) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.chat_bubble_outline, color: Colors.teal),
                title: Text(chat["title"]!),
                onTap: () => _openLink(chat["url"]!),
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
