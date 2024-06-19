import 'package:FoxySpa/common_widget/common_button.dart';
import 'package:FoxySpa/owner/home/add_service/add_service.dart';
import 'package:FoxySpa/owner/home/add_service/add_service_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_colors/app_colors.dart';

class ServiceListScreen extends StatefulWidget {
  final String id;
  const ServiceListScreen({super.key, required this.id});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}
class _ServiceListScreenState extends State<ServiceListScreen> {

  String doc_Id = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     print(" Doc id [------------>${widget.id}-----------]");

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 15,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddServiceScreen(id: widget.id,)));
                    },
                    child: Container(
                      height: height * 0.045,
                      width: width * 0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primaryColor,
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Add",
                            style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primaryColor),
                          ),
                          CircleAvatar(
                            backgroundColor: AppColors.primaryColor,
                            radius: 8,
                            child: Icon(
                              Icons.add,
                              color: AppColors.whiteColor,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),

              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("services")
                    .where("id", isEqualTo: widget.id)
                    .snapshots(),
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
                              'No data available.',
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
                    itemCount: snapshot.data!.docs.length,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: height * 0.02,
                      );
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ///  icon and   Full Body Massage text
                          Row(
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
                                    .toString(),
                                style: GoogleFonts.lato(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryColor),
                              )
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),

                          ///  Full Body Massage
                          Container(
                            width: width,
                            height: height * 0.19,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.primaryColor),
                              image: DecorationImage(
                                image: NetworkImage(
                                  snapshot.data!.docs[index]
                                      .get('image_url')
                                      .toString(),
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: height * .2,
                                  width: width / 3,
                                  decoration: BoxDecoration(
                                      color: AppColors.lightgreenColor,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight:
                                          Radius.circular(10))),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.favorite,
                                          color: AppColors.whiteColor,
                                        ),
                                        Text(
                                          "60 Min",
                                          style: GoogleFonts.lato(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color:
                                              AppColors.whiteColor),
                                        ),
                                        Text(
                                          "\₹${snapshot.data!.docs[index].get('price').toString()}/Hours",
                                          style: GoogleFonts.lato(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color:
                                              AppColors.whiteColor),
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Center(
                                          child: InkWell(
                                            onTap: () async {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Padding(
                                                            padding:  EdgeInsets.only(
                                                                top: 15, right: 15),
                                                            child: GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: const Icon(
                                                                  Icons.close,
                                                                  size: 25,
                                                                  color: Colors.grey,
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                            horizontal: 18),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(10),
                                                              child: Image.network(
                                                                  snapshot.data!.docs[index].get("image_url").toString(),
                                                                  fit: BoxFit.fill,
                                                                  width: width / 4,
                                                                  height: height * 0.09),
                                                            ),
                                                            SizedBox(
                                                              width: width / 27,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  snapshot.data!.docs[index].get("name").toString(),
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.w700,

                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: height * 0.01,
                                                                ),
                                                                SizedBox(
                                                                    width: width / 1.65,
                                                                    child: const Text(
                                                                      "Are you sure you want to remove this service from Service List?",
                                                                      style: TextStyle(
                                                                          fontSize: 15,
                                                                          color: Colors.grey),
                                                                    ))
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.03,
                                                      ),
                                                      Divider(
                                                        color: Colors.grey.withOpacity(0.5),
                                                        height: 0,
                                                      ),
                                                      IntrinsicHeight(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Padding(
                                                                padding: EdgeInsets.all(14.0),
                                                                child: Text(
                                                                  "NO",
                                                                  style: TextStyle(
                                                                    color: Colors.black54,
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            VerticalDivider(
                                                              color: Colors.grey[400],
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(context);
                                                                setState(() {
                                                                  DeleteServices( snapshot.data!.docs[index]);
                                                                });

                                                              },
                                                              child: const Padding(
                                                                padding: EdgeInsets.all(14.0),
                                                                child: Text(
                                                                  "YES",
                                                                  style: TextStyle(
                                                                      color: AppColors.primaryColor,
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                },
                                              ).then((value) => (){
                                                setState(() {

                                                });
                                              });

                                              ;
                                            },

                                            child: Icon(
                                              Icons.delete,
                                              color:
                                              AppColors.primaryColor,
                                              size: 28,
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
                        ],
                      );
                    },
                  );
                },
              )

            ],
          ),
        ),
      ),
    );
  }
  DeleteServices(index) async {
    FirebaseStorage storage =
        FirebaseStorage
            .instance;
    String imageUrl = index
        .get('image_url')
        .toString();

    // Create a reference using the image URL
    Reference ref = storage
        .refFromURL(imageUrl);
    try {
      // Delete the image from Firebase Storage
      await ref.delete();
      print(
          'Image deleted successfully');
    } catch (error) {
      print(
          'Error deleting image: $error');
    }

    setState(() {
      doc_Id = index.id;
      print(
          "doc id----------->${doc_Id}");
    });
    await FirebaseFirestore
        .instance
        .collection("services")
        .doc(doc_Id.toString())
        .delete();
  }
}
