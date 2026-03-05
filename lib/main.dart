import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/feed/feed.dart';


void main() {
  // Ensure Flutter bindings are initialized for system-level changes
  WidgetsFlutterBinding.ensureInitialized();

  // Setting the System Overlay to transparent for a truly immersive UI/UX
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(const CampusSphereApp());
}

class CampusSphereApp extends StatelessWidget {
  const CampusSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusSphere',

      // MOCK-DATA READY THEME:
      // This theme is structured so that changing one color here
      // updates the entire high-fidelity UI instantly.
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6), // Natural Cool Grey from image
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B4EE6), // Natural Electric Purple
          primary: const Color(0xFF6B4EE6),
          surface: Colors.white,
        ),
        // Global text styling for consistency
        fontFamily: 'Roboto', // Professional, clean font choice
      ),

      // ROUTE MANAGEMENT:
      // Essential for a multi-page app. This allows us to jump
      // between Feed, Reels, and Chat seamlessly.
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => const AuthScreen(),
        '/feed': (context) => const FeedScreen(),
      },
    );
  }
}