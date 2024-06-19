import 'package:FoxySpa/auth/otp_screen.dart';
import 'package:FoxySpa/common_widget/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_colors/app_colors.dart';
import 'login_screen.dart';


class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool loading = false;


  void forgetpassword(String email)async{


    try{
      setState(() {
        loading = true;
      });
      await _auth.sendPasswordResetEmail(email: email.trim())
          .then((value) => {
        debugPrint("Link sent to the email"),
        Fluttertoast.showToast(msg: "We sent a Forget Passoword link to the email ${email}"),

        Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()))
      }).onError((error, stackTrace) => {
        Fluttertoast.showToast(msg: error.toString()),

      });
    }on FirebaseException catch (e) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: e.message.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
  }


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
                        semanticsLabel: 'app Logo',
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

                  /// forget password image
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
                    "Forgot Password..?",
                    style: GoogleFonts.lato(
                      color: AppColors.whiteColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: height * 0.004,),
                  Text(
                    "Enter the email to recover the password",
                    style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.035,
                  ),
                  /// Email field
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: emailController,
                      style: GoogleFonts.lato(),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Email",
                        hintStyle: GoogleFonts.lato(
                            fontWeight: FontWeight.w300,
                            color: Colors.grey.withOpacity(0.8)),
                        contentPadding: EdgeInsets.all(10),
                        prefixIcon: Icon(Icons.mark_email_unread_outlined,
                            color: Colors.grey.withOpacity(0.8)),
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
                          return 'Please enter an email';
                        }
                        if (!isValidEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * 0.07,
                  ),

                  /// Continue Button
                  RoundButton(name: "Continue", loading: loading,
                      ontap: (){
                    if(_formKey.currentState!.validate()){
                      forgetpassword(emailController.text);
                    }

                  }),
                ],
              ),
            ),
          ),
        ));
  }

  bool isValidEmail(String value) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    return emailRegex.hasMatch(value);
  }
}
