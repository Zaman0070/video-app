// import 'dart:developer';
// import 'dart:io';
// // ignore: depend_on_referenced_packages
// import 'package:aba_payment/aba_payment.dart';
// // ignore: depend_on_referenced_packages
// import 'package:aba_payment/enumeration.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
// import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:pay/pay.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:video_app/constant/color.dart';
// import 'package:video_app/constant/widget/app_button.dart';
// import 'package:video_app/constant/widget/expanded_title.dart';
// import 'package:video_app/helper/config.dart';
// import 'package:video_app/helper/payment.dart';
// import 'package:video_app/screen/subscription/payment_config.dart';
// // ignore: depend_on_referenced_packages
// import 'package:aba_payment/services/payway_transaction_service.dart';

// class PaymentPage extends StatefulWidget {
//   final String amount;
//   const PaymentPage({super.key, required this.amount});

//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   bool _isLoading = false;
//   final ABAMerchant _merchant = merchant;
//   double _total = 6.00;
//   double _shipping = 0.0;
//   String _firstname = "Thorn";
//   String _lastname = "Sonita";
//   String _phone = "+85515200361";
//   String _email = "jhondoe@testemail.com";
//   final String _checkoutApiUrl =
//       "https://checkout.payway.com.kh/api/payment-gateway/v1/payments/purchase";
//   List<ABATransactionItem> _items = [];

//   initialize() {
//     if (mounted) {
//       setState(() {
//         _total = 6.00;
//         _shipping = 0.0;
//         _firstname = "Thorn";
//         _lastname = "Sonita";
//         _phone = "+85515200361";
//         _email = "jhondoe@testemail.com";
//         _items = [
//           ABATransactionItem(name: "ទំនិញ 1", price: 1, quantity: 1),
//         ];
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     initialize();
//   }

