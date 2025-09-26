import 'package:flutter/material.dart';
import 'package:notes_app/product/init/application_init.dart';

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
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
