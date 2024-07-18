// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_app/screens/sports_category.dart';
import 'package:sports_app/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneNumberController = TextEditingController();
  final _otpController = TextEditingController();
  String? _generatedOtp;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(labelText: 'OTP'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyOtp,
                    child: const Text('Verify OTP'),
                  ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateOtp,
              child: const Text('Generate OTP'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _googleLogin,
              child: SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.google,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Login with Google'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateOtp() {
    final random = Random();
    _generatedOtp = (random.nextInt(9000) + 1000).toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your OTP'),
        content: Text('$_generatedOtp'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _verifyOtp() async {
    if (_otpController.text == _generatedOtp) {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        _isLoading = false;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('loginType', 'phone');
      prefs.setString('phoneNumber', _phoneNumberController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CategoryScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Invalid OTP'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _googleLogin() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
    try {
      var result = await _googleSignIn.signIn();
      if (result != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setString('loginType', 'google');
        prefs.setString('firstName', result.displayName?.split(' ')[0] ?? '');
        prefs.setString('lastName', result.displayName?.split(' ')[1] ?? '');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CategoryScreen(),
          ),
        );
      }
    } catch (error) {
      print(error);
    }
  }
}
