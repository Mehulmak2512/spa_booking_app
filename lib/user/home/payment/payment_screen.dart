// import 'package:FoxySpa/user/home/payment/completed_payment_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:FoxySpa/app_colors/app_colors.dart';
// import 'package:FoxySpa/common_widget/round_button.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
//
// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});
//
//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//
//   int _selectedValue = 0;
//   // late Razorpay _razorpay;
//
//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   //   _razorpay = Razorpay();
//   //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//   //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//   //   _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   // }
//
//   // @override
//   // void dispose() {
//   //   super.dispose();
//   //   _razorpay.clear();
//   // }
//
//   // void _handlePaymentSuccess(PaymentSuccessResponse response) {
//   //   // Payment successful
//   //   print("Payment Successful: ${response.paymentId}");
//   //   Navigator.push(context, MaterialPageRoute(builder: (context) => CompletedPaymentScreen()));
//   // }
//   //
//   // void _handlePaymentError(PaymentFailureResponse response) {
//   //   // Payment failed
//   //   print("Payment Error: ${response.code.toString()} - ${response.message}");
//   //   // Handle payment failure here
//   // }
//   //
//   // void _handleExternalWallet(ExternalWalletResponse response) {
//   //   // External wallet selected
//   //   print("External Wallet: ${response.walletName}");
//   // }
//   //
//   // void startPayment() {
//   //   var options = {
//   //     'key': 'YOUR_API_KEY', // Your Razorpay API Key
//   //     'amount': 100, // Amount in paise (100 paise = 1 INR)
//   //     'name': 'Your Company Name',
//   //     'description': 'Test Payment',
//   //     'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
//   //     'external': {
//   //       'wallets': ['paytm']
//   //     }
//   //   };
//   //
//   //   try {
//   //     _razorpay.open(options);
//   //   } catch (e) {
//   //     print("Error: $e");
//   //   }
//   // }
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.sizeOf(context).height;
//     final width = MediaQuery.sizeOf(context).width;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Payment Method",
//           style: GoogleFonts.lato(
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//             color: AppColors.whiteColor,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding:  EdgeInsets.all(15.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             /// radio buttons with list
//             Column(
//               children: [
//                 SizedBox(height: height * 0.03,),
//                 Container(
//                   height: height * 0.055,
//                   width: width,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: AppColors.lightgreenColor,),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       Radio(value: 1, groupValue: _selectedValue, onChanged: (value){
//                         setState(() {
//                           _selectedValue = value as int;
//                         });
//                       }),
//                       SvgPicture.asset("assets/user/payment_screen/Vector.svg"),
//                       SizedBox(width: width * 0.05,),
//
//                       Text("RazorPay",style: GoogleFonts.lato(fontWeight: FontWeight.w500,fontSize: 15,),)
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//
//             /// Confirm button
//             RoundButton(name: "Confirm",
//
//                 ontap: (){
//                   Razorpay razorpay = Razorpay();
//                   var options = {
//                     'key': 'rzp_test_1DP5mmOlF5G5ag',
//                     'amount': 100,
//                     'name': 'Jamalia Pratik',
//                     'description': 'abc',
//                     'retry': {'enabled': true, 'max_count': 1},
//                     'send_sms_hash': true,
//                     'prefill': {
//                       'contact': '8888888888',
//                       'email': 'test@razorpay.com'
//                     },
//                     'external': {
//                       'wallets': ['paytm']
//                     }
//                   };
//                   razorpay.on(
//                       Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
//                   razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
//                       handlePaymentSuccessResponse);
//                   razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
//                       handleExternalWalletSelected);
//                   razorpay.open(options);
//               // Navigator.push(context, MaterialPageRoute(builder: (context) => CompletedPaymentScreen()));
//             }),
//
//           ],
//         ),
//       ),
//     );
//   }
//   void handlePaymentErrorResponse(PaymentFailureResponse response) {
//     /*
//     * PaymentFailureResponse contains three values:
//     * 1. Error Code
//     * 2. Error Description
//     * 3. Metadata
//     * */
//     showAlertDialog(context, "Payment Failed",
//         "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
//   }
//
//   void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
//     /*
//     * Payment Success Response contains three values:
//     * 1. Order ID
//     * 2. Payment ID
//     * 3. Signature
//     * */
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompletedPaymentScreen()));
//
//   }
//
//   void handleExternalWalletSelected(ExternalWalletResponse response) {
//     showAlertDialog(
//         context, "External Wallet Selected", "${response.walletName}");
//   }
//
//   void showAlertDialog(BuildContext context, String title, String message) {
//     // set up the buttons
//     Widget continueButton = ElevatedButton(
//       child: const Text("Continue"),
//       onPressed: () {},
//     );
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text(title),
//       content: Text(message),
//     );
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// }
