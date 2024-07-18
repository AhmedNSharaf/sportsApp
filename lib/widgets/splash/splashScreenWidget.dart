// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sports_app/screens/on_boarding_screen.dart';
import 'package:sports_app/utils/colors.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // Set the system UI to immersive mode, which hides the status and navigation bars
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Schedule a function to be executed after a 2-second delay
    Future.delayed(const Duration(seconds: 2), () {
      // After the delay, navigate to the HomeScreen and replace the current screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const OnboardingScreen(),
      ));
    });
  }

  @override
  void dispose() {
    // Restore the system UI to its normal state when the splash screen is disposed
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a Container to set a gradient background
      body: Container(
        width: double.infinity, // Make the container take up the full width
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, thirdColor], // Gradient colors
            begin: Alignment.topRight, // Gradient starts from top right
            end: Alignment.bottomLeft, // Gradient ends at bottom left
          ),
        ),
        // Center the content vertically and horizontally
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the splash screen icon
            Image.asset(
              'assets/icons/balls-sports.png',
              width: 120, // Set the width of the icon
              height: 120, // Set the height of the icon
            ),
            const SizedBox(
              height: 20, // Add space between the icon and the text
            ),
            // Display the app title
            const Text(
              'Sports App',
              style: TextStyle(
                color: Colors.white, // Set the text color to white
                fontSize: 30, // Set the font size
                fontFamily: "Rubik", // Set the font style to italic
              ),
            ),
          ],
        ),
      ),
    );
  }
}
