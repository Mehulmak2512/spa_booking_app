import 'dart:io';
import 'package:FoxySpa/app_colors/app_colors.dart';
import 'package:FoxySpa/auth/login_screen.dart';
import 'package:FoxySpa/common_widget/round_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../owner/vendor_total_spa_screen.dart';
import '../user/bottomnavigatorbar/home_page.dart';
import '../user/home/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {


  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobilenoController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  File? imageFile;

  String? _selectedItem;

  final List<String> _items = ['Customer','Owner'];

  bool _isObscure = true; // Variable to track password visibility

  final FirebaseAuth _auth = FirebaseAuth.instance;
  var firerbaseFirestore = FirebaseFirestore.instance;


  signup(String email, String password,String acctype) async {
    setState(() {
      isLoading = true;
    });

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "Email and password cannot be empty");
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
         await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) async {
        // User creation successful, now post details to Firestore
        await postDetailsToFirestore();
        if(acctype == "Customer"){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return  HomePage(index: 0);
          }));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return  VendorTotalSpaScreen();
          }));
        }
        Fluttertoast.showToast(msg: "Welcome to FoxySpa ${emailController.text.toString()}");
      });


    } catch (error) {
      // Handle specific Firebase authentication errors
      String errorMessage = "An error occurred. Please try again later.";
      if (error is FirebaseAuthException) {
        errorMessage = error.message!;
      }
      Fluttertoast.showToast(msg: errorMessage);
      print("Error during signup: $error");

    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  postDetailsToFirestore() async{
    try{
      setState(() {
        isLoading = true;
      });
      String uid =  FirebaseAuth.instance.currentUser!.uid.toString();
      await FirebaseFirestore.instance.collection("users").add({
        "accoun_type":_selectedItem.toString(),
        "name":nameController.text.toString(),
        "email":emailController.text.toString(),
        "mobile_no":mobilenoController.text.toString(),
        "image_url": "",
        'id': uid,
      }).then((value) {
        setState(() {
          _selectedItem = null;
          nameController.clear();
          emailController.clear();
          mobilenoController.clear();
          passwordController.clear();
        });
      });
    }on FirebaseException catch(e){
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message.toString());
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _selectedItem = null;
    nameController.dispose();
    emailController.dispose();
    mobilenoController.dispose();
    passwordController.dispose();
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
                children: [
                  SizedBox(
                    height: height * 0.03,
                  ),

                  /// SignUp Screen Logo
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.07,
                  ),

                  /// Sign up text
                  Text(
                    "SIGN UP",
                    style: GoogleFonts.lato(
                      color: AppColors.whiteColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),



                  Form(
                      key: _formKey,
                      child: Column(
                    children: [
                      /// account type
                      DropdownButtonFormField2<String>(
                        isExpanded: true,
                        value: _selectedItem,
                        decoration: InputDecoration(
                          hintText: "Choose",
                          hintStyle: GoogleFonts.lato(
                            fontWeight: FontWeight.w300,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                          contentPadding: EdgeInsets.all(10),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.transparent)),
                          filled: true,
                          fillColor: Colors.white,
                        ),

                        items: _items
                            .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style:  GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight : FontWeight.w500
                            ),
                          ),
                        ))
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select Account Type';
                          }
                          return null;
                        },
                        onChanged: (String? value) {
                          _selectedItem = value;

                        },

                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right:8),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 20,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),

                      /// Name
                      TextFormField(
                        controller: nameController,
                        style: GoogleFonts.lato(),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Name",
                          hintStyle: GoogleFonts.lato(
                            fontWeight: FontWeight.w300,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                          contentPadding: EdgeInsets.all(10),
                          prefixIcon: Icon(Icons.person_outline,
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
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),

                      /// Email
                      TextFormField(
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
                      SizedBox(
                        height: height * 0.03,
                      ),

                      /// Mobile No
                      TextFormField(
                        controller: mobilenoController,
                        style: GoogleFonts.lato(),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Mobile No.",
                          hintStyle: GoogleFonts.lato(
                            fontWeight: FontWeight.w300,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                          contentPadding: EdgeInsets.all(10),
                          prefixIcon: Icon(Icons.call_outlined,
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
                            return 'Phone No. is required';
                          }else if(value.length != 13){
                            return 'Enter the Valid Number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),

                      /// Password
                      TextFormField(
                        controller: passwordController,
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
                    ],
                  )),


                  SizedBox(height: height * 0.06,),

                  /// Sign Up Button
                  RoundButton(name: "Sign Up",
                      loading: isLoading,
                      ontap: (){
                    if(_formKey.currentState!.validate()){
                            signup(emailController.text.toString(), passwordController.text.toString(),_selectedItem.toString());
                    }
                  }),
                  SizedBox(height: height * 0.05,),

                  /// Login Text
                  InkWell(
                    onTap: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()),(route)=> false);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Already Have an Account?",
                        style: GoogleFonts.lato(
                          fontSize : 15,
                          fontWeight : FontWeight.w400,
                          color: AppColors.whiteColor,
                        ),
                        children: [
                          TextSpan(text:'  '),
                          TextSpan(
                            text: "Login",
                            style: GoogleFonts.lato(
                              fontSize : 15,
                              fontWeight : FontWeight.w400,
                              color: AppColors.primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ]
                    ),
                    ),
                  ),
                  SizedBox(height: height * 0.06,),

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
