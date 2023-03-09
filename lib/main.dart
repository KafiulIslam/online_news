import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:online_news_app/utils/color.dart';
import 'package:online_news_app/views/auth/login.dart';
import 'package:online_news_app/views/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: const LoginScreen(),
    );
  }
}


