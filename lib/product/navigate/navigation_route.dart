import 'package:flutter/material.dart';
import 'package:notes_app/feature/auth/auth_view.dart';
import 'package:notes_app/feature/splash/splash_view.dart';
import 'package:notes_app/product/navigate/navigation_enums.dart';

class NavigationRoute {
  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name!.navValue) {
      case NavigationEnums.init:
        return _normalNavigate(const SplashView());
      case NavigationEnums.auth:
        return _normalNavigate(const AuthView());
    }
  }

  MaterialPageRoute _normalNavigate(Widget widget, {RouteSettings? settings, bool isFullScreen = false}) {
    return MaterialPageRoute(builder: (context) => widget, settings: settings, fullscreenDialog: isFullScreen);
  }
}
