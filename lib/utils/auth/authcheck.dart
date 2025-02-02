import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:palate_prestige/screens/codia_page.dart';
import 'package:palate_prestige/utils/auth/userCheck.dart';
import '../../screens/home_screen.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Listen to the Firebase authentication state
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the snapshot has user data, the user is signed in
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            // If no user, route to SplashScreen (or SignIn screen)
            return const CodiaPage();
          } else {
            // If a user is logged in, route to HomeScreen
            return const UserInfoPage();
          }
        } else {
          // Show a loading indicator while waiting for the auth state
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
