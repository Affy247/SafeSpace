// lib/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/chat_message.dart';
import '../../services/chat_service.dart';
import '../../services/auth_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  Box? _chatBox;
  bool _loading = false;
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    try {
      _chatBox = Hive.box('chats');
    } catch (e) {
      // box not open? open it
      await Hive.openBox('chats');
      _chatBox = Hive.box('chats');
    }
    setState(() {});
  }

  Future<void> _sendMessage(String text) async {
    final auth = AuthService();
    final userEmail = auth.currentUserEmail;
    if (text.trim().isEmpty || _chatBox == null || userEmail == null) return;

    setState(() => _loading = true);

    final userMsg = {
      'sender': 'user',
      'text': text,
      'timestamp': DateTime.now().toIso8601String(),
      'email': userEmail,
    };
    await _chatBox!.add(userMsg);
    _controller.clear();

    try {
      final replyText = await _chatService.sendMessage(text);
      final botMsg = {
        'sender': 'ai',
        'text': replyText,
        'timestamp': DateTime.now().toIso8601String(),
        'email': userEmail,
      };
      await _chatBox!.add(botMsg);
    } catch (e) {
      final errMsg = {
        'sender': 'ai',
        'text': "⚠️ Error: $e",
        'timestamp': DateTime.now().toIso8601String(),
        'email': userEmail,
      };
      await _chatBox!.add(errMsg);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final userEmail = auth.currentUserEmail;
    if (userEmail == null) {
      return const Scaffold(body: Center(child: Text("Please log in to chat 🌿")));
    }
    if (_chatBox == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.teal)));
    }

    // filter messages by userEmail
    final userMessages = _chatBox!.values.where((v) {
      final m = Map.from(v);
      return m['email'] == userEmail;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Your AI Companion 💬"), backgroundColor: Colors.teal),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _chatBox!.listenable(),
              builder: (context, box, _) {
                final all = box.values.where((v) => Map.from(v)['email'] == userEmail).toList();
                if (all.isEmpty) return const Center(child: Text("Start chatting 💬"));

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: all.length,
                  itemBuilder: (context, index) {
                    final m = Map.from(all[index]);
                    final isUser = m['sender'] == 'user';
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.teal.shade100 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(m['text'] ?? ''),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (_loading) const Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator(color: Colors.teal)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: InputDecoration(hintText: "Talk to your AI listener...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), filled: true, fillColor: Colors.white))),
                IconButton(icon: const Icon(Icons.send, color: Colors.teal), onPressed: () => _sendMessage(_controller.text))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
