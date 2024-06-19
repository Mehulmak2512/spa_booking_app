import 'package:FoxySpa/app_colors/app_colors.dart';
import 'package:FoxySpa/auth/login_screen.dart';
import 'package:FoxySpa/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  bool _isObscure = true; // Variable to track password visibility
  bool _isObscureconfirm = true; // Variable to track confirm password visibility

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
        backgroundColor: AppColors.lightgreenColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
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
                        semanticsLabel: 'Logo',
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

                  /// reset password image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/auth/Group 24.svg",
                        semanticsLabel: 'Forget Password Screen image',
                        width: width * 0.04,
                        height: height * 0.2,
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.07,
                  ),
                  Text(
                    "Reset Password..?",
                    style: GoogleFonts.lato(
                      color: AppColors.whiteColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(
                    height: height * 0.035,
                  ),

                  /// password field
                  TextFormField(
                    style: GoogleFonts.lato(),
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Password",
                      hintStyle: GoogleFonts.lato(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.withOpacity(0.8),
                      ),
                      contentPadding: EdgeInsets.all(10),
                      prefixIcon: Icon(Icons.lock_outline_rounded,
                          color: Colors.grey.withOpacity(0.8)),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscure =
                              !_isObscure; // Toggle password visibility
                            });
                          },
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: Colors.grey.withOpacity(0.8),
                          )),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.transparent)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: height * 0.03,
                  ),

                  /// confirm password
                  TextFormField(
                    style: GoogleFonts.lato(),
                    obscureText: _isObscureconfirm,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Confirm Password",
                      hintStyle: GoogleFonts.lato(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.withOpacity(0.8),
                      ),
                      contentPadding: EdgeInsets.all(10),
                      prefixIcon: Icon(Icons.lock_outline_rounded,
                          color: Colors.grey.withOpacity(0.8)),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscureconfirm =
                              !_isObscureconfirm; // Toggle password visibility
                            });
                          },
                          icon: Icon(
                            _isObscureconfirm
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: Colors.grey.withOpacity(0.8),
                          )),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.transparent)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.07,
                  ),

                  /// continue button
                  RoundButton(name: "Continue", ontap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));

                  })

                ],
              ),
            ),
          ),
        ));
  }

}
