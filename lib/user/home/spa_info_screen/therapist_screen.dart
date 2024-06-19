import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TherapistScreen extends StatefulWidget {
  final String id;

  const TherapistScreen({super.key, required this.id});

  @override
  State<TherapistScreen> createState() => _TherapistScreenState();
}


class _TherapistScreenState extends State<TherapistScreen> {
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("id ----------> ${widget.id}");
  }
  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("therapist").where("id", isEqualTo: widget.id).snapshots(),
              builder: (context,snapshot) {
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
                            'No therapist available.',
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
                    horizontal: 15,
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {

                    return Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              child: Image.network(snapshot.data!.docs[index].get("image_url").toString()),
                            ),
                            SizedBox(width: width * 0.05,),
                            Column(

                              children: [
                                RichText(text: TextSpan(
                                  text: "${snapshot.data!.docs[index].get("title").toString()} : ".padRight(15),
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black
                                  ),
                                  children: [
                                    // TextSpan(text:'  '),
                                    TextSpan(
                                      text: snapshot.data!.docs[index].get("name").toString(),
                                      style: GoogleFonts.lato(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ]
                                )),
                                SizedBox(height: height * 0.01,),
                                RichText(text: TextSpan(
                                  text: "Age : ".padRight(10),
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black
                                  ),
                                  children: [
                                    TextSpan(text:'  '),
                                    TextSpan(
                                      text:
                                      "26 years",
                                      style: GoogleFonts.lato(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ]
                                )),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),

                          ],
                        ),
                        Divider(
                          color: Colors.grey.shade400.withOpacity(0.6),
                          thickness: 2,
                        )
                      ],
                    );
                  },
                );
              }
            ),

          ],
        ),
      ),
    );
  }
}
