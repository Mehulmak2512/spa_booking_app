import 'dart:io';

import 'package:FoxySpa/app_colors/app_colors.dart';
import 'package:FoxySpa/common_widget/common_button.dart';
import 'package:FoxySpa/owner/home/add_service/add_service.dart';
import 'package:FoxySpa/owner/home/vendor_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddServiceScreen extends StatefulWidget {
  final String id ;

  const AddServiceScreen({super.key, required this.id});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {


  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  File? imageFile;
  String? _selectedItem;
  bool isLoading = false;

  final List<String> _items = [
    "Full Body Massage",
    "Foot Massage",
    "Back Massage",
    "Head Massage"
  ];
  String? _selectedPrice;
  final List<String> _prices = [
    "45/Hours",
    "90/Day",
    "150/Weekly",
    "500/Monthly"
  ];

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
          .child("Service_Images")
          .child("images/${DateTime.now()}");
      UploadTask uploadTask = ref.putFile(imageFile!);
      await uploadTask
          .whenComplete(() => print('Image uploaded to Firebase Storage'));
      String spaURL = await ref.getDownloadURL();
      print('Download URL: $spaURL');
      await FirebaseFirestore.instance.collection("services").add({
        "name": _selectedItem.toString(),
        "price": priceController.text.toString(),
        "image_url": spaURL.toString(),
        "description": descriptionController.text.toString(),
        'id': docid.toString(),
      }).then((value) {
        Navigator.pop(context);
        setState(() {
          imageFile = null;
          _selectedItem = null;
          priceController.clear();
          descriptionController.clear();
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
    _selectedItem = null;
    priceController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Services",
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


              Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// service name
                    Text(
                      "Add a Service",
                      style:
                      GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    DropdownButtonFormField2<String>(
                      value: _selectedItem,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.black),
                      isExpanded: true,
                      decoration: InputDecoration(
                        hintText: "Add Service",
                        hintStyle: GoogleFonts.lato(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        contentPadding: EdgeInsets.all(10),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.primaryColor)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.lightgreenColor)),
                      ),
                      items: _items
                          .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: GoogleFonts.lato(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select Service';
                        }
                        return null;
                      },
                      onChanged: (String? value) {
                          _selectedItem = value.toString();

                      },

                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
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
                            color: Colors.white),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.018,
                    ),

                    /// price
                    Text(
                      "Add Price",
                      style:
                      GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    TextFormField(
                      controller: priceController,
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
                            borderSide: BorderSide(color: AppColors.primaryColor)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.lightgreenColor)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    // DropdownButtonFormField2<String>(
                    //   style: GoogleFonts.lato(
                    //       fontWeight: FontWeight.w400,
                    //       fontSize: 15,
                    //       color:Colors.black
                    //   ),
                    //   isExpanded: true,
                    //   decoration: InputDecoration(
                    //     hintText: "Add Price",
                    //     hintStyle: GoogleFonts.lato(
                    //       fontWeight: FontWeight.w500,
                    //       fontSize: 15,
                    //     ),
                    //     contentPadding: EdgeInsets.all(10),
                    //     errorBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //         borderSide: BorderSide(color: Colors.red)),
                    //     focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //         borderSide: BorderSide(color: AppColors.primaryColor)),
                    //     border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //         borderSide: BorderSide(color: AppColors.lightgreenColor)),
                    //
                    //   ),
                    //   items: _prices
                    //       .map((item) => DropdownMenuItem<String>(
                    //     value: item,
                    //     child: Text(
                    //       "\$${item}",
                    //       style: GoogleFonts.lato(
                    //           fontSize: 15, fontWeight: FontWeight.w500),
                    //     ),
                    //   ))
                    //       .toList(),
                    //   validator: (value) {
                    //     if (value == null) {
                    //       return 'Please select price';
                    //     }
                    //     return null;
                    //   },
                    //   onChanged: (value) {
                    //
                    //   },
                    //   onSaved: (value) {
                    //     _selectedPrice = value.toString();
                    //   },
                    //   buttonStyleData: const ButtonStyleData(
                    //     padding: EdgeInsets.only(right: 8),
                    //   ),
                    //   iconStyleData: const IconStyleData(
                    //     icon: Icon(
                    //       Icons.arrow_drop_down,
                    //       color: Colors.black45,
                    //     ),
                    //     iconSize: 20,
                    //   ),
                    //   dropdownStyleData: DropdownStyleData(
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10), color: Colors.white),
                    //   ),
                    //   menuItemStyleData: const MenuItemStyleData(
                    //     padding: EdgeInsets.symmetric(horizontal: 10),
                    //   ),
                    // ),
                    SizedBox(
                      height: height * 0.018,
                    ),

                    /// servie image

                    Text(
                      "Add a Service Image",
                      style:
                      GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    GestureDetector(
                      onTap: () {
                        getImage(source: ImageSource.gallery);
                      },
                      child: Container(
                          height: height * 0.2,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.lightgreenColor,
                            ),
                          ),
                          child: imageFile != null
                              ? Container(
                            height: height * 0.2,
                            width: width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.lightgreenColor,
                                ),
                                image: DecorationImage(
                                    image: FileImage(imageFile!),
                                    fit: BoxFit.fill)),
                          )
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: AppColors.textformfieldhintColor,
                                size: 35,
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Text(
                                "Click here to pick a image",
                                style: GoogleFonts.lato(
                                  color: AppColors.textformfieldhintColor,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          )),
                    ),
                    SizedBox(
                      height: height * 0.018,
                    ),


                    /// Description
                    Text(
                      "Description",
                      style:
                      GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    TextFormField(
                      controller:descriptionController ,
                      maxLines: 5,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: "Write Something here...",
                        hintStyle: GoogleFonts.lato(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: AppColors.textformfieldhintColor),
                        contentPadding: EdgeInsets.all(10),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.primaryColor)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.lightgreenColor)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: height * 0.05,
              ),

              /// continue button

              CommonButton(
                  name: "Save",
                  loading: isLoading,
                  ontap: () {

                     if(_formkey.currentState!.validate()){
                       if(imageFile != null){
                         postDetailsToFirestore();
                       }else{
                         Fluttertoast.showToast(msg: "Please Pick a Service image");
                       }
                     }
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => AddSevice(index: 1)),
                    //     (route) => false);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
