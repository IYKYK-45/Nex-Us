import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // Animation controller for the logo "Pop" effect
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // SETUP: Initialize animation for a playful, responsive UI entry
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // Gives that "Superior" playful feel
    );

    _controller.forward();

    // NAVIGATION: Auto-transition to Auth after branding exposure
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Performance optimization: Clean up controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // UI DESIGN: Using the natural palette directly for maximum performance
    const Color primaryPurple = Color(0xFF6B4EE6);

    return Scaffold(
      backgroundColor: Colors.white, // Clean white start
      body: Stack(
        children: [
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // LOGO: Using a Container with Shadow for depth (UI/UX Depth Principle)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryPurple,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryPurple.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.school_rounded, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'CampusSphere',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900, // Ultra-bold for brand presence
                      color: primaryPurple,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // DYNAMIC LOADING: Positioned at the bottom for better visual weight
          Align(
            alignment: const Alignment(0, 0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 150,
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    backgroundColor: Color(0xFFF3F4F6),
                    valueColor: AlwaysStoppedAnimation<Color>(primaryPurple),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Connecting Campus...',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}