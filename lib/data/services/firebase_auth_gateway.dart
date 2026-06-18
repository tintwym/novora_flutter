import 'package:firebase_auth/firebase_auth.dart';

import '../../firebase_options.dart';

/// Thin wrapper around [FirebaseAuth] so [AuthService] stays testable.
///
/// Does **not** touch [FirebaseAuth.instance] unless [isEnabled] — production
/// web builds without Firebase keys must keep using Spring session cookies.
class FirebaseAuthGateway {
  FirebaseAuthGateway({FirebaseAuth? auth}) : _authOverride = auth;

  final FirebaseAuth? _authOverride;

  static bool get isEnabled => DefaultFirebaseOptions.isActive;

  FirebaseAuth? get _auth {
    if (_authOverride != null) return _authOverride;
    if (!isEnabled) return null;
    return FirebaseAuth.instance;
  }

  User? get currentUser => _auth?.currentUser;

  Stream<User?> authStateChanges() =>
      _auth?.authStateChanges() ?? const Stream<User?>.empty();

  Future<UserCredential> signIn(String email, String password) {
    final auth = _auth;
    if (auth == null) {
      throw StateError('Firebase Auth is not configured');
    }
    return auth.signInWithEmailAndPassword(email: email.trim(), password: password);
  }

  Future<UserCredential> signUp(String email, String password) {
    final auth = _auth;
    if (auth == null) {
      throw StateError('Firebase Auth is not configured');
    }
    return auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
  }

  Future<String?> idToken({bool forceRefresh = false}) async {
    final user = _auth?.currentUser;
    if (user == null) return null;
    return user.getIdToken(forceRefresh);
  }

  Future<void> signOut() async {
    await _auth?.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) {
    final auth = _auth;
    if (auth == null) {
      throw StateError('Firebase Auth is not configured');
    }
    return auth.sendPasswordResetEmail(email: email.trim());
  }
}
