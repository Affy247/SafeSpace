import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _controller = TextEditingController();
  final Box _journalBox = Hive.box('authBox');

  void _saveEntry() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final List entries = _journalBox.get('journal', defaultValue: []);
    entries.add({
      'text': text,
      'date': DateTime.now().toString(),
    });
    _journalBox.put('journal', entries);
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final entries = List.from(_journalBox.get('journal', defaultValue: []));

    return Scaffold(
      appBar: AppBar(title: const Text("Journal ✍️"), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Write your thoughts...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveEntry,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text("Save Entry"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final e = entries[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(e['text']),
                      subtitle: Text(DateTime.parse(e['date']).toLocal().toString()),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
