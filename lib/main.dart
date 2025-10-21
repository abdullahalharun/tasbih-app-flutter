import 'package:flutter/material.dart';

import 'screens/tasbih_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const IslamicTasbihApp());
}

class IslamicTasbihApp extends StatelessWidget {
  const IslamicTasbihApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Islamic Tasbih',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const TasbihScreen(),
    );
  }
}
