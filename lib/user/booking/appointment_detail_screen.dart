import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app_colors/app_colors.dart';

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({super.key});

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {



  String uid =  FirebaseAuth.instance.currentUser!.uid.toString();



  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "My Appointments",
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("booking",).where("id", isEqualTo: uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error : ${snapshot.error.toString()}");
          } else if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator(
                color: Colors.blue,
              ),
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
                      'No booking available.',
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
          return ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: height * 0.022,
                    );
                  },
                  itemCount:snapshot.data!.docs.length,
                  physics: const ScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                       height: height * 0.32,
                       decoration: BoxDecoration(
                         color: AppColors.lightgreenColor,
                         borderRadius: BorderRadius.circular(10)
                       ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Spa Name:",style: GoogleFonts.lato(
                                  fontSize:15,
                                  fontWeight : FontWeight.w400,
                                  color: AppColors.primaryColor,
                                ),),
                                SizedBox(height: height * 0.005,),
                                Text(snapshot.data!.docs[index].get("spa_name").toString(),style: GoogleFonts.lato(
                                  fontSize:16,
                                  fontWeight : FontWeight.w700,
                                  color: AppColors.whiteColor,
                                ),),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                            child: Divider(
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                              width: width /2.33,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Appointment Date",style: GoogleFonts.lato(
                                        fontSize:15,
                                        fontWeight : FontWeight.w400,
                                        color: AppColors.primaryColor,
                                      ),),
                                      SizedBox(height: height * 0.005,),
                                      Text(snapshot.data!.docs[index].get("appointment_date").toString(),style: GoogleFonts.lato(
                                        fontSize:16,
                                        fontWeight : FontWeight.w700,
                                        color: AppColors.whiteColor,
                                      ),),
                                    ],
                                  ),
                                ),
                                SizedBox(width: width * 0.01,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Appointment Time",style: GoogleFonts.lato(
                                      fontSize:15,
                                      fontWeight : FontWeight.w400,
                                      color: AppColors.primaryColor,
                                    ),),
                                    SizedBox(height: height * 0.005,),
                                    Text(snapshot.data!.docs[index].get("appointment_time").toString(),style: GoogleFonts.lato(
                                      fontSize:14,
                                      fontWeight : FontWeight.w700,
                                      color: AppColors.whiteColor,
                                    ),),

                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                            child: Divider(
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width /2.33,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Type of Service",style: GoogleFonts.lato(
                                        fontSize:15,
                                        fontWeight : FontWeight.w400,
                                        color: AppColors.primaryColor,
                                      ),),
                                      SizedBox(height: height * 0.005,),
                                      Text(snapshot.data!.docs[index].get("service_name").toString(),style: GoogleFonts.lato(
                                        fontSize:16,
                                        fontWeight : FontWeight.w700,
                                        color: AppColors.whiteColor,
                                      ),),

                                    ],
                                  ),
                                ),
                                SizedBox(width: width * 0.01,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Total Amount",style: GoogleFonts.lato(
                                      fontSize:15,
                                      fontWeight : FontWeight.w400,
                                      color: AppColors.primaryColor,
                                    ),),
                                    SizedBox(height: height * 0.005,),
                                    Text("\₹${snapshot.data!.docs[index].get("service_price").toString()}",style: GoogleFonts.lato(
                                      fontSize:16,
                                      fontWeight : FontWeight.w700,
                                      color: AppColors.whiteColor,
                                    ),),
                                  ],
                                ),

                              ],
                            ),
                          ),



                        ],
                      ),
                    );
                  },
                );
        }
      ),
    );
  }
}
