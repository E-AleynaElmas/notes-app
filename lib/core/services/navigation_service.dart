import 'package:flutter/material.dart';
import 'package:notes_app/product/constants/typography_constants.dart';
import 'package:notes_app/product/navigate/navigation_enums.dart';
import 'package:notes_app/product/theme/theme_styles.dart';

abstract class INavigationService {
  Future<T?> navigateToPage<T>({required NavigationEnums navEnum, Object? data});
  Future<T?> navigateToPageClear<T>({required NavigationEnums navEnum, Object? data});
  void pop<T extends Object?>([T? object]);
  void showSnackBar(String message, {bool isError = false, int duration = 2});
}

class NavigationService implements INavigationService {
  NavigationService._init();
  static final NavigationService instance = NavigationService._init();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Future<T?> navigateToPage<T>({required NavigationEnums navEnum, Object? data}) async {
    final result = await navigatorKey.currentState?.pushNamed(navEnum.rawValue, arguments: data);
    return result as T?;
  }

  @override
  Future<T?> navigateToPageClear<T>({required NavigationEnums navEnum, Object? data}) async {
    final result = await navigatorKey.currentState?.pushNamedAndRemoveUntil(
      navEnum.rawValue,
      (Route<dynamic> route) => false,
      arguments: data,
    );
    return result as T?;
  }

  @override
  void pop<T extends Object?>([T? object]) {
    navigatorKey.currentState?.pop(object);
  }

  @override
  void showSnackBar(String message, {bool isError = false, int duration = 2}) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: bodyL.white),
          backgroundColor: isError ? ThemeStyles.errorColor : Colors.green,
          duration: Duration(seconds: duration),
        ),
      );
    }
  }
}
