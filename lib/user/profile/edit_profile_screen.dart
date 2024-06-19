import 'dart:io';

import 'package:FoxySpa/common_widget/common_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:FoxySpa/app_colors/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String docid;
  const EditProfileScreen({
    super.key,
    required this.docid,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobilenoController = TextEditingController();

  String? imageUrl;
  File? imageFile;


  bool isLoading = false;
  bool loading = true;

  getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(source: source);
    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
      });
    }
  }

  getUserDetails() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.docid)
        .get();
    setState(() {
      imageUrl = ds.get("image_url");
      nameController.text = ds.get("name");
      emailController.text = ds.get("email");
      mobilenoController.text = ds.get("mobile_no");
      loading = false;

    });
  }

  updateUserDetails() async {
    try {
      isLoading = true;
      if (imageFile != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage
            .ref()
            .child("User_profile_images")
            .child("images/${DateTime.now()}");
        UploadTask uploadTask = ref.putFile(imageFile!);
        await uploadTask.whenComplete(
            () => debugPrint("Image Uploaded to firebase Storage"));
        imageUrl = await ref.getDownloadURL();
        debugPrint("Download URL $imageUrl");
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.docid)
          .update({
        "image_url": imageUrl.toString(),
        "name": nameController.text,
        "mobile_no": mobilenoController.text,
      }).then((value) {
        setState(() {
          imageFile = null;
        });
        Fluttertoast.showToast(msg: "Profile updated successfully..");
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: loading ? Center(child: CircularProgressIndicator(),):SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  /// Profile Image with background image
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      /// background image
                      Container(
                        height: height * 0.23,
                        width: width,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/user/profile/profile_bg_image.png"),
                                fit: BoxFit.fill)),
                      ),

                      /// Profile Image
                      Positioned(
                        top: height * 0.17,
                        left: width * 0.36,
                        child: GestureDetector(
                          onTap: () {
                            getImage(source: ImageSource.gallery);
                            setState(() {

                            });
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: imageFile == null ?  imageUrl != null && imageUrl!.isNotEmpty ? NetworkImage(imageUrl!) as ImageProvider<Object> :  null : FileImage(imageFile!),
                            child: imageFile == null ? Icon(Icons.person,color: AppColors.whiteColor,size: 50,): null,
                            // backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                            //     ? NetworkImage(imageUrl!)
                            //     : imageFile != null
                            //     ? FileImage(imageFile!) as ImageProvider
                            //     : AssetImage("assets/user/profile/Ellipse 1015.png"),
                          ),
                        ),
                      ),
                      Positioned(
                          top: height * 0.25,
                          left: width * 0.55,
                          child: CircleAvatar(
                            radius: 13,
                            backgroundColor: AppColors.primaryColor,
                            child: Icon(
                              Icons.camera_alt,
                              color: AppColors.whiteColor,
                              size: 17,
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: height * 0.09,
                  ),

                  /// name , email and Mobile no
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// name
                        Text(
                          "Name",
                          style: GoogleFonts.lato(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),

                        TextFormField(
                          controller: nameController,
                          style: GoogleFonts.lato(),
                          decoration: InputDecoration(
                            hintText: "Mark Adair",
                            hintStyle: GoogleFonts.lato(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                            contentPadding: EdgeInsets.all(10),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.red)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: AppColors.primaryColor)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: AppColors.lightgreenColor)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),

                        /// Email
                        Text(
                          "Email",
                          style: GoogleFonts.lato(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),

                        TextFormField(
                          controller: emailController,
                          readOnly: true,
                          style: GoogleFonts.lato(),
                          decoration: InputDecoration(
                            hintText: "xxxxxxxxx@gmail.com",
                            hintStyle: GoogleFonts.lato(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                            contentPadding: EdgeInsets.all(10),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.red)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: AppColors.primaryColor)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: AppColors.lightgreenColor)),
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
                          height: height * 0.005,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline_outlined,
                              color: Colors.red,
                            ),
                            Text(
                              "We can't change the email".padLeft(27),
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),

                        /// Mobile No.
                        Text(
                          "Mobile No.",
                          style: GoogleFonts.lato(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),

                        TextFormField(
                          controller: mobilenoController,
                          style: GoogleFonts.lato(),
                          decoration: InputDecoration(
                            hintText: "+91 xxxxxxxxxx",
                            hintStyle: GoogleFonts.lato(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                            contentPadding: EdgeInsets.all(10),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.red)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: AppColors.primaryColor)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: AppColors.lightgreenColor)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Number is required';
                            } else if (value.length != 13) {
                              return "Enter Valid Number";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: height * 0.1,
            ),

            /// save button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: CommonButton(
                loading: isLoading,
                name: "Save",
                ontap: () {
                  if (_formKey.currentState!.validate()) {
                     updateUserDetails();
                  }
                },
              ),
            )
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
