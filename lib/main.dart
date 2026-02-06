import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_wrapper.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://nfdxoyejxokkueeqlqhq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5mZHhveWVqeG9ra3VlZXFscWhxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAzODIzNDcsImV4cCI6MjA4NTk1ODM0N30.QGwTo5Iaf4EhN06MGcK0A9nm_3Zs4lxdvS97vE5Fkio',
  );
  runApp(const ProviderScope(child: Luna()));
}

Future<void> signInWithGoogle() async {
  // 1. Configure the Google Sign-In parameters
  final googleSignIn = GoogleSignIn(
    // The Web Client ID is required for Supabase even on mobile
    serverClientId:
        '150135974029-8f35im5pfsn4kv3akbd14den8p853r8o.apps.googleusercontent.com',
  );

  // 2. Start the native Google Sign-In flow
  final googleUser = await googleSignIn.signIn();
  final googleAuth = await googleUser!.authentication;

  // 3. Authenticate with Supabase using the ID Token
  await Supabase.instance.client.auth.signInWithIdToken(
    provider: OAuthProvider.google,
    idToken: googleAuth.idToken!,
    accessToken: googleAuth.accessToken,
  );
}

final supabase = Supabase.instance.client;

class Luna extends StatefulWidget {
  const Luna({super.key});

  @override
  State<Luna> createState() => _LunaState();
}

class _LunaState extends State<Luna> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}
