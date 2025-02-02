import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:grouped_list/grouped_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palate_prestige/screens/home_screen.dart';
import 'package:palate_prestige/services/services.dart';

class CodiaPage extends StatefulWidget {
  const CodiaPage({super.key});

  @override
  State<StatefulWidget> createState() => _CodiaPage();
}

class _CodiaPage extends State<CodiaPage> {
  final AuthenticationService _authService = AuthenticationService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/splash-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height *
              0.1, // Adjust this value to move the pizza image down
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              width: MediaQuery.of(context)
                  .size
                  .width, // Set the width to the full width of the screen
              transformAlignment: Alignment.center,
              transform: Matrix4.rotationZ(
                3.1415926535897932 / 2, // Rotate the image
              ),
              child: Image.asset(
                'assets/pizza.png',
                fit: BoxFit.cover,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
        ),
        Positioned(
          left: 15,
          right: 15, // Add this to make the text responsive to screen size
          top: MediaQuery.of(context).size.height *
              0.58, // Position it below the pizza image dynamically
          child: Text(
            'Bringing Happiness with Delicious Food...',
            textAlign: TextAlign.left,
            style: GoogleFonts.lobsterTwo(
              // Use the Google Font here
              textStyle: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 32,
                color: const Color(0xff000000),
                fontWeight: FontWeight.normal,
              ),
            ),
            maxLines: 9999,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Positioned(
          bottom: 40, // Adjust position from the bottom
          left: 30,
          right: 30,
          child: GestureDetector(
            onTap: () async {
              // Handle sign-in logic here
              UserCredential? userCredential =
                  await _authService.signInWithGoogle();

              if (userCredential != null) {
                // Successfully signed in
                // Navigate to the next screen, e.g., home page
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/userInfoPage');
                }
              } else {
                // Sign in failed, show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to sign in with Google')),
                );
              }
              print("Sign in with Google tapped");
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Logo
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SvgPicture.asset(
                      'assets/google-logo.svg', // Path to the Google logo SVG
                      height: 24,
                      width: 24,
                    ),
                  ),
                  // Button Text
                  Text(
                    'Sign in with Google',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
