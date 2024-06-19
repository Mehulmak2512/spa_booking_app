import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:FoxySpa/auth/login_screen.dart';
import 'package:FoxySpa/user/profile/change_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_colors/app_colors.dart';
import '../bottomnavigatorbar/home_page.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String docid;

  const ProfileScreen({super.key, required this.docid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class MenuList {
  final IconData icon;
  final String title;

  MenuList({required this.icon, required this.title});
}

class _ProfileScreenState extends State<ProfileScreen> {


  final List<MenuList> _menulist = [
    MenuList(icon: Icons.home_outlined, title: "Home"),
    MenuList(icon: Icons.confirmation_num_outlined, title: "My Booking"),
    MenuList(icon: Icons.local_offer_outlined, title: "Offers"),
    MenuList(icon: Icons.lock_outline_rounded, title: "Change Password"),
    MenuList(icon: Icons.person_outline, title: "Edit Profile"),
    MenuList(icon: Icons.logout_outlined, title: "Logout"),
  ];

  final auth = FirebaseAuth.instance;
  String? imageUrl;
  String? name;
  bool isLoading = true;


  getUserDetails() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.docid)
        .get();
    setState(() {
      imageUrl = ds.get("image_url");
      name = ds.get("name");
       isLoading = false;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
    print("doc id ----> ${widget.docid}");
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Profile",
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(),):Column(
        children: [
          Container(
            height: height * 0.23,
            width: width,
            decoration: const BoxDecoration(
              /// backgroud image
              image: DecorationImage(image: AssetImage("assets/user/profile/profile_bg_image.png"),fit: BoxFit.fill)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// profile image
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryColor ,
                  
                  backgroundImage: imageUrl != null && imageUrl!.isNotEmpty ? NetworkImage(imageUrl!) as ImageProvider<Object> : null,
                  child: imageUrl == null && imageUrl!.isEmpty ? Icon(Icons.person,color: AppColors.whiteColor,size: 50,): null,
                ),
                SizedBox(height: height * 0.01,),
                Text( name.toString(),style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteColor,
                ),)
              ],
            ),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          ListView.builder(
            itemCount: _menulist.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (index == 0){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(index: 0,)));
                  }
                  else if (index == 1){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(index: 1,)));
                  }
                  else if (index == 2){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(index: 2,)));
                  }
                  else if (index == 3){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
                  }
                  else if (index == 4){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(docid: widget.docid,)));
                  }
                  else if(index == 5){
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
                  }
                },
                child: Column(
                  children: [
                    ListTile(
                      minVerticalPadding: 0,
                      dense: true,
                      visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        _menulist[index].title,
                        style: GoogleFonts.lato(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color:AppColors.lightgreenColor
                        ),
                      ),
                      leading: Icon(
                        _menulist[index].icon,
                        size: 23,
                        color: AppColors.primaryColor,
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right_sharp,color: AppColors.lightgreenColor,),
                    ),
                    Divider(
                      thickness: 1.5,
                      color: Colors.grey.shade400.withOpacity(0.6),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  void LogOut(){
    auth.signOut().then((value) async {
      SharedPreferences prefs =
      await SharedPreferences.getInstance();
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
