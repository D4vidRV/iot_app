import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iot_app/config/router/app_router.dart';
import 'package:iot_app/config/theme/app_theme.dart';

void main() => runApp(const ProviderScope(
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const isDarkMode = false;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme(isDarkMode: isDarkMode).getTheme(),
      title: 'Iot App',
      routerConfig: appRouter,
    );
  }
}
