import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  
  static const _whatsappNumber = '2348071648606';

  Future<void> _openWhatsApp() async {
    final url = Uri.parse(
      "https://wa.me/$_whatsappNumber?text=${Uri.encodeComponent("Hi Affy! I need someone to talk to.")}"
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // show fall-back error
      throw 'Could not open WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Talk to Affy 💬"), backgroundColor: Colors.teal),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.chat), 
          label: const Text("Chat on WhatsApp"),
          onPressed: _openWhatsApp,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            minimumSize: const Size(200, 50),
          ),
        ),
      ),
    );
  }
}
