// import 'package:FoxySpa/app_colors/app_colors.dart';
// import 'package:FoxySpa/owner/home/add_service/add_therapist_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'add_price_screen.dart';
// import 'add_service_screen.dart';
//
// class AddSevice extends StatelessWidget {
//
//   int index;
//    AddSevice({super.key,required this.index});
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.sizeOf(context).height;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//
//           "Add Services",
//           style: GoogleFonts.lato(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: AppColors.whiteColor),
//         ),
//         centerTitle: true,
//       ),
//       body: DefaultTabController(
//         initialIndex: index,
//         length: 3,
//         child: Column(
//           children: [
//             Container(
//               height: height * 0.06,
//               child: TabBar(
//                   dividerColor: AppColors.lightgreenColor,
//                   labelStyle: GoogleFonts.lato(
//                       color:
//                       AppColors.primaryColor,
//                       fontSize: 11,fontWeight: FontWeight.bold
//                   ),
//                   indicatorColor: AppColors.primaryColor,
//                   tabs: [
//                     Tab(text: 'ADD SERVICE',),
//                     Tab(text: 'ADD PRICE',),
//                     Tab(text: 'ADD THERAPIST',),
//                   ]),
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   AddServiceScreen(),
//                   AddPriceScreen(),
//                   AddTherapistScreen(),
//
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
