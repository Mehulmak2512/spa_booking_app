import 'dart:async';
import 'package:FoxySpa/onboarding_screen/onboarding_screen.dart';
import 'package:FoxySpa/owner/vendor_total_spa_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../user/bottomnavigatorbar/home_page.dart';

class SplashServices{

  isLogin(context) async {

    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userType = prefs.getString('userType');
    print("user type -------> ${userType}");

    if(user != null) {

      if (userType == "Customer") {
        // Navigate to customer home page
        Timer(
          Duration(seconds: 3),
              () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(index: 0)),
          ),
        );
      } else if (userType == "Owner") {
        // Navigate to vendor home page
        Timer(
          Duration(seconds: 3),
              () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VendorTotalSpaScreen()),
          ),
        );
      } else {
        // Unknown user type or no type assigned
        Timer(
          Duration(seconds: 3),
              () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OnBoardingScreen()),
          ),
        );
      }
    }
    else Timer(
      Duration(seconds: 3),() =>
        Navigator.push(context, MaterialPageRoute(builder: (context) => OnBoardingScreen(),
        ),
        ),
    );
  }
}