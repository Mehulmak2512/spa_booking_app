import 'package:FoxySpa/user/home/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:FoxySpa/app_colors/app_colors.dart';
import 'package:FoxySpa/user/home/spa_info_screen/spa_info_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class City {
  final String image;
  final String name;

  City({required this.image, required this.name});
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  final _scaffcold_key = GlobalKey<ScaffoldState>();

  List<City> citylist = [
    City(image: "assets/user/home_page/Ellipse 5.png", name: "Ahmedabad"),
    City(image: "assets/user/home_page/Ellipse 8.png", name: "Gandhinagar"),
    City(image: "assets/user/home_page/Ellipse 6.png", name: "Goa"),
    City(image: "assets/user/home_page/Ellipse 7.png", name: "Delhi"),
    City(image: "assets/user/home_page/Ellipse 8.png", name: "Hyderabad"),
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffcold_key,

      /// appbar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.lightgreenColor,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: false,
        title: Row(children: [
          Icon(
            Icons.location_on,
            size: 18,
            color: AppColors.primaryColor,
          ),
          SizedBox(
            width: width * 0.005,
          ),
          Text("Ahmedabad",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 20)),
          Icon(
            Icons.arrow_drop_down,
            size: 28,
          ),
        ]),
      ),

      /// body
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.03,
            ),

            /// search textformfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: TextFormField(
                readOnly: true,
                controller: searchController,
                style: GoogleFonts.lato(),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (comtext) => SearchScreen()));
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search_outlined,
                  ),
                  hintText: "Search for Spa",
                  hintStyle: GoogleFonts.lato(),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),

            /// city listview
            // SizedBox(
            //   // height: height * 0.095,
            //   height: height * 0.1,
            //   width: width,
            //   child: ListView.separated(
            //     separatorBuilder: (BuildContext context, int index) {
            //       return SizedBox(
            //         width: width * 0.0,
            //       );
            //     },
            //     itemCount: citylist.length,
            //     scrollDirection: Axis.horizontal,
            //     shrinkWrap: true,
            //     itemBuilder: (context, index) {
            //       return InkWell(
            //         onTap: () {
            //           setState(() {
            //             // cityname = citylist[index].name.toString();
            //             // print(cityname);
            //           });
            //         },
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 12),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               CircleAvatar(
            //                 backgroundImage: AssetImage(citylist[index].image),
            //                 radius: 28,
            //               ),
            //               SizedBox(
            //                 height: height * 0.005,
            //               ),
            //               Text(
            //                 citylist[index].name,
            //                 style: GoogleFonts.lato(
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w400,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // SizedBox(
            //   height: height * 0.03,
            // ),

            ///  icon and hand picked text
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
                    "Hand Picked For You",
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

            ///  hand picked for you Listview
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("spas").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      color: Colors.blue,
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Column(
                      children: [
                        SizedBox(
                          height: height * 0.35,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No spa available.',
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
                  return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 270,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SpaInfoScreen(
                                  index: 0,
                                  name: snapshot.data!.docs[index].get("spa_name").toString(),
                                  image: snapshot.data!.docs[index].get("image_url").toString(),
                                  id: snapshot.data!.docs[index].id.toString(),
                                  building:snapshot.data!.docs[index].get("flat_building").toString(),
                                  area: snapshot.data!.docs[index].get("area_street").toString(),
                                  city: snapshot.data!.docs[index].get("town_city").toString(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: width * 0.435,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                Border.all(color: AppColors.primaryColor)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// spa image
                                ClipRRect(
                                    child: Image.network(
                                      snapshot.data!.docs[index]
                                          .get("image_url")
                                          .toString(),
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
                                        snapshot.data!.docs[index]
                                            .get('spa_name')
                                            .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.lato(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: height * 0.005,
                                      ),

                                      /// address
                                      Text(
                                        snapshot.data!.docs[index]
                                            .get('flat_building')
                                            .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.lato(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height: height * 0.005,
                                      ),
                                      Text(
                                        snapshot.data!.docs[index]
                                            .get('area_street')
                                            .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.lato(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height: height * 0.005,
                                      ),
                                      Text(
                                        snapshot.data!.docs[index]
                                            .get('town_city')
                                            .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.lato(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height: height * 0.005,
                                      ),
                                      Text(
                                        snapshot.data!.docs[index]
                                            .get('status')
                                            .toString()
                                            .toUpperCase(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.lato(
                                            fontSize: 13,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600),
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

            SizedBox(
              height: height * 0.02,
            ),

            ///  icon and   Book your 1st Massage text
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
                    "Book your 1st Massage",
                    maxLines: 1,
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

            ///  Book your 1st Massage
            Container(
              width: width,
              height: height * 0.19,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primaryColor),
                image: DecorationImage(
                  image: AssetImage(
                    "assets/user/services/full_body_massage.png",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              margin: EdgeInsets.symmetric(horizontal: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: height * .2,
                    width: width / 2,
                    decoration: BoxDecoration(
                        color: AppColors.lightgreenColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "50% OFF",
                            style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.whiteColor),
                          ),
                          Text(
                            "Your first Booking",
                            style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.whiteColor),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          InkWell(
                            onTap: (){
                              Clipboard.setData(new ClipboardData(text:"50%OFF"));
                            },
                            child: Container(
                              height: height * 0.05,
                              width: width / 4.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "50%OFF",
                                  style: GoogleFonts.lato(
                                    color: AppColors.primaryColor,
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
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
