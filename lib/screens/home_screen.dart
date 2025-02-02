import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:palate_prestige/widgets/loader.dart';
import '../services/services.dart';

class HomeScreen extends StatelessWidget {
  final AuthenticationService _authService = AuthenticationService();
  final User? user = FirebaseAuth.instance.currentUser;
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Hii, ${user!.displayName?.split(' ')[0] ?? 'Fella'}!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(user!.photoURL ?? ''),
                )
              ],
            ),

            const Divider(
              color: Colors.white54,
            ),

            SizedBox(
              height: 30,
            ),

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Text(
                'What are you going to eat today?😉',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            

            // QR Image followed by Scan Button
            Center(
              child: Column(
                children: [
                  // Blurred QR code image
                  // Opacity(
                  //   opacity: 0.8, // Make the image appear blurred
                  //   child: Image.asset(
                  //     'assets/dummy.png', // Replace with your QR code image path
                  //     width: 300, // Adjust size as needed
                  //     height: 300,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),

                  const SizedBox(
                      height: 400,
                      width: 400,
                      child: LottieLoader(url: 'assets/scan.json')),

                  const SizedBox(
                    height: 10,
                  ), // Add space between image and button

                  // Scan QR Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/barCodeScanner');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      shadowColor:
                          Colors.black.withOpacity(0.5), // Shadow opacity
                      backgroundColor: Colors.white, // Opaque background
                      elevation: 2, // Optional: Light shadow
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ), // Adjust padding
                    ),
                    child: Text(
                      "Scan QR",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            ThemeData.light().primaryColor, // Full opacity text
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(), // Pushes "Sign Out" to the bottom

            // Sign Out Button at the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    _authService.signOut();
                    Navigator.of(context).pushReplacementNamed('/authCheck');
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
                  child: const Text("Sign Out"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
