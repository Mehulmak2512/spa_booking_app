

import 'package:FoxySpa/app_colors/app_colors.dart';
import 'package:FoxySpa/user/booking/appointment_detail_screen.dart';
import 'package:FoxySpa/user/home/home_screen.dart';
import 'package:FoxySpa/user/offer/offer_screen.dart';
import 'package:FoxySpa/user/profile/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {

  int index;
  HomePage({super.key,required this.index});

  @override
  State<HomePage> createState() => _HomePageState();
}




class _HomePageState extends State<HomePage> {

  var docid;
  getDocId() {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      usersRef.where('id', isEqualTo: uid).get().then((DocumentSnapshot) {
        if (DocumentSnapshot.docs.isNotEmpty) {
          String? docId = DocumentSnapshot.docs[0].id;
          print(docId);
          setState(() {
            docid = docId;
          });
        }
      });
    }
    return "empty";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocId();
  }


  Widget? _screens(int currentIndex){
    switch (currentIndex){
      case 0: return const HomeScreen();
      case 1: return const AppointmentDetailScreen();
      case 2: return const OfferScreen();
      case 3: return  ProfileScreen(docid: docid.toString(),);

      default:
    }
    return null;
  }


  // int value = 0;



  @override
  Widget build(BuildContext context) {

    return PopScope(
      onPopInvoked: (didPop) {
        SystemNavigator.pop();
      },
      child: Scaffold(

        body: _screens(widget.index),

        bottomNavigationBar: Material(
          elevation: 10,
          child: BottomNavigationBar(
            selectedIconTheme: const IconThemeData(
              size: 30
            ),
            selectedLabelStyle: GoogleFonts.lato(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
            ),
            currentIndex: widget.index,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: Colors.grey,
            unselectedIconTheme: const IconThemeData(
                size: 25
            ),
            onTap: (index) {
              setState(() {
                widget.index = index;
              });
            },
            showSelectedLabels: true,
            showUnselectedLabels: true,
            backgroundColor: Colors.transparent,
            elevation: 2,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.confirmation_num_outlined),
                label: "Booking",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_offer_outlined),
                label: "Offer",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}


