// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main.dart';
import '/providers/loader_provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  // 1. Separate Controllers for Name Fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.spa, size: 80, color: Colors.pinkAccent),
            const SizedBox(height: 20),
            Text(
              isLogin ? "Welcome to LUNA" : "Create your Account",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            if (isLogin) ...[
              const SizedBox(height: 10),
              const Text(
                "Your Menstrual Health Companion",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
            ],

            // 2. Conditional Name Inputs (Sign Up Only)
            if (!isLogin) ...[
              const SizedBox(height: 40),
              _buildNameField(_firstNameController, "First Name"),
              const SizedBox(height: 15),
              _buildNameField(_middleNameController, "Middle Name (Optional)"),
              const SizedBox(height: 15),
              _buildNameField(_lastNameController, "Last Name"),
              const SizedBox(height: 15),
            ],

            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                labelText: "Email Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              controller: _emailController,
            ),
            const SizedBox(height: 15),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              controller: _passwordController,
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () async {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();

                  try {
                    if (isLogin) {
                      LoadingService.show("Logging in...");
                      await supabase.auth.signInWithPassword(
                        email: email,
                        password: password,
                      );
                      LoadingService.hide();
                    } else {
                      // 3. Concatenate names before sending
                      final fName = _firstNameController.text.trim();
                      final mName = _middleNameController.text.trim();
                      final lName = _lastNameController.text.trim();

                      // Format: "First Middle Last" (filters out empty middle names)
                      final fullName = [
                        fName,
                        mName,
                        lName,
                      ].where((name) => name.isNotEmpty).join(' ');

                      if (fName.isEmpty || lName.isEmpty) {
                        throw const AuthException(
                          "Please enter your first and last name.",
                        );
                      }

                      LoadingService.show("Signing up...");
                      await supabase.auth.signUp(
                        email: email,
                        password: password,
                        data: {'full_name': fullName},
                      );

                      if (mounted) {
                        LoadingService.hide();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Registration Success! Check your email.',
                            ),
                          ),
                        );
                      }
                    }
                  } on AuthException catch (error) {
                    LoadingService.hide();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },

                child: Text(
                  isLogin ? "Login" : "Sign Up",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 5. Divider
            const Row(
              children: [
                Expanded(child: Divider()),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),

                  child: Text("OR"),
                ),

                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 20),

            // 6. Google Sign-In Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              icon: const Icon(Icons.login), // Replace with Google icon later

              label: const Text("Continue with Google"),

              onPressed: () {
                LoadingService.show("Signing In...");

                signInWithGoogle();

                LoadingService.hide();
              },
            ),

            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(
                isLogin
                    ? "Don't have an account? Sign Up"
                    : "Already have an account? Login",
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to keep the code clean
  Widget _buildNameField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person_outline),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
