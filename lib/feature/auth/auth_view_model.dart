import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:notes_app/product/services/auth_service.dart';

enum AuthMode { login, signup }

class AuthViewModel extends BaseViewModel {
  final IAuthService _auth;
  AuthMode mode = AuthMode.login;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final pass2Controller = TextEditingController();

  bool obscure = true;

  final List<TextInputFormatter> emailFormatters = [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
  final List<TextInputFormatter> passwordFormatters = [
    FilteringTextInputFormatter.deny(RegExp(r'\s')),
    LengthLimitingTextInputFormatter(16),
  ];

  AuthViewModel({IAuthService? auth}) : _auth = auth ?? AuthService.instance;

  void switchMode() {
    mode = mode == AuthMode.login ? AuthMode.signup : AuthMode.login;
    notifyListeners();
  }

  void toggleObscure() {
    obscure = !obscure;
    notifyListeners();
  }


  String? validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'E-posta gir';
    final regex = RegExp(r'^[\w\.\-+]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (!regex.hasMatch(v)) return 'Geçerli e-posta gir';
    return null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Şifre gir';
    if (v.length < 6) return 'En az 6 karakter';
    return null;
  }

  String? validateConfirm(String? v) {
    if (mode == AuthMode.login) return null;
    if (v == null || v.isEmpty) return 'Şifre tekrar gerekli';
    if (v != passController.text) return 'Şifreler eşleşmiyor';
    return null;
  }

  Future<bool> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    setBusy(true);
    clearErrors();
    try {
      if (mode == AuthMode.login) {
        await _auth.login(email: emailController.text.trim(), password: passController.text);
      } else {
        await _auth.signup(email: emailController.text.trim(), password: passController.text);
      }
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setBusy(false);
    }
  }

  Future<void> logout() => _auth.logout();
  String? get uid => _auth.currentUser()?.uid;



  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    pass2Controller.dispose();
    super.dispose();
  }
}
