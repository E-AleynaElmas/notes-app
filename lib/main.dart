import 'package:flutter/material.dart';
import 'package:notes_app/core/services/navigation_service.dart';
import 'package:notes_app/product/init/application_init.dart';
import 'package:notes_app/product/navigate/navigation_route.dart';
import 'package:notes_app/product/theme/theme_styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appInit = ApplicationInit();
  await appInit.firstlyInit();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.instance.navigatorKey,
      onGenerateRoute: NavigationRoute().generateRoute,
      theme: ThemeStyles.darkTheme(context),
    );
  }
}
