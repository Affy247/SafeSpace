import 'auth_service.dart';

class ProfileService {
  final _auth = AuthService();

  String? get currentUserEmail => _auth.currentUserEmail;
  String? get currentUserId => _auth.currentUserId;

  /// Log out the user
  Future<void> signOut() async {
    await _auth.logout();
  }
}
