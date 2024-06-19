import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:FoxySpa/common_widget/round_button.dart';
import '../../../app_colors/app_colors.dart';
import '../../bottomnavigatorbar/home_page.dart';

class CompletedPaymentScreen extends StatelessWidget {
  const CompletedPaymentScreen({super.key});

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: height * 0.065,
              ),
              Center(
                child: SvgPicture.asset(
                  "assets/user/payment_screen/Group 8266 1.svg",
                  semanticsLabel: "complete payment image",
                  height: height * 0.22,
                ),
              ),
              SizedBox(height: height * 0.05,),
              Container(
                  width: width/1.5,
                  child: Text(
                    "Payment Successfully Completed",
                    textAlign: TextAlign.center,
                    style:
                    GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.w700),
                  )),
            ],
          ),

          /// Done button
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: RoundButton(name: "Done", ontap: (){

              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(index: 1,)),(route)=> false);
            }),
          ),
        ],
      ),
    );
  }
}
