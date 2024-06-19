
import 'package:FoxySpa/owner/home/add_service/add_therapist_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app_colors/app_colors.dart';

class VendorTherapistListScreen extends StatefulWidget {

  final String id ;
  const VendorTherapistListScreen({super.key, required this.id});

  @override
  State<VendorTherapistListScreen> createState() => _VendorTherapistListScreenState();
}


class _VendorTherapistListScreenState extends State<VendorTherapistListScreen> {

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
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15,),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddTherapistScreen(id: widget.id,)));
                    },
                    child: Container(
                      height: height * 0.045,
                      width: width * 0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primaryColor,
                          )
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Add",style: GoogleFonts.lato(fontSize: 15,fontWeight: FontWeight.w400,color: AppColors.primaryColor),),
                          CircleAvatar(
                            backgroundColor: AppColors.primaryColor,
                            radius: 8,
                            child: Icon(Icons.add,color: AppColors.whiteColor,size: 15,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01,),

              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("therapist")
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
                      return Container(
                        height: height * 0.215,
                        width: width,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: AppColors.lightgreenColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(

                                      backgroundImage: NetworkImage(snapshot.data!.docs[index].get("image_url").toString(),),
                                      radius: 30,
                                    ),
                                    SizedBox(width: width * 0.04,),
                                    SizedBox(
                                      width : width * 0.45,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(snapshot.data!.docs[index].get("name").toString(),
                                            maxLines: 1,
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: AppColors.whiteColor
                                            ),),
                                          SizedBox(height: height * 0.005,),
                                          Text(snapshot.data!.docs[index].get("title").toString(),style: GoogleFonts.lato(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: AppColors.whiteColor
                                          ),)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: height * 0.01,),
                                Text("Working Hours",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: AppColors.whiteColor
                                  ),),
                                SizedBox(height: height * 0.01,),
                                Row(
                                  children: [
                                    Container(
                                      width: width * 0.275,
                                      padding: EdgeInsets.symmetric(vertical: 7,horizontal: 4),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(
                                              color: AppColors.primaryColor
                                          )
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Days : ${snapshot.data!.docs[index].get("w_days").toString()}",style: GoogleFonts.lato(
                                            color: AppColors.textformfieldhintColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),),
                                          Icon(Icons.calendar_month,size: 16,color: AppColors.textformfieldhintColor,)
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: width * 0.03,),
                                    Container(
                                      width: width * 0.36,
                                      padding: EdgeInsets.symmetric(vertical: 7,horizontal: 4),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(
                                              color: AppColors.primaryColor
                                          )
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Hours :  ${snapshot.data!.docs[index].get("w_hours").toString()}",style: GoogleFonts.lato(
                                            color: AppColors.textformfieldhintColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),),
                                          Icon(Icons.watch_later_outlined,size: 16,color: AppColors.textformfieldhintColor,)
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: width * 0.01,),
                                    InkWell(
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
                                                      CircleAvatar(
                                                        radius: 40,
                                                        backgroundImage: NetworkImage(snapshot.data!.docs[index].get("image_url").toString()),
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
                                                                "Are you sure you want to remove this therapist from Therapist List?",
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
                                                            DeleteTherapist( snapshot.data!.docs[index]);
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
                                      child: Icon(Icons.delete
                                        ,color: AppColors.primaryColor,size: 28,),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
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

  DeleteTherapist(index) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String imageUrl = index.get('image_url').toString();

    // Create a reference using the image URL
    Reference ref = storage.refFromURL(imageUrl);
    try {
      // Delete the image from Firebase Storage
      await ref.delete();
      print('Image deleted successfully');
    } catch (error) {
      print('Error deleting image: $error');
    }

    setState(() {
      doc_Id = index.id;
      print("doc id----------->${doc_Id}");
    });
    await FirebaseFirestore.instance.collection("therapist").doc(doc_Id.toString()).delete();
  }
}
