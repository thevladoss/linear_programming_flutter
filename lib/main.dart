import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:window_manager/window_manager.dart';

import 'pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowManager.instance.setMinimumSize(const Size(1000, 500));
    WindowManager.instance.setTitle('Решение задач линейного программирования');
  }
  runApp(
    Phoenix(
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Решение задач линейного программирования',
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: MainPage(),
    );
  }
}
