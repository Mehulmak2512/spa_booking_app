// import 'dart:io';
//
// import 'package:FoxySpa/app_colors/app_colors.dart';
// import 'package:FoxySpa/common_widget/common_button.dart';
// import 'package:FoxySpa/owner/home/add_service/add_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
//
//
// class AddPriceScreen extends StatefulWidget {
//   const AddPriceScreen({super.key});
//
//   @override
//   State<AddPriceScreen> createState() => _AddPriceScreenState();
// }
//
// class _AddPriceScreenState extends State<AddPriceScreen> {
//
//
//   String? _selectedItem;
//   final List<String> _items = [
//     "45/Hours",
//     "90/Day",
//     "150/Weekly",
//     "500/Monthly"
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.sizeOf(context).height;
//     final width = MediaQuery.sizeOf(context).width;
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 13.0,vertical: 15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               Text("Add Price",style: GoogleFonts.lato(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 15
//               ),),
//               SizedBox(height:  height * 0.01,),
//
//               DropdownButtonFormField2<String>(
//                 style: GoogleFonts.lato(
//                     fontWeight: FontWeight.w400,
//                     fontSize: 15,
//                     color:Colors.black
//                 ),
//                 isExpanded: true,
//                 decoration: InputDecoration(
//                   hintText: "Add Price",
//                   hintStyle: GoogleFonts.lato(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 15,
//                   ),
//                   contentPadding: EdgeInsets.all(10),
//                   errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.red)),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: AppColors.primaryColor)),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: AppColors.lightgreenColor)),
//
//                 ),
//                 items: _items
//                     .map((item) => DropdownMenuItem<String>(
//                   value: item,
//                   child: Text(
//                     "\$${item}",
//                     style: GoogleFonts.lato(
//                         fontSize: 15, fontWeight: FontWeight.w500),
//                   ),
//                 ))
//                     .toList(),
//                 validator: (value) {
//                   if (value == null) {
//                     return 'Please select month.';
//                   }
//                   return null;
//                 },
//                 onChanged: (value) {
//                   //Do something when selected item is changed.
//                 },
//                 onSaved: (value) {
//                   _selectedItem = value.toString();
//                 },
//                 buttonStyleData: const ButtonStyleData(
//                   padding: EdgeInsets.only(right: 8),
//                 ),
//                 iconStyleData: const IconStyleData(
//                   icon: Icon(
//                     Icons.arrow_drop_down,
//                     color: Colors.black45,
//                   ),
//                   iconSize: 20,
//                 ),
//                 dropdownStyleData: DropdownStyleData(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10), color: Colors.white),
//                 ),
//                 menuItemStyleData: const MenuItemStyleData(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//               ),
//
//               SizedBox(height:  height * 0.03,),
//
//
//               Text("Description",style: GoogleFonts.lato(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 15
//               ),),
//               SizedBox(height:  height * 0.01,),
//
//               TextFormField(
//                 maxLines: 5,
//                 style:GoogleFonts.lato(
//                   fontWeight: FontWeight.w500,
//                   fontSize: 15,
//                 ),
//
//                 decoration: InputDecoration(
//                   hintText: "Write Something here...",
//                   hintStyle: GoogleFonts.lato(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 15,
//                     color: AppColors.textformfieldhintColor
//                   ),
//                   contentPadding: EdgeInsets.all(10),
//                   errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.red)),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide:
//                       BorderSide(color: AppColors.primaryColor)),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide:
//                       BorderSide(color: AppColors.lightgreenColor)),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Description is required';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height:  height * 0.15,),
//
//
//              /// continue button
//               CommonButton(name: "Continue", ontap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => AddSevice(index: 2)));
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
