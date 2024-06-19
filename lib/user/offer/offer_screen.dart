import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:FoxySpa/app_colors/app_colors.dart';
import 'dart:ui';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class OfferList{
  final String massage_name;
  final String image;
  final String discount;

  OfferList({required this.massage_name, required this.image,required this.discount, });
}

class _OfferScreenState extends State<OfferScreen> {
  
  final List<OfferList> _offerList = [
    OfferList(massage_name: "Full Body Massage", image:"assets/user/services/full_body_massage.png",discount: "50%OFF"),
    OfferList(massage_name: "Foot Massage", image:"assets/user/services/foot_massage.png",discount: "30%OFF"),
    OfferList(massage_name: "Back Massage", image:"assets/user/services/back_massage.png",discount: "20%OFF"),
    OfferList(massage_name: "Head Massage", image:"assets/user/services/head_massage.png",discount: "18%OFF"),  ];
  @override
  Widget build(BuildContext context) {


    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Offers",
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return SizedBox(
            height: height * 0.022,
          );
        },
        itemCount:_offerList.length,
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            height: height * 0.2,
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 25),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              image: DecorationImage(image: AssetImage(_offerList[index].image.toString(),),fit: BoxFit.fill,colorFilter: ColorFilter.mode(AppColors.primaryColor.withOpacity(0.35), BlendMode.srcOver))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text("Flat ${_offerList[index].discount.toString()}",style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20,),),
                 Text("on ${_offerList[index].massage_name.toString()}",style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20,),),
                SizedBox(height: height * 0.03,),
                InkWell(
                  onTap: (){
                    Clipboard.setData(new ClipboardData(text:"50%OFF"));
                  },
                  child: Container(
                    height: height * 0.04,
                    width: width / 4.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${_offerList[index].discount.toString()}",
                        style: GoogleFonts.lato(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          );
        },
      ),

    );
  }
}
