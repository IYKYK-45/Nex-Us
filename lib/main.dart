import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'auth_screen.dart';
import 'feed.dart';

void main() => runApp(const CampusConnectApp());

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusConnect',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      // Set the starting page
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const MainNavigationHolder(), // Your existing Feed/Nav code
      },
    );
  }
}