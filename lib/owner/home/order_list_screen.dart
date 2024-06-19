import 'package:FoxySpa/owner/home/add_service/add_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_colors/app_colors.dart';

class OrderListScreen extends StatefulWidget {
  final String spaName;
  const OrderListScreen({super.key, required this.spaName});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class MassageList{
  final String massage_name;
  final String image;

  MassageList({required this.massage_name,required this.image, });
}
class _OrderListScreenState extends State<OrderListScreen> {

  List<MassageList> _massgelist = [
    MassageList(massage_name: "Full Body Massage", image:"assets/user/services/full_body_massage.png"),
    MassageList(massage_name: "Foot Massage", image:"assets/user/services/foot_massage.png"),
    MassageList(massage_name: "Back Massage", image:"assets/user/services/back_massage.png"),
    MassageList(massage_name: "Head Massage", image:"assets/user/services/head_massage.png"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("spa name ------->"+ widget.spaName);
  }
  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.05,),
              Text("Upcoming Orders",style:  GoogleFonts.lato(
                  fontSize: 20,fontWeight: FontWeight.w600
              ),),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("booking",).where("spa_name", isEqualTo: widget.spaName.toString()).snapshots(),
                builder: (context, snapshot) {

                  if (snapshot.hasError) {
                    return Text("Error : ${snapshot.error.toString()}");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Column(
                      children: [
                        SizedBox(
                          height: height * 0.25,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No orders available.',
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
                    itemCount: snapshot.data!.docs.length,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SizedBox(height: height * 0.01,),
                  
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.network(
                                  snapshot.data!.docs[index].get("service_image").toString(),
                                  height: height * 0.065,
                                  width: width * 0.2,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(width: width * 0.04),
                              Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                  
                                  Text(
                                    snapshot.data!.docs[index].get("service_name").toString(),
                                    maxLines: 1,
                                    style: GoogleFonts.lato(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryColor),
                                  ),
                  
                  
                                  Text(snapshot.data!.docs[index].get("appointment_date").toString(),style:GoogleFonts.lato(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),),
                                  SizedBox(width: width * 0.06,),
                  
                                  Text(snapshot.data!.docs[index].get("appointment_time").toString(),style:GoogleFonts.lato(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.01,),
                          Divider(
                            color: Colors.grey.shade400.withOpacity(0.6),
                            thickness: 1.5,
                          ),
                        ],
                      );
                    },
                  );
                }
              ),

            ],
          ),
        ),
      ),
    );
  }
}
