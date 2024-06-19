import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:FoxySpa/app_colors/app_colors.dart';
import 'package:FoxySpa/common_widget/round_button.dart';

class AboutUsScreen extends StatefulWidget {

  final String name;
  final String image;
  final String id;
  final String building;
  final String area;
  final String city;

  const AboutUsScreen({super.key, required this.name, required this.image, required this.id, required this.building, required this.area, required this.city});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Image.network(
            widget.image.toString(),
            width: width,
            height: height * 0.33,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// spa name
                Text(
                  widget.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                      fontSize: 22, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: height * 0.005,
                ),

                SizedBox(
                  height: height * 0.005,
                ),

                /// address
                Text(
                  "${widget.building}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                      fontSize: 13, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                Text(
                  "${widget.area},${widget.city}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                      fontSize: 13, fontWeight: FontWeight.w400),
                ),

                SizedBox(
                  height: height * 0.02,
                ),

                /// description
                Text(
                    '''Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.''',
                   style: TextStyle(fontSize: 15,
                   fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                /// Time
                Text(
                  "Time :",
                  style: GoogleFonts.lato(
                      fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mon to Fri : ",
                          style: GoogleFonts.lato(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Sat : ",
                          style: GoogleFonts.lato(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Sun : ",
                          style: GoogleFonts.lato(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(width: width * 0.02,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "9:00 AM to 10:00 PM",
                          style: GoogleFonts.lato(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "9:00 AM to 10:00 PM",
                          style: GoogleFonts.lato(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "Closed",
                          style: GoogleFonts.lato(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),

                      ],
                    )


                  ],
                ),
                SizedBox(
                  height: height * 0.05,
                ),






              ],
            ),
          )
        ]),
      ),
    );
  }
}
