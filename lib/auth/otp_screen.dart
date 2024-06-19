import 'package:FoxySpa/app_colors/app_colors.dart';
import 'package:FoxySpa/auth/reset_password_screen.dart';
import 'package:FoxySpa/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;


    final defaultPinTheme = PinTheme(
      width: width * 0.13,
      height: height * 0.080,
      textStyle: TextStyle(fontSize: 28, color: AppColors.whiteColor, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color:  Colors.transparent,
        border: Border(bottom: BorderSide(width:2,color:AppColors.primaryColor),),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      color:  Colors.transparent,
      border: Border(bottom: BorderSide(width:2,color:AppColors.primaryColor),),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.transparent,
      ),
    );

    return Scaffold(
        backgroundColor: AppColors.lightgreenColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  /// app logo and name
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/auth/Group.svg",
                        semanticsLabel: 'Login Screen Logo',
                        width: width * 0.02,
                        height: height * 0.1,
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
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Booking",
                            style: GoogleFonts.lato(
                              color: AppColors.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    ],
                    
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),

                  /// otp screen image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width * 0.65,
                        height: height * 0.22,
                        child: Image.asset(
                          "assets/auth/87z_2205_w006_n001_76b_p12_76-removebg-preview_2__1_-removebg-preview.png",
                          fit: BoxFit.fill,
                          alignment: Alignment.center,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: height * 0.07,
                  ),
                  Text(
                    "Verification code",
                    style: GoogleFonts.lato(
                      color: AppColors.whiteColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: height * 0.004,),
                  RichText(
                    text: TextSpan(
                        text: "We sent to the e-mail",
                        style: GoogleFonts.lato(
                          fontSize : 15,
                          fontWeight : FontWeight.w400,
                          color : Colors.grey.withOpacity(0.8),
                        ),
                        children: [
                          TextSpan(text:'  '),
                          TextSpan(
                            text: "xxxxxxx@gmail.com",
                            style: GoogleFonts.lato(
                              fontSize : 15,
                              fontWeight : FontWeight.w400,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ]
                    ),
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),

                  ///otp field
                  Center(
                    child:Pinput(
                      autofocus: false,
                      defaultPinTheme: defaultPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      length: 4,
                      showCursor: true,
                      onChanged: (value){
                      },
                    ),
                  ),

                  SizedBox(
                    height: height * 0.028,
                  ),
                  Row(
                    children: [
                      Text("RESEND OTP",style:  GoogleFonts.lato(
                        fontSize : 15,
                        fontWeight : FontWeight.w500,
                        color: AppColors.whiteColor,
                      ),),
                      Icon(Icons.arrow_right,color: AppColors.whiteColor,)
                    ],
                  ),
                  SizedBox(
                    height: height * 0.055,
                  ),

                  /// Verify button
                  RoundButton(name: "Verify", ontap:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen()));

                  })
                ],
              ),
            ),
          ),
        ));
  }

}
