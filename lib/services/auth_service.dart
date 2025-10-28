import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  static const String _authBoxName = 'authBox';
  static const String _usersBoxName = 'users';

  static late Box _authBox;
  static late Box _usersBox;

  
  static Future<void> init() async {
    _authBox = await Hive.openBox(_authBoxName);
    _usersBox = await Hive.openBox(_usersBoxName);
  }

  /// Register (sign up) a new user. Returns null on success, or error string.
  Future<String?> register(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return "Please provide email and password.";
    }
    if (_usersBox.containsKey(email)) {
      return "Account already exists. Please log in.";
    }

    final uid = const Uuid().v4();
    final user = {
      'uid': uid,
      'email': email,
      'password': password,
      'isPremium': false,
      'displayName': null,
    };

    await _usersBox.put(email, user);
    await _authBox.put('currentUser', user);
    await _authBox.put('loggedIn', true);
    return null;
  }

  /// Login an existing user. Returns null on success else error string.
  Future<String?> login(String email, String password) async {
    if (!_usersBox.containsKey(email)) {
      return "No account found. Please sign up.";
    }

    final user = Map<String, dynamic>.from(_usersBox.get(email) as Map);
    if (user['password'] != password) {
      return "Incorrect password.";
    }

    // Sync premium status
    await _authBox.put('currentUser', user);
    await _authBox.put('loggedIn', true);
    return null;
  }

  /// Logout current user
  Future<void> logout() async {
    await _authBox.put('loggedIn', false);
    await _authBox.delete('currentUser');
  }

  /// Whether current user is logged in
  bool get isLoggedIn => _authBox.get('loggedIn', defaultValue: false) as bool;

  /// Current user email
  String? get currentUserEmail {
    final user = _authBox.get('currentUser');
    return user != null ? Map<String, dynamic>.from(user)['email'] as String? : null;
  }

  /// Current user id
  String? get currentUserId {
    final user = _authBox.get('currentUser');
    return user != null ? Map<String, dynamic>.from(user)['uid'] as String? : null;
  }

  /// Full current user object
  Map<String, dynamic>? get currentUser {
    final user = _authBox.get('currentUser');
    return user != null ? Map<String, dynamic>.from(user) : null;
  }

  
  Future<void> refreshUserSession() async {
    final email = currentUserEmail;
    if (email == null) return;

    final latest = _usersBox.get(email);
    if (latest != null) {
      await _authBox.put('currentUser', Map<String, dynamic>.from(latest));
    }
  }

 
  Future<void> markAsPremiumForCurrentUser() async {
    final user = currentUser;
    if (user == null) return;

    user['isPremium'] = true;

    await _authBox.put('currentUser', user);
    await _usersBox.put(user['email'], user);
  }

  
  bool get isPremium {
    final user = currentUser;
    if (user == null) return false;

    // Re-sync with latest info if outdated
    final email = user['email'];
    if (email != null && _usersBox.containsKey(email)) {
      final latest = Map<String, dynamic>.from(_usersBox.get(email));
      return latest['isPremium'] == true;
    }

    return user['isPremium'] == true;
  }

  /// Update display name
  Future<void> updateDisplayName(String newName) async {
    final user = currentUser;
    if (user == null) return;
    user['displayName'] = newName;
    await _authBox.put('currentUser', user);
    await _usersBox.put(user['email'], user);
  }
}
