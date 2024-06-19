import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:FoxySpa/app_colors/app_colors.dart';
import 'package:FoxySpa/user/home/spa_info_screen/about_us_screen.dart';
import 'package:FoxySpa/user/home/spa_info_screen/services_screen.dart';
import 'package:FoxySpa/user/home/spa_info_screen/therapist_screen.dart';
import 'package:FoxySpa/user/home/spa_info_screen/time_slots_screen.dart';

class SpaInfoScreen extends StatefulWidget {

  final String name;
  final String image;
  final String id;
  final String building;
  final String area;
  final String city;
  int index;
  SpaInfoScreen({super.key,required this.index, required this.name, required this.image, required this.id, required this.building, required this.area, required this.city});

  @override
  State<SpaInfoScreen> createState() => _SpaInfoScreenState();
}

class _SpaInfoScreenState extends State<SpaInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Spa Information",
          style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.whiteColor),
        ),
        centerTitle: true,
      ),
      body: DefaultTabController(
        initialIndex: widget.index,
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
                  fontSize: 13,fontWeight: FontWeight.w800,
                ),
                  indicatorColor: AppColors.primaryColor,
                  tabs: [
                Tab(text: 'ABOUT US',),
                Tab(text: 'SERVICES',),
                Tab(text: 'THERAPIST',),
              ]),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  AboutUsScreen(name: widget.name, image: widget.image, id: widget.id, building: widget.building, area: widget.area, city: widget.city),
                  ServiceScreen(id: widget.id, spaName: widget.name,),
                  TherapistScreen(id: widget.id,)
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
