import 'package:flutter/material.dart';
import 'package:luna_prototype/providers/loader_provider.dart';
import 'package:luna_prototype/screens/home/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_page.dart'; // Your login page

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // This listens to the auth state changes (login, logout, etc.)
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // 1. Show a loading spinner while checking the session
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // 2. Check if we have a valid session
        final session = snapshot.data?.session;
        
        LoadingService.show("Please wait...");

        if (session != null) {
          return const HomePage(); 
        } else {
          return const AuthPage();
        }
      },
    );
  }
}