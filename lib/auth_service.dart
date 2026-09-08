// Temporary Local Authentication Service
// Firebase chara local testing er jonno simple auth manager

class AuthService {
  // Singleton instance - sob page theke eki data access kora jabe
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Temporary local user store: Email -> Password
  final Map<String, String> _users = {
    // Permanent testing account (jekono somoi login kora jabe)
    'aust@gmail.com': '123456',
    'student@qampus.com': '123456',
  };

  // Current logged in user email
  String? _currentUserEmail;
  String? get currentUserEmail => _currentUserEmail;

  // 1. Sign Up Function: Notun account save kore
  bool signUp(String email, String password) {
    String cleanEmail = email.trim().toLowerCase();
    if (_users.containsKey(cleanEmail)) {
      return false; // Account already ache
    }
    _users[cleanEmail] = password;
    return true;
  }

  // 2. Login Function: Email ar Password match kore
  bool login(String email, String password) {
    String cleanEmail = email.trim().toLowerCase();
    if (_users.containsKey(cleanEmail) && _users[cleanEmail] == password) {
      _currentUserEmail = cleanEmail;
      return true;
    }
    return false;
  }

  // 3. User exist kore kina check korar function
  bool userExists(String email) {
    return _users.containsKey(email.trim().toLowerCase());
  }

  // 4. Logout Function: Session clear kore
  void logout() {
    _currentUserEmail = null;
  }
}