//   Payment payment = Payment();
//   String os = Platform.operatingSystem;
//   TextEditingController cardNumberTextController = TextEditingController();
//   TextEditingController cVCTextController = TextEditingController();
//   TextEditingController nTextController = TextEditingController();
//   stripe.CardDetails _card = stripe.CardDetails();
//   late ApplePayButton applePayButton = ApplePayButton(
//     paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
//     paymentItems: [
//       PaymentItem(
//         label: 'Item A',
//         amount: widget.amount,
//         status: PaymentItemStatus.final_price,
//       ),
//     ],
//     style: ApplePayButtonStyle.black,
//     width: double.infinity,
//     height: 50,
//     type: ApplePayButtonType.buy,
//     margin: const EdgeInsets.only(top: 15.0),
//     onPaymentResult: (result) => debugPrint('Payment Result $result'),
//     loadingIndicator: const Center(
//       child: CircularProgressIndicator(),
//     ),
//   );
//   late GooglePayButton googlePayButton = GooglePayButton(
//     paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
//     paymentItems: [
//       PaymentItem(
//         label: 'Total',
//         amount: widget.amount,
//         status: PaymentItemStatus.final_price,
//       )
//     ],
//     type: GooglePayButtonType.subscribe,
//     margin: const EdgeInsets.only(top: 15.0),
//     onPaymentResult: (result) {
//       log('Payment Result $result');
//     },
//     loadingIndicator: const Center(
//       child: CircularProgressIndicator(),
//     ),
//     onError: (error) => Fluttertoast.showToast(msg: error.toString()),
//   );
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: Text(
//           'Pay'.tr,
//           style: const TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
         
//               // Text('Pay With Card'.tr),
//               // const SizedBox(
//               //   height: 20,
//               // ),
//               // Row(
//               //   children: [
//               //     Expanded(
//               //       flex: 2,
//               //       child: TextField(
//               //         decoration: InputDecoration(
//               //             border: OutlineInputBorder(
//               //               borderRadius: BorderRadius.circular(10.r),
//               //               borderSide: const BorderSide(color: border),
//               //             ),
//               //             enabledBorder: OutlineInputBorder(
//               //               borderRadius: BorderRadius.circular(10.r),
//               //               borderSide: const BorderSide(color: border),
//               //             ),
//               //             focusedBorder: OutlineInputBorder(
//               //               borderRadius: BorderRadius.circular(10.r),
//               //               borderSide: const BorderSide(color: border),
//               //             ),
//               //             hintText: 'Number',
//               //             hintStyle: const TextStyle(color: Colors.white)),
//               //         onChanged: (number) {
//               //           setState(() {
//               //             _card = _card.copyWith(number: number);
//               //           });
//               //         },
//               //         keyboardType: TextInputType.number,
//               //       ),
//               //     ),
//               //     Container(
//               //       padding: const EdgeInsets.symmetric(horizontal: 4),
//               //       width: 80,
//               //       child: TextField(
//               //         decoration: InputDecoration(
//               //             hintStyle: const TextStyle(color: Colors.white),
//               //             border: OutlineInputBorder(
//               //               borderRadius: BorderRadius.circular(10.r),
//               //               borderSide: const BorderSide(color: border),
//               //             ),
//               //             enabledBorder: OutlineInputBorder(
//               //               borderRadius: BorderRadius.circular(10.r),
//               //               borderSide: const BorderSide(color: border),
//               //             ),
//               //             focusedBorder: OutlineInputBorder(
//               //               borderRadius: BorderRadius.circular(10.r),
//               //               borderSide: const BorderSide(color: border),
//               //             ),
//               //             hintText: 'CVC'),
//               //         onChanged: (number) {
//               //           setState(() {
//               //             _card = _card.copyWith(cvc: number);
//               //           });
//               //         },
//               //         keyboardType: TextInputType.number,
//               //       ),
//               //     ),
//               //   ],
//               // ),
//               // const SizedBox(
//               //   height: 20,
//               // ),
//               // Row(
//               //   children: [
//               //     Expanded(
//               //       flex: 1,
//               //       child: TextField(
//               //         decoration: InputDecoration(
//               //             hintStyle: const TextStyle(color: Colors.white),
//               //             border: OutlineInputBorder(
//               //               borderRadius: BorderRadius.circular(10.r),
//               //               borderSide: const BorderSide(color: border),
//               //             ),
//               //             enabledBorder: OutlineInputBorder(
//               //               borderRadius: BorderRadius.circular(10.r),
//               //               borderSide: const BorderSide(color: border),
//               //             ),
//               //             focusedBorder: OutlineInputBorder(
//               //               borderRadius: BorderRadius.circular(10.r),
//               //               borderSide: const BorderSide(color: border),
//               //             ),
//               //             hintText: 'Exp. Month'),
//               //         onChanged: (number) {
//               //           setState(() {
//               //             _card = _card.copyWith(
//               //                 expirationMonth: int.tryParse(number));
//               //           });
//               //         },
//               //         keyboardType: TextInputType.number,
//               //       ),
//               //     ),
//               //     const SizedBox(
//               //       width: 10,
//               //     ),
//               //     Expanded(
//               //       child: TextField(
//               //         decoration: InputDecoration(
//               //             hintStyle: const TextStyle(color: Colors.white),
//               //             border: OutlineInputBorder(
//               //               borderRadius: BorderRadius.circular(10.r),
//               //               borderSide: const BorderSide(color: border),
//               //             ),
//               //             enabledBorder: OutlineInputBorder(
//               //               borderRadius: BorderRadius.circular(10.r),
//               //               borderSide: const BorderSide(color: border),
//               //             ),
//               //             focusedBorder: OutlineInputBorder(
//               //               borderRadius: BorderRadius.circular(10.r),
//               //               borderSide: const BorderSide(color: border),
//               //             ),
//               //             hintText: 'Exp. Year'),
//               //         onChanged: (number) {
//               //           setState(() {
//               //             _card = _card.copyWith(
//               //                 expirationYear: int.tryParse(number));
//               //           });
//               //         },
//               //         keyboardType: TextInputType.number,
//               //       ),
//               //     ),
//               //   ],
//               // ),
//               // const SizedBox(
//               //   height: 20,
//               // ),
//               // AppButton(label: 'Pay', onPressed: () async {}),
//               // const SizedBox(
//               //   height: 35,
//               // ),
//               // Center(child: Platform.isIOS ? applePayButton : googlePayButton),
//               // const SizedBox(
//               //   height: 20,
//               // ),
//               // InkWell(
//               //   onTap: () async {
//               //     // payment.handleCheckout();
//               //     final service = PaywayTransactionService.instance!;
//               //     final reqTime = service.uniqueReqTime();
//               //     final tranID = service.uniqueTranID();

//               //     var transaction = ABATransaction(
//               //       merchant: service.merchant!,
//               //       tranID: tranID,
//               //       reqTime: reqTime,
//               //       amount: double.tryParse(widget.amount),
//               //       items: [
//               //         ABATransactionItem(
//               //             name: "ទំនិញ 1",
//               //             price: double.tryParse(widget.amount),
//               //             quantity: 1),
//               //       ],
//               //       email: 'support@mylekha.app',
//               //       firstname: 'Miss',
//               //       lastname: 'My Lekha',
//               //       phone: '010464144',
//               //       option: ABAPaymentOption.abapay_deeplink,
//               //       shipping: 0.0,
//               //       returnUrl: "https://mylekha.app",
//               //     );

//               //     var result = await transaction.create();
//               //     log(result.description.toString());

//               //     log(result.toString());
//               //   },
//               //   child: Center(
//               //     child: Container(
//               //       height: 42.h,
//               //       width: 175.w,
//               //       decoration: BoxDecoration(
//               //           border: Border.all(color: Colors.grey),
//               //           borderRadius: BorderRadius.circular(30.r),
//               //           color: Colors.black),
//               //       child: Center(
//               //         child: SvgPicture.asset('assets/icons/aba.svg'),
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               // const SizedBox(
//               //   height: 20,
//               // ),

//               // //////////////////////////////////
//               // ABACheckoutContainer(
//               //   onCreatedTransaction: (value, msg) => print(msg),
//               //   amount: _total,
//               //   shipping: _shipping,
//               //   firstname: _firstname,
//               //   lastname: _lastname,
//               //   email: _email,
//               //   phone: _phone,
//               //   items: _items,
//               //   checkoutApiUrl: _checkoutApiUrl,
//               //   merchant: _merchant,
//               //   onBeginCheckout: (transaction) {
//               //     setState(() => _isLoading = true);
//               //     SmartDialog.showLoading();
//               //     log("onBeginCheckout ${transaction!.toMap()}");
//               //   },
//               //   onFinishCheckout: (transaction) {
//               //     setState(() => _isLoading = false);
//               //     SmartDialog.dismiss();
//               //   },
//               //   onBeginCheckTransaction: (transaction) {
//               //     setState(() => _isLoading = true);
//               //     SmartDialog.showLoading();
//               //     log("onBeginCheckTransaction ${transaction!.toMap()}");
//               //   },
//               //   onFinishCheckTransaction: (transaction) {
//               //     setState(() => _isLoading = false);

//               //     SmartDialog.dismiss();
//               //     log("onFinishCheckTransaction ${transaction!.toMap()}");
//               //   },
//               //   enabled: !_isLoading,
//               //   onPaymentFail: (transaction) {
//               //     print("onPaymentFail ${transaction!.toMap()}");
//               //   },
//               //   onPaymentSuccess: (transaction) {
//               //     log("onPaymentSuccess ${transaction!.toMap()}");
//               //   },
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
