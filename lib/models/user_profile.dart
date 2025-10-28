// lib/models/user_profile.dart
class UserProfile {
  final String uid;
  final String? displayName;
  final String? photoUrl;

  UserProfile({required this.uid, this.displayName, this.photoUrl});
}
