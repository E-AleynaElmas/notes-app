// lib/core/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthService {
  Stream<User?> authState();
  Future<User?> login({required String email, required String password});
  Future<User?> signup({required String email, required String password});
  Future<void> logout();
  User? currentUser();
}

class AuthService implements IAuthService {
  AuthService._init(this._auth);
  static final AuthService _instance = AuthService._init(FirebaseAuth.instance);

  static AuthService get instance => _instance;
  final FirebaseAuth _auth;

  @override
  Stream<User?> authState() => _auth.authStateChanges();

  @override
  Future<User?> login({required String email, required String password}) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
    return cred.user;
  }

  @override
  Future<User?> signup({required String email, required String password}) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
    return cred.user;
  }

  @override
  Future<void> logout() => _auth.signOut();

  @override
  User? currentUser() => _auth.currentUser;
}
