import 'package:FoxySpa/common_widget/common_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:FoxySpa/app_colors/app_colors.dart';
import 'package:FoxySpa/user/profile/profile_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  bool _isObscureold = true;
  bool _isObscurenew = true;
  bool _isObscureconfirm = true;

  bool loading = false;



  changepassword() async {

    String oldPassword = _oldPasswordController.text;
    String confirmNewPassword = _confirmNewPasswordController.text;

    try {
      setState(() {
        loading = true;
      });
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: oldPassword,
        );
        await currentUser.reauthenticateWithCredential(credential);
        // Password re-authentication succeeded, now update password
        await _auth.currentUser!.updatePassword(confirmNewPassword).then((value) {
          _oldPasswordController.clear();
          _newPasswordController.clear();
          _confirmNewPasswordController.clear();
        });
        Fluttertoast.showToast(msg: 'Password updated successfully!');
      }
    } on  FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: e.message.toString());
  }finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          /// old password
                          Text(
                            "Old Password",
                            style: GoogleFonts.lato(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          TextFormField(
                            controller: _oldPasswordController,
                            style: GoogleFonts.lato(),
                            obscureText: _isObscureold,
                            decoration: InputDecoration(
                              hintText: "Old Password",
                              hintStyle: GoogleFonts.lato(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.grey.withOpacity(0.8),
                              ),
                              prefixIcon: Icon(Icons.lock_outline_rounded,
                                  color: Colors.grey.withOpacity(0.8)),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscureold =
                                          !_isObscureold; // Toggle password visibility
                                    });
                                  },
                                  icon: Icon(
                                    _isObscureold
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    color: Colors.grey.withOpacity(0.8),
                                  )),
                              contentPadding: EdgeInsets.all(10),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: AppColors.primaryColor)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: AppColors.lightgreenColor)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your old password';
                              } else if (value.length < 6) {
                                return 'Old Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),

                          /// new password
                          Text(
                            "New Password",
                            style: GoogleFonts.lato(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          TextFormField(
                            controller: _newPasswordController,
                            style: GoogleFonts.lato(),
                            obscureText: _isObscurenew,
                            decoration: InputDecoration(
                              hintText: "New Password",
                              hintStyle: GoogleFonts.lato(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.grey.withOpacity(0.8),
                              ),
                              prefixIcon: Icon(Icons.lock_outline_rounded,
                                  color: Colors.grey.withOpacity(0.8)),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscurenew =
                                          !_isObscurenew; // Toggle password visibility
                                    });
                                  },
                                  icon: Icon(
                                    _isObscurenew
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    color: Colors.grey.withOpacity(0.8),
                                  )),
                              contentPadding: EdgeInsets.all(10),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: AppColors.primaryColor)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: AppColors.lightgreenColor)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a new password';
                              } else if (value.length < 6) {
                                return 'New Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),

                          /// confirm new password
                          Text(
                            " Confirm New Password",
                            style: GoogleFonts.lato(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          TextFormField(
                            controller: _confirmNewPasswordController,
                            style: GoogleFonts.lato(),
                            obscureText: _isObscureconfirm,
                            decoration: InputDecoration(
                              hintText: "Confirm New Password",
                              hintStyle: GoogleFonts.lato(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.grey.withOpacity(0.8),
                              ),
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
                              contentPadding: EdgeInsets.all(10),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: AppColors.primaryColor)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: AppColors.lightgreenColor)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Confirm new password';
                              }else if(value != _newPasswordController.text){
                                return 'Passwords do not match';
                              } else if (value.length < 6) {
                                return 'Confirm New Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                        ],
                      )),
                  SizedBox(
                    height: height * 0.07,
                  ),

                  /// save button
                  CommonButton(
                      loading: loading,
                      name: "Save", ontap: (){
                    if(_formKey.currentState!.validate()){
                      changepassword();
                    }
                  }
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  bool isValidEmail(String value) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    return emailRegex.hasMatch(value);
  }
}
