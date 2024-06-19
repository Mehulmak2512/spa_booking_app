import 'package:FoxySpa/owner/home/order_list_screen.dart';
import 'package:FoxySpa/owner/home/service_list_screen.dart';
import 'package:FoxySpa/owner/home/therapist_list_screen.dart';
import 'package:FoxySpa/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_colors/app_colors.dart';

class VendorHomeScreen extends StatefulWidget {
  final String id;
  final String spaName;

  VendorHomeScreen({super.key, required this.id, required this.spaName});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocation();
    print("doc id -----> ${widget.id.toString()}");
  }


  String location = "Ahmedabad";
  getlocation() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    location = "${pref.getString("Address")}";
  }

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightgreenColor,
        iconTheme: IconThemeData(color: Colors.
        white),
        centerTitle: false,
        title: Row(children: [
          Icon(
            Icons.location_on,
            size: 17,
            color: AppColors.primaryColor,
          ),
          SizedBox(width: width * 0.005,),
          Text(location,
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16)),
          Icon(
            Icons.arrow_drop_down,
            size: 25,
          ),
        ]),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              height: height * 0.06,
              child: TabBar(
                  dividerColor: AppColors.lightgreenColor,
                  labelStyle: GoogleFonts.lato(
                      color:
                      AppColors.primaryColor,
                      fontSize: 11,fontWeight: FontWeight.bold
                  ),
                  indicatorColor: AppColors.primaryColor,
                  tabs: [
                    Tab(text: 'ORDER LIST',),
                    Tab(text: 'THERAPIST LIST',),
                    Tab(text: 'SERVICE LIST',),
                  ]
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  OrderListScreen(spaName: widget.spaName.toString(),),
                  VendorTherapistListScreen(id: widget.id,),
                  ServiceListScreen(id: widget.id,),
                ],
              ),
            ),
          ],
        ),
      ),



    );
  }
}
