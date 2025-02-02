import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart'; // After successful login
import '../services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatelessWidget {
  final AuthenticationService _authService = AuthenticationService();

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Call the Google Sign-In method
            UserCredential? userCredential =
                await _authService.signInWithGoogle();

            if (userCredential != null) {
              // Successfully signed in
              // Navigate to the next screen, e.g., home page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            } else {
              // Sign in failed, show an error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to sign in with Google')),
              );
            }
          }, //signInWithGoogle(context)
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
