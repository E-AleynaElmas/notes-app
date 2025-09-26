import 'package:flutter/material.dart';
import 'package:notes_app/product/navigate/navigation_enums.dart';

abstract class INavigationService {
  Future<T?> navigateToPage<T>({required NavigationEnums navEnum, Object? data});
  Future<T?> navigateToPageClear<T>({required NavigationEnums navEnum, Object? data});
  void pop<T extends Object?>([T? object]);
}

class NavigationService implements INavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Future<T?> navigateToPage<T>({required NavigationEnums navEnum, Object? data}) async {
    return await navigatorKey.currentState?.pushNamed(navEnum.rawValue, arguments: data);
  }

  @override
  Future<T?> navigateToPageClear<T>({required NavigationEnums navEnum, Object? data}) async {
    return await navigatorKey.currentState?.pushNamedAndRemoveUntil(
      navEnum.rawValue,
      (Route<dynamic> route) => false,
      arguments: data,
    );
  }

  @override
  void pop<T extends Object?>([T? object]) {
    navigatorKey.currentState?.pop(object);
  }
}
