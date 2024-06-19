import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:FoxySpa/common_widget/round_button.dart';
import 'package:FoxySpa/user/home/payment/completed_payment_screen.dart';

import '../../../app_colors/app_colors.dart';

class ConfirmPaymentScreen extends StatefulWidget {
  const ConfirmPaymentScreen({super.key});

  @override
  State<ConfirmPaymentScreen> createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {

  final List<String> monthItems =  ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];
  String? selectedValue;

  final _formKey = GlobalKey<FormState>();

  bool _checkbox = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment Method",
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.01,),

              ///   CARD NUMBER
              Text("CARD NUMBER",style: GoogleFonts.lato(fontSize: 15,fontWeight: FontWeight.w500),),
              SizedBox(height: height * 0.015,),
              TextFormField(
                keyboardType: TextInputType.number,
                style: GoogleFonts.lato(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: "1234     1234     1234     1234",
                  hintStyle: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.withOpacity(0.8),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  prefixIcon: Transform.scale(
                    scale: 0.5,
                    child: SvgPicture.asset("assets/user/payment_screen/Group 96.svg"),
                  ),

                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.lightgreenColor)),
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

              SizedBox(height: height * 0.02,),

              /// expiry date and cvv
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// month and year 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text("EXPIRY DATE",style: GoogleFonts.lato(fontSize: 15,fontWeight: FontWeight.w500),),
                      SizedBox(height: height * 0.015,),
                      Row(
                        children: [
                          SizedBox(
                            width: width /3.8,
                            child: DropdownButtonFormField2<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 10,),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: AppColors.lightgreenColor)
                                ),
                                // Add more decoration..
                              ),
                              hint: Text(
                                'Month',
                                style: GoogleFonts.lato(fontSize: 14),
                              ),
                              items: monthItems
                                  .map((item) => DropdownMenuItem<String>(
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
                                  return 'Please select month.';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                //Do something when selected item is changed.
                              },
                              onSaved: (value) {
                                selectedValue = value.toString();
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
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.07,),
                          SizedBox(
                            width: width /3.8,
                            child: DropdownButtonFormField2<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 10,),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: AppColors.lightgreenColor)
                                ),
                                // Add more decoration..
                              ),
                              hint: Text(
                                'Year',
                                style: GoogleFonts.lato(fontSize: 14),
                              ),
                              items: List.generate(10, (index) => 2021 + index).map((int year) {
                                return DropdownMenuItem<int>(
                                  value: year,
                                  child: Text('$year',style:  GoogleFonts.lato(
                                      fontSize: 15,
                                      fontWeight : FontWeight.w500
                                  ),),
                                );
                              }).toList(),

                              // items:
                              // List.generate(16, (index) => 2020 + index).map((int year) => DropdownMenuItem<>(
                              //   value: year,
                              //   child: Text(
                              //     year,
                              //     style:  GoogleFonts.lato(
                              //       fontSize: 15,
                              //       fontWeight : FontWeight.w500
                              //     ),
                              //   ),
                              // ))
                              //     .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select month.';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                //Do something when selected item is changed.
                              },
                              onSaved: (value) {
                                selectedValue = value.toString();
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
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      

                    ],
                  ),
                  /// cvv textfield

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("CVV",style: GoogleFonts.lato(fontSize: 15,fontWeight: FontWeight.w500),),
                      SizedBox(height: height * 0.015,),
                      SizedBox(
                        width: width /3.8,
                        child: TextFormField(
                          style: GoogleFonts.lato(),
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.lato(
                              fontWeight: FontWeight.w300,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                            contentPadding: EdgeInsets.all(10),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: AppColors.lightgreenColor)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.transparent)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'CVV is required';
                            }else if (value.length != 3){
                              return "Enter Valid CVV";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )
                 
                  
                ],
              ),
              SizedBox(height: height * 0.02,),

              ///   Card Holder
              Text("CARD HOLDER",style: GoogleFonts.lato(fontSize: 15,fontWeight: FontWeight.w500),),
              SizedBox(height: height * 0.015,),


              TextFormField(
                style: GoogleFonts.lato(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(

                  hintText: "Name",
                  hintStyle: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.withOpacity(0.8),
                  ),
                  contentPadding: EdgeInsets.all(10),

                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.lightgreenColor)),
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

              SizedBox(height: height * 0.025,),

              Row(
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        _checkbox =
                        !_checkbox; // T
                      });
                    },
                      child: SvgPicture.asset(_checkbox?"assets/user/payment_screen/Property 1=Default.svg":"assets/user/payment_screen/Property 1=Variant2.svg")),
                  SizedBox(width: width * 0.03,),
                  Text("Save Card For Future Use",style: GoogleFonts.lato(fontSize: 15,fontWeight: FontWeight.w500),)
                ],
              ),
              SizedBox(height: height * 0.2,),
              /// confirm payment button
              RoundButton(name: "Confirm Payment", ontap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CompletedPaymentScreen()));
              })
            ],
          ),
        ),
      ),
    );
  }
}
