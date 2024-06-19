import 'dart:io';

import 'package:FoxySpa/owner/home/vendor_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_colors/app_colors.dart';
import '../../../common_widget/common_button.dart';

class AddTherapistScreen extends StatefulWidget {
  final String id ;

  const AddTherapistScreen({super.key, required this.id});

  @override
  State<AddTherapistScreen> createState() => _AddTherapistScreenState();
}

class _AddTherapistScreenState extends State<AddTherapistScreen> {
  final nameController = TextEditingController();
  final titleController = TextEditingController();
  final daysController = TextEditingController();
  final hoursController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  File? imageFile;
  bool isLoading = false;

  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(source: source);
    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
      });
    }
  }

  postDetailsToFirestore() async {
    try {
      setState(() {
        isLoading = true;
      });
      var docid = widget.id;
      print("Doc id is -------> ${docid}");

      FirebaseStorage storage = FirebaseStorage.instance;
      print(storage.bucket.toString());
      Reference ref = storage
          .ref()
          .child("Therapist_Images")
          .child("images/${DateTime.now()}");
      UploadTask uploadTask = ref.putFile(imageFile!);
      await uploadTask
          .whenComplete(() => print('Image uploaded to Firebase Storage'));
      String spaURL = await ref.getDownloadURL();
      print('Download URL: $spaURL');
      await FirebaseFirestore.instance.collection("therapist").add({
        "name": nameController.text.toString(),
        "title": titleController.text.toString(),
        "image_url": spaURL.toString(),
        "w_days": daysController.text.toString(),
        "w_hours": hoursController.text.toString(),
        'id': docid.toString(),
      }).then((value) {
        Navigator.pop(context);
        setState(() {
          imageFile = null;
          nameController.clear();
          titleController.clear();
          daysController.clear();
          hoursController.clear();
        });
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    imageFile = null;
    nameController.dispose();
    titleController.dispose();
    daysController.dispose();
    hoursController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Therapist",
          style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.whiteColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.03,
              ),

              Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: InkWell(
                        onTap: () {
                          getImage(source: ImageSource.gallery);
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 38,
                              backgroundImage: imageFile != null
                                  ? FileImage(imageFile!)
                                  : AssetImage(
                                          "assets/user/profile/Ellipse 1015.png")
                                      as ImageProvider<Object>,
                            ),
                            Positioned(
                              top: height * 0.05,
                              right: width * -0.009,
                              child: CircleAvatar(
                                radius: 13,
                                backgroundColor: AppColors.primaryColor,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: AppColors.whiteColor,
                                  size: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),

                    /// name textformfield

                    Text(
                      "Name",
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    TextFormField(
                      controller: nameController,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
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
                            borderSide:
                                BorderSide(color: AppColors.lightgreenColor)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),

                    /// title textformfield
                    Text(
                      "Title",
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    TextFormField(
                      controller: titleController,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
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
                            borderSide:
                                BorderSide(color: AppColors.lightgreenColor)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),

                    /// working hours textformfields
                    Text(
                      "Working Hours",
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width / 2.5,
                          child: TextFormField(
                            controller: daysController,
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              hintText: "Days :",
                              hintStyle: GoogleFonts.lato(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppColors.textformfieldhintColor),
                              suffixIcon: Icon(
                                Icons.calendar_month,
                                color: AppColors.textformfieldhintColor,
                                size: 20,
                              ),
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
                                return 'Days is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: width / 2.5,
                          child: TextFormField(
                            controller: hoursController,
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              hintText: "Hours :",
                              hintStyle: GoogleFonts.lato(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppColors.textformfieldhintColor),
                              suffixIcon: Icon(
                                Icons.watch_later_outlined,
                                color: AppColors.textformfieldhintColor,
                                size: 20,
                              ),
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
                                return 'Hours is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.08,
                    ),
                  ],
                ),
              ),

              /// Savw button
              CommonButton(
                  name: "Save",
                  loading: isLoading,
                  ontap: () {
                      if(_formkey.currentState!.validate()){
                        if( imageFile != null){
                          postDetailsToFirestore();
                        }else{
                          Fluttertoast.showToast(msg: "Please Pick a Service image");
                        }
                      }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
