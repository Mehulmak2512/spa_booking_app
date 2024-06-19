import 'package:FoxySpa/user/home/spa_info_screen/spa_info_screen.dart';
import 'package:FoxySpa/user/home/spa_info_screen/time_slots_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app_colors/app_colors.dart';

class ServiceScreen extends StatefulWidget {

  final String spaName;
  final String id;
  const ServiceScreen({super.key, required this.id, required this.spaName});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}
class _ServiceScreenState extends State<ServiceScreen> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("id -----?${widget.id}");
  }

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height *  0.02,),


        StreamBuilder(
            stream: FirebaseFirestore.instance.collection("services",).where("id", isEqualTo: widget.id).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error : ${snapshot.error.toString()}");
              } else if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return CircularProgressIndicator(
                  color: Colors.blue,
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return Column(
                  children: [
                    SizedBox(
                      height: height * 0.35,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No services available.',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return ListView.builder(
                  shrinkWrap: true,
                  itemExtent: height * 0.27,
                  physics: ScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    return Column(
                      children: [
                        ///  icon and   Full Body Massage text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/user/home_page/Group.svg",
                                semanticsLabel: 'icon',
                                width: width * 0.005,
                                height: height * 0.037,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text(
                                snapshot.data!.docs[index]
                                    .get('name')
                                    .toString() ,
                                style: GoogleFonts.lato(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryColor),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        ///  Full Body Massage
                        Container(
                          width: width ,
                          height: height * 0.19,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.primaryColor
                            ),
                            image: DecorationImage(image: NetworkImage(
                              snapshot.data!.docs[index]
                                  .get('image_url')
                                  .toString(),
                            ), fit: BoxFit.fill,),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height : height * .2,
                                width: width  / 3,
                                decoration: BoxDecoration(
                                    color: AppColors.lightgreenColor,
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.favorite,color: AppColors.whiteColor,),
                                      Text(
                                        "60 Min",
                                        style: GoogleFonts.lato(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.whiteColor),
                                      ),
                                      Text(
                                        "\₹${snapshot.data!.docs[index].get('price').toString()}/Hours",
                                        style: GoogleFonts.lato(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.whiteColor),
                                      ),
                                      SizedBox(height: height * 0.01,),
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => TimeSlotsScreen(
                                            spaName: widget.spaName,
                                            serviceName:  snapshot.data!.docs[index]
                                                .get('name')
                                                .toString(),
                                            serviceImage:  snapshot.data!.docs[index]
                                                .get('image_url')
                                                .toString(),
                                            servicePrice:snapshot.data!.docs[index].get('price').toString(),
                                            id: widget.id,
                                          ),
                                          ),
                                          );                                        },
                                        child: Container(
                                          height: height * 0.035,
                                          width: width / 4.5,
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Book Now",
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.02,),
                      ],
                    );
                  });
            }
        ),

          ],
        ),
      ),
    );
  }
}
