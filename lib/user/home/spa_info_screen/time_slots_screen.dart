import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:FoxySpa/app_colors/app_colors.dart';
import 'package:FoxySpa/common_widget/round_button.dart';
import 'package:intl/intl.dart';

import '../confirm_booking/confirm_booking_screen.dart';

class TimeSlotsScreen extends StatefulWidget {
  final String spaName;
  final String serviceName;
  final String serviceImage;
  final String servicePrice;
  final String id;
  const TimeSlotsScreen({
    super.key,
    required this.spaName,
    required this.serviceName,
    required this.serviceImage,
    required this.servicePrice,
    required this.id,
  });

  @override
  State<TimeSlotsScreen> createState() => _TimeSlotsScreenState();
}

class _TimeSlotsScreenState extends State<TimeSlotsScreen> {
  final List<String> _timeslotslist = [
    "10:00 AM-11:00 AM",
    "11:00 AM-12:00 PM",
    "12:00 PM-1:00 PM",
    "1:00 PM-2:00 PM",
    "2:00 PM-3:00 PM",
    "3:00 PM-4:00 PM",
    "4:00 PM-5:00 PM",
    "5:00 PM-6:00 PM",
    "6:00 PM-7:00 PM",
    "7:00 PM-8:00 PM",
    "8:00 PM-9:00 PM",
    "9:00 PM-10:00 PM",
  ];
  int? selectedIndex;
  int? selectedTherapistIndex;
  String? formattedDate;
  String? selectedTimeSlot;
  String? therapistName;
  String? therapistTitle;
  String? therapistImageUrl;

  String getSelectedTimeSlot() {
    if (selectedIndex! >= 0 && selectedIndex! < _timeslotslist.length) {
      return _timeslotslist[selectedIndex!];
    } else {
      return ""; // Return empty string if no slot is selected
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Time Slots",
          style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.whiteColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// date
              EasyDateTimeLine(
                initialDate: DateTime.now(),
                activeColor: AppColors.primaryColor,
                onDateChange: (selectedDate) {
                  formattedDate =
                      DateFormat('EEEE, MMM d, y').format(selectedDate);
                  Fluttertoast.showToast(
                    msg: "Selected Date: $formattedDate",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
                headerProps: const EasyHeaderProps(
                  monthPickerType: MonthPickerType.switcher,
                  dateFormatter: DateFormatter.fullDateDMY(),
                ),
                dayProps: const EasyDayProps(
                  dayStructure: DayStructure.dayStrDayNum,
                  borderColor: AppColors.lightgreenColor,
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.lightgreenColor,
                          AppColors.primaryColor,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),

              /// Available Time slots
              Text(
                "Available Time slots",
                style:
                    GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              GridView.builder(
                // padding: const EdgeInsets.all(5),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns in the grid
                  crossAxisSpacing: 10.0, // Spacing between columns
                  mainAxisSpacing: 10.0,
                  mainAxisExtent: 35,
                ),
                itemCount: _timeslotslist.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      selectedTimeSlot = getSelectedTimeSlot();
                      print("selectedtimeSlot ${selectedTimeSlot}");
                      if (selectedTimeSlot!.isNotEmpty) {
                        Fluttertoast.showToast(
                          msg: "Selected Time Slot: $selectedTimeSlot",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: "Please select a time slot",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    child: Container(
                      height: height * 0.05,
                      width: width / 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primaryColor,
                        ),
                        color: selectedIndex == index
                            ? AppColors.lightgreenColor // Selected color
                            : Colors.transparent, // Default color
                      ),
                      child: Center(
                        child: Text(
                          _timeslotslist[index],
                          style: GoogleFonts.lato(
                            color: selectedIndex == index
                                ? AppColors.whiteColor
                                : AppColors.lightgreenColor, //
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),

              /// massage therapistlist
              Text(
                "Massage Therapist",
                style:
                    GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("therapist")
                      .where("id", isEqualTo: widget.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error : ${snapshot.error.toString()}");
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator(
                        color: Colors.blue,
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return const Row(
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
                      );
                    }
                    return GridView.builder(
                      // padding: const EdgeInsets.all(5),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns in the grid
                        crossAxisSpacing: 25.0, // Spacing between columns
                        mainAxisSpacing: 20.0,
                        mainAxisExtent: 175,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedTherapistIndex = index;
                            });
                            therapistName = snapshot
                                .data!.docs[selectedTherapistIndex!]
                                .get("name")
                                .toString();
                            therapistTitle = snapshot
                                .data!.docs[selectedTherapistIndex!]
                                .get("title")
                                .toString();
                            therapistImageUrl = snapshot
                                .data!.docs[selectedTherapistIndex!]
                                .get("image_url")
                                .toString();

                            // You can now use these details as needed
                            Fluttertoast.showToast(
                                msg: "Selected Therapist:  ${therapistName}");
                          },
                          child: Material(
                              borderRadius: BorderRadius.circular(8),
                              elevation: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: selectedTherapistIndex == index
                                        ? AppColors.lightgreenColor
                                        : AppColors.whiteColor,
                                    border: Border.all(
                                      color: selectedTherapistIndex == index
                                          ? AppColors.lightgreenColor
                                          : AppColors.primaryColor,
                                    )),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: height * 0.03),
                                    CircleAvatar(
                                      radius: 41,
                                      backgroundColor: AppColors.primaryColor,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(snapshot
                                            .data!.docs[index]
                                            .get("image_url")
                                            .toString()),
                                        radius: 40,
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.015,
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]
                                          .get("name")
                                          .toString(),
                                      maxLines: 1,
                                      style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: selectedTherapistIndex == index
                                              ? AppColors.whiteColor
                                              : AppColors.lightgreenColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]
                                          .get("title")
                                          .toString(),
                                      maxLines: 1,
                                      style: GoogleFonts.lato(
                                          fontSize: 13,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: height * 0.008,
                                    ),
                                  ],
                                ),
                              )),
                        );
                      },
                    );
                  }),

              SizedBox(
                height: height * 0.04,
              ),

              /// book appointment button
              RoundButton(
                  name: "Book Appointment",
                  ontap: () {
                    if (selectedTimeSlot != null &&
                        selectedIndex != null &&
                        selectedTherapistIndex != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (coontext) => ConfirmBookingScreen(
                                  spaName: widget.spaName,
                                  serviceName: widget.serviceName,
                                  serviceImage: widget.serviceImage,
                                  servicePrice: widget.servicePrice,
                                  appointmentDate: formattedDate.toString(),
                                  appointmentTime: selectedTimeSlot.toString(),
                                  therapistImageUrl:
                                      therapistImageUrl.toString(),
                                  therapistName: therapistName.toString(),
                                  therapistTitle: therapistTitle.toString())));
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please Select Date,Time and Therapist");
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
