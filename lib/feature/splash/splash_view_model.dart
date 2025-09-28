import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/core/services/navigation_service.dart';
import 'package:stacked/stacked.dart';
import 'package:notes_app/product/services/auth_service.dart';
import 'package:notes_app/product/navigate/navigation_enums.dart';

class SplashViewModel extends BaseViewModel {
  final IAuthService _auth;
  final NavigationService _nav;
  StreamSubscription<User?>? _sub;
  bool _done = false;

  SplashViewModel({IAuthService? auth, NavigationService? nav})
    : _auth = auth ?? AuthService.instance,
      _nav = nav ?? NavigationService.instance;

  void start() {
    final u = _auth.currentUser();
    _route(u != null);

    _sub = _auth.authState().listen((user) => _route(user != null));
  }

  void _route(bool loggedIn) {
    if (_done) return;
    _done = true;
    _nav.navigateToPageClear(navEnum: loggedIn ? NavigationEnums.home : NavigationEnums.auth);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}