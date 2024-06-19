import 'package:FoxySpa/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundButton extends StatelessWidget {
  final String name;
  final VoidCallback ontap;
  final bool loading;
  const RoundButton({super.key, required this.name, required this.ontap,this.loading =  false });

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return  InkWell(
      onTap: ontap,
      child: Container(
        height: height * 0.057,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryColor,
          ),
        ),
        child: Center(
          child:  loading
              ? CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.white,
          )
              : Text(name,style: GoogleFonts.lato(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),),
        ),
      ),
    );
  }
}
