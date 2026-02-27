import 'package:flutter/material.dart';

/// [AuthScreen] - A modular authentication page providing both Signup and Login.
/// This screen uses a TabBar to switch views without changing the route.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // TextEditingControllers manage the state of the input fields.
  // They allow us to retrieve the text when the user clicks 'Sign In' or 'Get Started'.
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Local state to toggle the 'obscureText' property for the password field.
  bool _isPasswordHidden = true;

  @override
  void dispose() {
    // Standard Practice: Always dispose controllers to prevent memory leaks.
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // DefaultTabController handles the synchronization between the TabBar and TabBarView.
    return DefaultTabController(
      length: 2, // 0: Create Account, 1: Log In
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F4F8), // Background color from UI design
        body: Column(
          children: [
            // Branding Section: Occupies top 35% of the screen.
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'Nex.us',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF101213),
                ),
              ),
            ),

            // Interaction Card: Contains the Tabs and the Input Forms.
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    // TabBar: Provides the clickable headers for navigation.
                    const TabBar(
                      labelColor: Color(0xFF101213),
                      unselectedLabelColor: Color(0xFF57636C),
                      indicatorColor: Color(0xFF4B39EF), // Signature purple color
                      indicatorWeight: 3,
                      tabs: [
                        Tab(text: 'Create Account'),
                        Tab(text: 'Log In'),
                      ],
                    ),

                    // TabBarView: Switches the displayed widget based on the selected Tab.
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildAuthForm(isCreateAccount: true),
                          _buildAuthForm(isCreateAccount: false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// [_buildAuthForm] - Generates the form UI based on the auth mode.
  /// Using one method for both reduces code duplication (DRY principle).
  Widget _buildAuthForm({required bool isCreateAccount}) {
    return SingleChildScrollView(
      // SingleChildScrollView prevents "Bottom Overflow" when the keyboard covers the UI.
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCreateAccount ? 'Create Account' : 'Welcome Back',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            isCreateAccount
                ? "Let's get started by filling out the form below."
                : "Fill out the information below in order to access your account.",
            style: const TextStyle(color: Color(0xFF57636C)),
          ),
          const SizedBox(height: 24),

          // Phone Input
          _buildTextField(
            label: "Phone number",
            controller: _phoneController,
          ),
          const SizedBox(height: 16),

          // Password Input with Visibility Toggle
          _buildTextField(
            label: "Password",
            controller: _passwordController,
            isPassword: true,
            // Suffix icon acts as the toggle for 'obscureText'.
            icon: IconButton(
              icon: Icon(_isPasswordHidden
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
              onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
            ),
          ),
          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // To-Do: Implement Firebase/Database validation here.
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B39EF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                elevation: 3,
              ),
              child: Text(isCreateAccount ? 'Get Started' : 'Sign In'),
            ),
          ),

          // Show "Forgot Password" only on the Login tab.
          if (!isCreateAccount) ...[
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  // To-Do: Navigate to Password Reset Screen.
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Color(0xFF101213), fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  /// Helper widget to build consistent TextFields.
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    Widget? icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _isPasswordHidden : false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF57636C)),
        // Custom styling for the rounded border seen in the design.
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Color(0xFFF1F4F8), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Color(0xFF4B39EF), width: 2),
        ),
        suffixIcon: icon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}