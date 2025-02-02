import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieLoader extends StatelessWidget {
  final String url;
  const LottieLoader({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          url,  
          repeat: true
          
        ),
      ),
    );
  }
}