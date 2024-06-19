import 'package:FoxySpa/user/home/spa_info_screen/spa_info_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app_colors/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final searchController = TextEditingController();
  List? searchedSpa;
  List clonedSpa = [];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size(width, height * 0.03),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: searchController,
              style: GoogleFonts.lato(),
              onChanged: (value) {
                setState(() {
                  setState(() {
                    clonedSpa = searchedSpa!.where((element) => element['spa_name'].toString().toLowerCase().contains(value.toLowerCase())).toList();
                  });
                  print(clonedSpa);
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search_outlined,
                ),
                hintText: "Search for Spa ",
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
                  borderSide:
                      const BorderSide(color: AppColors.primaryColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.lightgreenColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        toolbarHeight: height * 0.1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * 0.02,),
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
                  List<DocumentSnapshot> filteredSpas = snapshot.data!.docs.toList();
                  searchedSpa = filteredSpas;
                  print("SEARCHED USER LIST IS $searchedSpa");
                  return GridView.builder(
                      shrinkWrap: true,
                      itemCount:searchController.text.isNotEmpty
                          ? clonedSpa.length:filteredSpas.length,
                      padding: EdgeInsets.symmetric(horizontal: 15),
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
                                  name:searchController.text.isNotEmpty ? clonedSpa[index].get("spa_name").toString() :
                                  filteredSpas[index].get("spa_name").toString() ,
                                  image: searchController.text.isNotEmpty ? clonedSpa[index].get("image_url").toString() :
                                  filteredSpas[index].get("image_url").toString() ,
                                  id: searchController.text.isNotEmpty ? clonedSpa[index].id.toString() :
                                  filteredSpas[index].id.toString() ,
                                  building: searchController.text.isNotEmpty ? clonedSpa[index].get("flat_building").toString() :
                                  filteredSpas[index].get("flat_building").toString() ,
                                  area: searchController.text.isNotEmpty ? clonedSpa[index].get("area_street").toString() :
                                  filteredSpas[index].get("area_street").toString() ,
                                  city: searchController.text.isNotEmpty ? clonedSpa[index].get("town_city").toString() :
                                  filteredSpas[index].get("area_street").toString() ,

                                  // image: snapshot.data!.docs[index].get("image_url").toString(),
                                  // id: snapshot.data!.docs[index].id.toString(),
                                  // building:snapshot.data!.docs[index].get("flat_building").toString(),
                                  // area: snapshot.data!.docs[index].get("area_street").toString(),
                                  // city: snapshot.data!.docs[index].get("town_city").toString(),
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
                                      searchController.text.isNotEmpty ? clonedSpa[index]["image_url"]:
                                      filteredSpas[index]
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
                                        searchController.text.isNotEmpty ? clonedSpa[index]["spa_name"]:
                                        filteredSpas[index].get('spa_name')
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
                                        searchController.text.isNotEmpty ? clonedSpa[index]["flat_building"]:
                                        filteredSpas[index]
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
                                        searchController.text.isNotEmpty ? clonedSpa[index]["area_street"]:
                                        filteredSpas[index]
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
                                        searchController.text.isNotEmpty ? clonedSpa[index]["town_city"]:
                                        filteredSpas[index]
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
                                        searchController.text.isNotEmpty ? clonedSpa[index]["status"]:
                                        filteredSpas[index]
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
            SizedBox(height: height * 0.02,),
          ],
        ),
      ),
    );
  }
}
