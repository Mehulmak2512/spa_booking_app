import 'package:FoxySpa/user/bottomnavigatorbar/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:FoxySpa/common_widget/round_button.dart';
import 'package:FoxySpa/user/home/payment/payment_screen.dart';

import '../../../app_colors/app_colors.dart';

class ConfirmBookingScreen extends StatefulWidget {

  final String spaName;
  final String serviceName;
  final String serviceImage;
  final String servicePrice;
  final String appointmentDate;
  final String appointmentTime;
  final String therapistImageUrl;
  final String therapistName;
  final String therapistTitle;
  const ConfirmBookingScreen(
      {super.key,
      required this.spaName,
      required this.serviceName,
      required this.serviceImage,
      required this.servicePrice,
      required this.appointmentDate,
      required this.appointmentTime,
      required this.therapistImageUrl,
      required this.therapistName,
      required this.therapistTitle});

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {


  TextEditingController appplyController = TextEditingController();

  double discount = 0.0;
  double discountPrice = 0.0;
  bool isDiscountApplied = false;
  late double finalTotalPrice ;
  bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState

    print("Spa Name -------------> "+widget.spaName);
    super.initState();
     finalTotalPrice = double.parse(widget.servicePrice) + 150;
  }


  postDetailsToFirestore() async{
    try{
      setState(() {
        isLoading = true;
      });
      String uid =  FirebaseAuth.instance.currentUser!.uid.toString();

      await FirebaseFirestore.instance.collection("booking").add({
        "spa_name": widget.spaName.toString(),
        "service_name":widget.serviceName.toString(),
        "service_image":widget.serviceImage..toString(),
        "service_price": finalTotalPrice.toString(),
        "appointment_date":widget.appointmentDate.toString(),
        "appointment_time":widget.appointmentTime.toString(),
        "therapist_image_url":widget.therapistImageUrl.toString(),
        "therapist_name":widget.therapistName.toString(),
        "therapist_title":widget.therapistTitle.toString(),
        'id': uid,
      }).then((value) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(index: 1)));
        setState(() {
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
  Widget build(BuildContext context) {

    double subTotalPrice = double.parse(widget.servicePrice);

    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Confirm Booking",
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
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                itemCount: 1,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.serviceName,
                        maxLines: 1,
                        style: GoogleFonts.lato(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor),
                      ),
                      SizedBox(height: height * 0.01),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.network(
                              widget.serviceImage,
                              height: height * 0.065,
                              width: width * 0.2,
                              fit: BoxFit.fill,
                            ),
                          ),
                          // SizedBox(width: width * 0.06,),
                          // Icon(Icons.favorite,color: AppColors.lightgreenColor,),
                          // SizedBox(width: width * 0.06,),
                          Spacer(),
                          Text(
                            "60 Min",
                            style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: AppColors.lightgreenColor),
                          ),
                          SizedBox(
                            width: width * 0.1,
                          ),

                          Text(
                            "\₹${widget.servicePrice}",
                            style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.lightgreenColor),
                          ),
                          Spacer(),

