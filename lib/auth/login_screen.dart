import 'package:FoxySpa/auth/forget_password_screen.dart';
import 'package:FoxySpa/common_widget/round_button.dart';
import 'package:FoxySpa/owner/home/vendor_home_screen.dart';
import 'package:FoxySpa/owner/vendor_total_spa_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_colors/app_colors.dart';
import '../user/bottomnavigatorbar/home_page.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  String? _selectedItem;
  final List<String> _items = ['Customer','Owner'];
  bool _isObscure = true;  // Variable to track password visibility

  bool isLoading = false;

  final _auth = FirebaseAuth.instance;


  String Address = 'Ahmedabaad';


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> GetAddressFromLatLong(Position position)async{

    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemark);
    Placemark place = placemark[0];
    setState(() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("Address", place.locality.toString());
      Address = '${place.locality}';
    });
  }
  getlocation() async {

    Position position = await _determinePosition();
    print("latitude is : ${position.latitude}");
    print("longitude is : ${position.longitude}");
    GetAddressFromLatLong(position);
  }


  Future<void> login(String email,String password,String acctype) async {
    try {
      setState(() {
        isLoading = true;
      });
      await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
      ).then((value) async {
        Fluttertoast.showToast(msg: value.user!.email.toString());

        if(acctype == "Customer"){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return  HomePage(index: 0);
          }));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return  VendorTotalSpaScreen();
          }));
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await  prefs.setString('userType', acctype);
        print("helooooooo-------->$acctype}");
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _selectedItem = null;
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocation();
  }

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return PopScope(
      onPopInvoked: (didPop) {
        SystemNavigator.pop();
      },
      child: Scaffold(
          backgroundColor: AppColors.lightgreenColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),

                    /// app logo image and name
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/auth/Group.svg",
                          semanticsLabel: 'Logo',
                          width: width * 0.02,
                          height: height * 0.1,
                        ),
                        SizedBox(
                          width: width * 0.035,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Foxy Spa",
                              style: GoogleFonts.lato(
                                color: AppColors.primaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Booking",
                              style: GoogleFonts.lato(
                                color: AppColors.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.09,
                    ),

                    Text(
                      "LOG IN",
                      style: GoogleFonts.lato(
                        color: AppColors.whiteColor,
                        fontSize: 37,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.08,
                    ),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          /// account type
                          DropdownButtonFormField2<String>(
                            isExpanded: true,
                            value: _selectedItem,
                            decoration: InputDecoration(
                              hintText: "Choose",
                              hintStyle: GoogleFonts.lato(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey.withOpacity(0.8),
                              ),
                              contentPadding: EdgeInsets.all(10),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.transparent)),
                              filled: true,
                              fillColor: Colors.white,
                            ),

                            items: _items
                                .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style:  GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight : FontWeight.w500
                                ),
                              ),
                            ))
                                .toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select Account Type';
                              }
                              return null;
                            },
                            onChanged: (String? value) {
                              _selectedItem = value;

                            },
                            // onSaved: (value) {
                            //   _selectedItem = value.toString();
                            // },
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.only(right:8),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ),
                              iconSize: 20,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),

                          /// email textformfield
                          TextFormField(
                            controller: emailController,
                            style: GoogleFonts.lato(),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Email",
                              hintStyle: GoogleFonts.lato(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey.withOpacity(0.8)),
                              contentPadding: EdgeInsets.all(10),
                              prefixIcon: Icon(Icons.mark_email_unread_outlined,
                                  color: Colors.grey.withOpacity(0.8)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.transparent)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email';
                              }
                              if (!isValidEmail(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),

                          /// password textformfield
                          TextFormField(
                            controller: passwordController,
                            style: GoogleFonts.lato(),
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Password",
                              hintStyle: GoogleFonts.lato(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey.withOpacity(0.8),
                              ),
                              contentPadding: EdgeInsets.all(10),
                              prefixIcon: Icon(Icons.lock_outline_rounded,
                                  color: Colors.grey.withOpacity(0.8)),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscure =
                                      !_isObscure; // Toggle password visibility
                                    });
                                  },
                                  icon: Icon(
                                    _isObscure
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    color: Colors.grey.withOpacity(0.8),
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.transparent)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                        ],
                      ),
                    ),


                    /// forget password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordScreen() ));
                          },
                          child: Text(
                            "Forget Password?",
                            style: GoogleFonts.lato(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w300,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.05,),

                    /// Login button
                    RoundButton(name: "Log In",
                        loading: isLoading,
                        ontap: (){
                      if(_formKey.currentState!.validate()){
                        login(emailController.text.toString(), passwordController.text.toString(), _selectedItem.toString());
                      }
                    }),

                    SizedBox(height: height * 0.08,),
                    /// signup text
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                      },
                      child: RichText(text: TextSpan(
                        text: "Don’t Have an Account?",
                        style: GoogleFonts.lato(
                          fontSize : 15,
                          fontWeight : FontWeight.w400,
                          color: AppColors.whiteColor,
                        ),
                        children: [
                          TextSpan(text:'  '),
                          TextSpan(
                            text: "SignUp",
                            style: GoogleFonts.lato(
                              fontSize : 15,
                              fontWeight : FontWeight.w400,
                              color: AppColors.primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ]
                      ),
                      ),
                    ),
                    SizedBox(height: height * 0.02,)
                  ],
                ),
              ),
            ),
          )),
    );
  }

  bool isValidEmail(String value) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    return emailRegex.hasMatch(value);
  }
}
