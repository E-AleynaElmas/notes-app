import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/product/manager/network_manager.dart';

abstract class IAuthService {
  Stream<User?> authState();
  Future<User?> login({required String email, required String password});
  Future<User?> signup({required String email, required String password});
  Future<void> logout();
  User? currentUser();
  Future<String?> getIdToken();
  Future<void> initializeAuth();
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
    if (cred.user != null) {
      final token = await cred.user!.getIdToken();
      if (token != null) {
        NetworkManager.instance.setToken(token);
      }
    }
    return cred.user;
  }

  @override
  Future<User?> signup({required String email, required String password}) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
    if (cred.user != null) {
      final token = await cred.user!.getIdToken();
      if (token != null) {
        NetworkManager.instance.setToken(token);
      }
    }
    return cred.user;
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
    NetworkManager.instance.setToken('');
  }

  @override
  User? currentUser() => _auth.currentUser;

  @override
  Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  @override
  Future<void> initializeAuth() async {
    final user = _auth.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      if (token != null) {
        NetworkManager.instance.setToken(token);
      }
    }
  }
}
