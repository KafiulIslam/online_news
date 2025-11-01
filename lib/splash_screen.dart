import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_news_app/utils/image_path.dart';
import 'package:online_news_app/views/auth/login.dart';
import 'package:online_news_app/views/home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _checkUserLogin();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  //using firebase

  void _checkUserLogin() {
    final User? user = FirebaseAuth.instance.currentUser;

    Timer(const Duration(seconds: 2), () {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Home()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 400), () {
      lightStatusBar();
    });
    return Scaffold(
      body: Center(
        child: Image.asset(appLogo),
      ),
    );
  }

  void lightStatusBar() async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
      ),
    );
  }
}
