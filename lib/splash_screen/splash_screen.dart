import 'package:FoxySpa/app_colors/app_colors.dart';
import 'package:FoxySpa/splash_screen/splash_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServices.isLogin(context);
  }
  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: AppColors.lightgreenColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/auth/Group.svg",
                semanticsLabel: 'Logo',
                height: height * 0.21,
              ),
              SizedBox(
                width: width * 0.035,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Foxy Spa",
                    style: GoogleFonts.lato(
                      color: AppColors.primaryColor,
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Booking",
                    style: GoogleFonts.lato(
                      color: AppColors.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),

    );
  }
}
