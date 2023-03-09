import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:online_news_app/utils/color.dart';
import 'package:online_news_app/utils/constant_widget.dart';
import 'package:online_news_app/utils/image_path.dart';
import 'package:online_news_app/views/auth/login.dart';
import 'package:online_news_app/views/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var _userId = await secureStorage.read(key: 'user_id');
  runApp(MyApp(userId: _userId,));
}

class MyApp extends StatelessWidget {
  final String? userId;
  const MyApp({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Global News',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: scaffoldColor,
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
          duration: 1000,
          splash: appLogo,
          nextScreen: userId == null ? const LoginScreen() : const Home(),
          splashTransition: SplashTransition.scaleTransition,
          backgroundColor: Colors.white),
    );
  }
}


