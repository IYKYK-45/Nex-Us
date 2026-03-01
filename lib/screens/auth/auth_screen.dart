import 'package:flutter/material.dart';

/// [AuthScreen] - A high-fidelity authentication portal for Nex.us.
/// Implements a dual-form architecture with independent state management
/// for Login and Registration to ensure 0% data collision.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  // --- CONTROLLER MANAGEMENT ---
  // Separate controllers ensure 'Sign Up' data never leaks into 'Login' fields.
  final TextEditingController _signupPhoneController = TextEditingController();
  final TextEditingController _signupPasswordController = TextEditingController();

  final TextEditingController _loginPhoneController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  // --- UI STATE ---
  bool _isLoginTab = false; // Tracks current active view
  bool _isPasswordVisible = false; // Toggles password masking

  @override
  void dispose() {
    // DISPOSAL: Crucial for performance to prevent memory leaks in the background.
    _signupPhoneController.dispose();
    _signupPasswordController.dispose();
    _loginPhoneController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // NATURAL COLORS: Extracted from the provided UI Mockups
    const Color primaryPurple = Color(0xFF6B4EE6);
    const Color backgroundGrey = Color(0xFFF3F4F6);

    return Scaffold(
      backgroundColor: backgroundGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // BRANDING HEADER: Using a spacious container for brand prominence
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'Nex.us',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: -1.0,
                ),
              ),
            ),

            // INTERACTION CARD: The primary white interaction surface
            Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.65),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // CUSTOM TAB SELECTOR: Optimized for high-precision touch targets
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTabButton("Create Account", active: !_isLoginTab, onTap: () => setState(() => _isLoginTab = false)),
                      _buildTabButton("Log In", active: _isLoginTab, onTap: () => setState(() => _isLoginTab = true)),
                    ],
                  ),

                  const Divider(thickness: 1, color: Color(0xFFEEEEEE)),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _isLoginTab ? _buildLoginForm() : _buildSignupForm(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// REUSABLE TAB BUTTON: Uses local state to drive the visual indicator.
  Widget _buildTabButton(String title, {required bool active, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: active ? Colors.black : Colors.grey.shade600,
              ),
            ),
          ),
          // ACTIVE INDICATOR: The purple bar from the mockup
          Container(
            height: 3,
            width: 140,
            decoration: BoxDecoration(
              color: active ? const Color(0xFF6B4EE6) : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  /// SIGNUP FORM: Features dynamic instructional text and isolated controllers.
  Widget _buildSignupForm() {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text("Let's get started by filling out the form below.", style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
        const SizedBox(height: 30),
        _buildTextField("Phone number", _signupPhoneController),
        const SizedBox(height: 20),
        _buildTextField("Password", _signupPasswordController, isPassword: true),
        const SizedBox(height: 40),
        _buildActionButton("Get Started"),
      ],
    );
  }

  /// LOGIN FORM: Streamlined for returning users.
  Widget _buildLoginForm() {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Welcome Back", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text("Fill out the information below in order to access your account.", style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
        const SizedBox(height: 30),
        _buildTextField("Phone number", _loginPhoneController),
        const SizedBox(height: 20),
        _buildTextField("Password", _loginPasswordController, isPassword: true),
        const SizedBox(height: 40),
        _buildActionButton("Sign In"),
        const SizedBox(height: 20),
        const Center(child: Text("Forgot Password?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      ],
    );
  }

  /// HIGH-FIDELITY TEXTFIELD: Implements rounded borders and visibility toggles.
  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFF6B4EE6), width: 2)),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        )
            : null,
      ),
    );
  }

  /// DYNAMIC ACTION BUTTON: Triggers the transition to the main Feed.
  Widget _buildActionButton(String title) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () => Navigator.pushReplacementNamed(context, '/feed'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6B4EE6),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}