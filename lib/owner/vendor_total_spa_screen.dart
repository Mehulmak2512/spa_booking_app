import 'package:FoxySpa/app_colors/app_colors.dart';
import 'package:FoxySpa/auth/login_screen.dart';
import 'package:FoxySpa/owner/add_spa_screen.dart';
import 'package:FoxySpa/owner/home/vendor_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorTotalSpaScreen extends StatefulWidget {
  const VendorTotalSpaScreen({super.key});

  @override
  State<VendorTotalSpaScreen> createState() => _VendorTotalSpaScreenState();
}

class _VendorTotalSpaScreenState extends State<VendorTotalSpaScreen> {

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    String docId = '';


    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Your Total Spa",
          style: GoogleFonts.lato(
            color: AppColors.whiteColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                      backgroundColor: AppColors.whiteColor,
                      title: Text("Logout"),
                      content: Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            LogOut();
                          },
                          child: Text("Logout"),
                        ),
                      ],
                    );
                  });

              },
              icon: Icon(Icons.logout)),
          SizedBox(
            width: width * 0.01,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return AddSpaScreen();
                          });
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
                            style: TextStyle(
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
                height: height * 0.02,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("spas")
                      .where("id",
                          isEqualTo:
                              FirebaseAuth.instance.currentUser!.uid.toString())
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(color: Colors.blue,);
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return Column(
                        children:[
                          SizedBox(height: height * 0.35,),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('No spas available.',style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),),
                            ],
                          ),
                        ],
                      );
                    }
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 270,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 20),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              // print("Doc id ----->"+snapshot.data!.docs[index].id);
                              // setState(() {
                              //  docId = snapshot.data!.docs[index].id;
                              // });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VendorHomeScreen(id:  snapshot.data!.docs[index].id.toString(),
                                            spaName: snapshot.data!.docs[index].get('spa_name').toString()
                                          )));
                            },
                            child: Container(
                              width: width * 0.435,
                              decoration: BoxDecoration(
                                  color: AppColors.lightgreenColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: AppColors.primaryColor)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// spa image
                                  ClipRRect(
                                      child: Image.network(
                                        snapshot.data!.docs[index].get('image_url').toString(),
                                        width: width,
                                        height: height * 0.15,
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10))),
                                  SizedBox(
                                    height: height * 0.005,
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /// spa name
                                        Text(
                                          snapshot.data!.docs[index].get('spa_name').toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              color: AppColors.whiteColor,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: height * 0.005,
                                        ),

                                        /// address
                                        Text(
                                          snapshot.data!.docs[index].get('flat_building').toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              fontSize: 13,
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: height * 0.005,
                                        ),
                                        Text(
                                          snapshot.data!.docs[index].get('area_street').toString(),                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              fontSize: 13,
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: height * 0.005,
                                        ),
                                        Text(
                                          snapshot.data!.docs[index].get('town_city').toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              color: AppColors.whiteColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: height * 0.005,
                                        ),
                                        Text(
                                          snapshot.data!.docs[index].get('status').toString().toUpperCase(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              fontSize: 13,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }

   void LogOut(){
    auth.signOut().then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userType');

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginScreen()),
              (route) => false);
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: error.toString());
    });
  }
}
