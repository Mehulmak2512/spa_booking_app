import 'package:FoxySpa/auth/login_screen.dart';
import 'package:FoxySpa/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app_colors/app_colors.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foxy Spa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: AppColors.lightgreenColor,iconTheme: IconThemeData(color: Colors.white,)),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.lightgreenColor),
        primaryColor: AppColors.lightgreenColor,
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

