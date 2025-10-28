// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final email = auth.currentUserEmail ?? 'No email';
    final displayName = auth.currentUser?['displayName'] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text("Profile 👤"), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Email: $email", style: const TextStyle(fontSize: 18)),
          if (displayName != null && displayName.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text("Name: $displayName", style: const TextStyle(fontSize: 18)),
          ],
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              await AuthService().logout();
              if (context.mounted) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text("Log Out"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
          ),
        ]),
      ),
    );
  }
}
