import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sports_app/screens/sports_category.dart';
import 'package:sports_app/utils/colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Start the timer to change pages every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when disposing
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: [
                buildPage(
                  title: "Welcome to Sports App",
                  description: "Track your favorite sports and teams.",
                  imagePath: 'assets/icons/balls-sports.png',
                ),
                buildPage(
                  title: "Live Scores",
                  description:
                      "Get live updates and scores from ongoing matches.",
                  imagePath: 'assets/icons/score.png',
                ),
                buildPage(
                  title: "Latest News",
                  description: "Stay updated with the latest sports news.",
                  imagePath: 'assets/icons/sports-news.png',
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _controller,
            count: 3,
            effect: const WormEffect(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => CategoryScreen(),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: thirdColor, // Background color
                foregroundColor: secondaryColor, // Foreground (text) color
              ),
              child: const Text(
                "Skip",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage(
      {required String title,
      required String description,
      required String imagePath}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 200, height: 200),
          const SizedBox(height: 32),
          Text(
            title,
            style: const TextStyle(
                fontSize: 28,
                color: secondaryColor,
                fontWeight: FontWeight.bold,
                fontFamily: "Ubuntu"),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: secondaryColor, fontSize: 20, fontFamily: "Rubik"),
          ),
        ],
      ),
    );
  }
}
