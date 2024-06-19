import 'dart:io';

import 'package:FoxySpa/owner/vendor_total_spa_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../app_colors/app_colors.dart';
import '../common_widget/common_button.dart';

class AddSpaScreen extends StatefulWidget {
  const AddSpaScreen({super.key});

  @override
  State<AddSpaScreen> createState() => _AddSpaScreenState();
}

class _AddSpaScreenState extends State<AddSpaScreen> {


  final spanameController = TextEditingController();
  final flatbuildingController = TextEditingController();
  final areastreetController = TextEditingController();
  final towncityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? _selectedItem;
  final List<String> _items = ['Open', 'Close'];
  File? imageFile;


  void getImage({required ImageSource source}) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile?.path != null) {
      setState(() {
        imageFile = File(pickedFile!.path);
      });
    }
  }

  postDetailsToFirestore() async{
    try{
      setState(() {
        isLoading = true;
      });
      String uid =  FirebaseAuth.instance.currentUser!.uid.toString();

      FirebaseStorage storage = FirebaseStorage.instance;
      print(storage.bucket.toString());
      Reference ref = storage.ref().child("Spa_Profile_Images").child("images/${DateTime.now()}");
      UploadTask uploadTask = ref.putFile(imageFile!);
      await uploadTask.whenComplete(() => print('Image uploaded to Firebase Storage'));
      String spaURL = await ref.getDownloadURL();
      print('Download URL: $spaURL');
      await FirebaseFirestore.instance.collection("spas").add({
        "image_url": spaURL.toString(),
        "spa_name":spanameController.text.toString(),
        "flat_building":flatbuildingController.text.toString(),
        "area_street":areastreetController.text.toString(),
        "town_city":towncityController.text.toString(),
        "status":_selectedItem.toString(),
        'id': uid,
      }).then((value) {
        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => VendorTotalSpaScreen()), (route) => false);
        Navigator.pop(context);
        setState(() {
          imageFile = null;
          spanameController.clear();
          flatbuildingController.clear();
          areastreetController.clear();
          towncityController.clear();
          _selectedItem = null;
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
    imageFile = null;
    spanameController.dispose();
    flatbuildingController.dispose();
    areastreetController.dispose();
    towncityController.dispose();
    _selectedItem = null;
  }

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      height: height * 0.68,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(15))),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


         Form(
           key: _formKey,
           child: Column(
             children: [
               Center(
                 child: GestureDetector(
                   onTap: () {
                     getImage(source: ImageSource.gallery);
                   },
                   child: Stack(
                     clipBehavior: Clip.none,
                     children: [
                       CircleAvatar(
                         radius: 39.5,
                         backgroundColor: AppColors.primaryColor,
                         child: CircleAvatar(
                             radius: 38,
                             backgroundImage: imageFile != null
                                 ?  FileImage(imageFile!) : AssetImage(
                                 "assets/user/profile/Ellipse 1015.png")
                             as ImageProvider<Object>
                         ),
                       ),
                       Positioned(
                         top: height * 0.05,
                         right: width * -0.009,
                         child: CircleAvatar(
                           radius: 13,
                           backgroundColor:
                           AppColors.primaryColor,
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
                 height: height * 0.02,
               ),
               /// spa name textformfield
               TextFormField(
                 controller: spanameController,
                 style: GoogleFonts.lato(
                   fontWeight: FontWeight.w500,
                   fontSize: 15,
                 ),
                 decoration: InputDecoration(
                   hintText: "Enter Spa Name",
                   hintStyle: GoogleFonts.lato(
                       color:
                       AppColors.textformfieldhintColor),
                   contentPadding: EdgeInsets.all(10),
                   errorBorder: OutlineInputBorder(
                       borderRadius:
                       BorderRadius.circular(12),
                       borderSide:
                       BorderSide(color: Colors.red)),
                   focusedBorder: OutlineInputBorder(
                       borderRadius:
                       BorderRadius.circular(12),
                       borderSide: BorderSide(
                           color: AppColors.primaryColor)),
                   border: OutlineInputBorder(
                       borderRadius:
                       BorderRadius.circular(12),
                       borderSide: BorderSide(
                           color:
                           AppColors.lightgreenColor)),
                 ),
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                     return 'Spa name  is required';
                   }
                   return null;
                 },
               ),
               SizedBox(
                 height: height * 0.015,
               ),

               /// flat,house no,building textformfield
               TextFormField(
                 controller: flatbuildingController,
                 style: GoogleFonts.lato(
                   fontWeight: FontWeight.w500,
                   fontSize: 15,
                 ),
                 decoration: InputDecoration(
                   hintText:
                   "Flat,House No.,Building,Company,Apartment",
                   hintStyle: GoogleFonts.lato(
                       color:
                       AppColors.textformfieldhintColor),
                   contentPadding: EdgeInsets.all(10),
                   errorBorder: OutlineInputBorder(
                       borderRadius:
                       BorderRadius.circular(12),
                       borderSide:
                       BorderSide(color: Colors.red)),
                   focusedBorder: OutlineInputBorder(
                       borderRadius:
                       BorderRadius.circular(12),
                       borderSide: BorderSide(
                           color: AppColors.primaryColor)),
                   border: OutlineInputBorder(
                       borderRadius:
                       BorderRadius.circular(12),
                       borderSide: BorderSide(
                           color:
                           AppColors.lightgreenColor)),
                 ),
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                     return 'Flat,House No.,Building,Company,Apartment is required';
                   }
                   return null;
                 },
               ),
               SizedBox(
                 height: height * 0.015,
               ),

               /// Area,street,sector,village textformfield
               TextFormField(
                 controller: areastreetController,
                 style: GoogleFonts.lato(
                   fontWeight: FontWeight.w500,
                   fontSize: 15,
                 ),
                 decoration: InputDecoration(
                   hintText: "Area,street,sector,village ",
                   hintStyle: GoogleFonts.lato(
                       color:
                       AppColors.textformfieldhintColor),
                   contentPadding: EdgeInsets.all(10),
                   errorBorder: OutlineInputBorder(
                       borderRadius:
                       BorderRadius.circular(12),
                       borderSide:
                       BorderSide(color: Colors.red)),
                   focusedBorder: OutlineInputBorder(
                       borderRadius:
                       BorderRadius.circular(12),
                       borderSide: BorderSide(
                           color: AppColors.primaryColor)),
                   border: OutlineInputBorder(
                       borderRadius:
                       BorderRadius.circular(12),
                       borderSide: BorderSide(
                           color:
                           AppColors.lightgreenColor)),
                 ),
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                     return 'Area,street,sector,village  is required';
                   }
                   return null;
                 },
               ),
               SizedBox(
                 height: height * 0.015,
               ),

               /// Town/City textformfield
               TextFormField(
                 controller: towncityController,
                 style: GoogleFonts.lato(
                   fontWeight: FontWeight.w500,
                   fontSize: 15,
                 ),
                 decoration: InputDecoration(
                   hintText: "Town/City",
                   hintStyle: GoogleFonts.lato(
                       color:
                       AppColors.textformfieldhintColor),
                   contentPadding: EdgeInsets.all(10),
                   errorBorder: OutlineInputBorder(
                       borderRadius:
                       BorderRadius.circular(12),
                       borderSide:
                       BorderSide(color: Colors.red)),
                   focusedBorder: OutlineInputBorder(
                       borderRadius:
                       BorderRadius.circular(12),
                       borderSide: BorderSide(
                           color: AppColors.primaryColor)),
                   border: OutlineInputBorder(
                       borderRadius:
                       BorderRadius.circular(12),
                       borderSide: BorderSide(
                           color:
                           AppColors.lightgreenColor)),
                 ),
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                     return 'Town/City  is required';
                   }
                   return null;
                 },
               ),
               SizedBox(
                 height: height * 0.015,
               ),
               /// dropdowm
               DropdownButtonFormField2<String>(
                 isExpanded: true,
                 decoration: InputDecoration(
                   hintText: "Select an option",
                   hintStyle: GoogleFonts.lato(
                     fontWeight: FontWeight.w300,
                     color: Colors.grey.withOpacity(0.8),
                   ),
                   contentPadding: EdgeInsets.all(10),
                   errorBorder: OutlineInputBorder(
                       borderRadius:
                       BorderRadius.circular(12),
                       borderSide:
                       BorderSide(color: Colors.red)),
                   focusedBorder: OutlineInputBorder(
                       borderRadius:
                       BorderRadius.circular(12),
                       borderSide: BorderSide(
                           color: AppColors.primaryColor)),
                   border: OutlineInputBorder(
                       borderRadius:
                       BorderRadius.circular(12),
                       borderSide: BorderSide(
                           color:
                           AppColors.lightgreenColor)),
                   filled: true,
                   fillColor: Colors.white,
                 ),
                 items: _items
                     .map((item) => DropdownMenuItem<String>(
                   value: item,
                   child: Text(
                     item,
                     style: GoogleFonts.lato(
                         fontSize: 15,
                         fontWeight:
                         FontWeight.w500),
                   ),
                 ))
                     .toList(),
                 validator: (value) {
                   if (value == null) {
                     return 'Please select any one option';
                   }
                   return null;
                 },
                 onChanged: (value) {
                   setState(() {
                     _selectedItem = value.toString();
                   });
                 },
                 onSaved: (value) {
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
                       borderRadius:
                       BorderRadius.circular(10),
                       color: Colors.white),
                 ),
                 menuItemStyleData: const MenuItemStyleData(
                   padding:
                   EdgeInsets.symmetric(horizontal: 10),
                 ),
               ),
             ],
           ),
         ),
          SizedBox(
            height: height * 0.015,
          ),

          SizedBox(
            height: height * 0.05,
          ),

          /// Save button
          CommonButton(
              name: "Save",
              loading: isLoading,
              ontap: () {
                if(_formKey.currentState!.validate()){
                   if(imageFile != null){
                     postDetailsToFirestore();
                   }else{
                     Fluttertoast.showToast(msg: "Please Pick a image For Profile");
                   }
                }
              }),
        ],
      ),
    );
  }
}
