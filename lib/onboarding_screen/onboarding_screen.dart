import 'package:FoxySpa/app_colors/app_colors.dart';
import 'package:FoxySpa/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.lightgreenColor,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * 0.5,
                        width: width ,
                        // color: Colors.white,
                        child: Image.asset(
                          "assets/onboarding_screen/onboarding_image-removebg-preview.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Text("Massage",style: GoogleFonts.lato(
                        fontSize:32,
                        fontWeight : FontWeight.w700,
                        color : Colors.white,
                      ),),
                      SizedBox(height: height * 0.02,),
                      SizedBox(
                        width: width / 1.11,
                        child: Text('''Get a personalised hair colour perfect for your skin tone try our different hair styling option''',
                          style: GoogleFonts.lato(
                          fontSize:17,
                          fontWeight : FontWeight.w400,
                          color : Colors.grey.withOpacity(0.8),
                        ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(height: height * 0.065,),

                      InkWell(
                        onTap: (){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()),(route) => false,);
                        },
                        child: Container(
                          height: height * 0.057,
                          width: width / 1.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Get Started",
                              style: GoogleFonts.lato(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
          )),
    );
  }
}
