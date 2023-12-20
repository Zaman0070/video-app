import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pay/pay.dart';
import 'package:video_app/screen/subscription/payment_config.dart';

class ExpandTileWidget extends StatefulWidget {
  const ExpandTileWidget({
    super.key,
    this.initiallyExpanded,
    required this.amount,
    required this.index,
  });
  final bool? initiallyExpanded;
  final String amount;
  final int index;

  @override
  State<ExpandTileWidget> createState() => _ExpandTileWidgetState();
}

class _ExpandTileWidgetState extends State<ExpandTileWidget> {
  bool isExpanded = false;
  late ApplePayButton applePayButton = ApplePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
    paymentItems: [
      PaymentItem(
        label: 'Item A',
        amount: widget.amount,
        status: PaymentItemStatus.final_price,
      ),
    ],
    style: ApplePayButtonStyle.black,
    width: double.infinity,
    height: 50,
    type: ApplePayButtonType.subscribe,
    margin: const EdgeInsets.only(top: 15.0),
    onPaymentResult: (result) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'payDate': DateTime.now().toString(),
        'payStatus': widget.index == 0 ? 'monthly' : 'yearly',
        'expireDate': widget.index == 0
            ? DateTime.now().add(const Duration(days: 30)).toString()
            : DateTime.now().add(const Duration(days: 365)).toString(),
      }).whenComplete(() {
        Fluttertoast.showToast(msg: 'Payment Success');
      });
    },
    loadingIndicator: const Center(
      child: CircularProgressIndicator(),
    ),
  );
  late GooglePayButton googlePayButton = GooglePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
    paymentItems: [
      PaymentItem(
        label: 'Total',
        amount: widget.amount,
        status: PaymentItemStatus.final_price,
      )
    ],
    type: GooglePayButtonType.subscribe,
    margin: const EdgeInsets.only(top: 15.0),
    onPaymentResult: (result) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'payDate': DateTime.now().toString(),
        'payStatus': widget.index == 0 ? 'monthly' : 'yearly',
        'expireDate': widget.index == 0
            ? DateTime.now().add(const Duration(days: 30)).toString()
            : DateTime.now().add(const Duration(days: 365)).toString(),
      }).whenComplete(() {
        Fluttertoast.showToast(msg: 'Payment Success');

        print(result.toString());
      });
    },
    loadingIndicator: const Center(
      child: CircularProgressIndicator(),
    ),
    onError: (error) => Fluttertoast.showToast(msg: error.toString()),
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      child: ListTile(
        title: Platform.isIOS ? applePayButton : googlePayButton,
      ),
    );
  }
}