                          // SizedBox(width: width * 0.2,),
                          // CircleAvatar(
                          //   radius: 9,
                          //   child: Icon(Icons.close_outlined,color: AppColors.whiteColor,size: 12,),
                          //   backgroundColor: AppColors.lightgreenColor,
                          // ),
                        ],
                      ),
                      SizedBox(height: height * 0.01),
                      Divider(
                        color: Colors.grey.shade400.withOpacity(0.6),
                        thickness: 1.5,
                      )
                    ],
                  );
                },
              ),

              /// Book Appointment
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Book Appointment",
                    style: GoogleFonts.lato(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Icon(
                    Icons.calendar_month,
                    color: AppColors.lightgreenColor,
                  )
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),

              /// day-date button
              Center(
                child: Container(
                  height: height * 0.05,
                  width: width / 1.9,
                  decoration: BoxDecoration(
                    color: AppColors.lightgreenColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      widget.appointmentDate,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),

              /// time button
              Center(
                child: Container(
                  height: height * 0.05,
                  width: width / 1.9,
                  decoration: BoxDecoration(
                    color: AppColors.lightgreenColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.watch_later_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Text(
                        widget.appointmentTime,
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),

              /// massage therapistlist
              Text(
                "Massage Therapist",
                style:
                    GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Material(
                  borderRadius: BorderRadius.circular(8),
                  elevation: 2,
                  child: Container(
                    width: width / 2,
                    height: height * 0.21,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.lightgreenColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.03),
                        CircleAvatar(
                          radius: 41,
                          backgroundColor: AppColors.primaryColor,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.therapistImageUrl),
                            radius: 40,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        Text(
                          widget.therapistName,
                          maxLines: 1,
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          widget.therapistTitle,
                          maxLines: 1,
                          style: GoogleFonts.lato(
                              fontSize: 13,
                              color: Colors.green,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: height * 0.008,
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: height * 0.02,
              ),

              /// Apply Coupon text
              Text(
                "Apply Coupon",
                style:
                    GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: height * 0.02,
              ),

              /// coupon button
              isDiscountApplied == false ?
              Container(
                height: height * 0.055,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 1.2,
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: width * 0.07,
                      height: height * 0.03,
                      // color: Colors.blueGrey,
                      child: Image.asset(
                        "assets/user/confirm_booking/bxs_offer.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    SizedBox(
                      width: width * 0.56,
                      height: height * 0.035,
                      child: TextFormField(
                        controller: appplyController,
                        style: GoogleFonts.lato(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: "Enter Coupon Code",
                          hintStyle: GoogleFonts.lato(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textformfieldhintColor),
                          contentPadding: EdgeInsets.all(8),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    InkWell(
                      onTap: () {
                        String enteredCode = appplyController.text;
                        // Check if discount is applicable based on the entered code
                        if (enteredCode == "50%OFF") {
                          discount = 0.5; // 50% discount
                          isDiscountApplied = true;
                        } else if (enteredCode == "30%OFF") {
                          discount = 0.3; // 30% discount
                          isDiscountApplied = true;
                        } else if (enteredCode == "20%OFF") {
                          discount = 0.2; // 20% discount
                          isDiscountApplied = true;
                        } else if (enteredCode == "18%OFF") {
                          discount = 0.18; // 18% discount
                          isDiscountApplied = true;
                        } else {
                          isDiscountApplied = false;
                          Fluttertoast.showToast(
                              msg: "Coupon is not Available");

                          return;
                        }

                        double discountedPrice =
                            double.parse(widget.servicePrice.toString()) *
                                (1 - discount);
                        discountPrice = subTotalPrice - discountedPrice;
                        subTotalPrice = subTotalPrice - discountPrice;
                        finalTotalPrice = finalTotalPrice - discountPrice;

                        setState(() {
                          appplyController.clear();
                          isDiscountApplied = true;
                        });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Coupon Applied"),
                              content: Text(
                                  "Discount : \₹${discountPrice.toStringAsFixed(2)}"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        height: height * 0.055,
                        width: width / 5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8)),
                            color: AppColors.primaryColor),
                        child: Center(
                          child: Text(
                            "Apply",
                            style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.whiteColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ) :
              Center(
                child: Text("Coupon Applied Successfully",style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                ),
                ),
              ),
              SizedBox(
                height: height * 0.045,
              ),

              Container(
                height: height * 0.21,
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightgreenColor),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sub Total",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: height * 0.007,
                            ),
                            Text(
                              "Charges",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: height * 0.007,
                            ),
                            Text(
                              "Discount",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "\₹${subTotalPrice.toStringAsFixed(2)}",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: height * 0.007,
                            ),
                            Text(
                              "\₹150.00",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: height * 0.007,
                            ),
                            Text(
                              "\₹${discountPrice.toStringAsFixed(2)}",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.025,
                    ),
                    CustomPaint(
                      painter: DottedLinePainter(),
                      child: Container(
                        width: width,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "\₹${finalTotalPrice.toStringAsFixed(2)}",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.045,
              ),

              /// confirm booking button
              RoundButton(
                  name: "Confirm Booking",
                  loading: isLoading,
                  ontap: () {
                      postDetailsToFirestore();
                  }),
              SizedBox(
                height: height * 0.02,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightgreenColor
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round;

    double dashWidth = 1;
    double dashSpace = 5;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
