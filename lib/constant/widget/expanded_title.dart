import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pay/pay.dart';
import 'package:video_app/constant/color.dart';
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
    onPaymentResult: (result) => debugPrint('Payment Result $result'),
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
    onPaymentResult: (result) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'payDate': DateTime.now().toString(),
        'payStatus': widget.index == 0 ? 'monthly' : 'yearly',
        'expireDate': widget.index == 0
            ? DateTime.now().add(const Duration(days: 30)).toString()
            : DateTime.now().add(const Duration(days: 365)).toString(),
      });
      log('Payment Result $result');
    },
    loadingIndicator: const Center(
      child: CircularProgressIndicator(),
    ),
    onError: (error) => Fluttertoast.showToast(msg: error.toString()),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade400, width: 1.h),
        // boxShadow: [
        //   BoxShadow(
        //     offset: Offset(1.w, 1.h),
        //     blurRadius: 2.r,
        //     color: Colors.black.withOpacity(0.2),
        //   )
        // ],
      ),
      child: ListTileTheme(
        contentPadding: EdgeInsets.zero,
        dense: true,
        horizontalTitleGap: 0,
        minLeadingWidth: 0,
        minVerticalPadding: 0,
        child: ExpansionTile(
          onExpansionChanged: (val) {
            setState(() {
              isExpanded = val;
            });
          },
          collapsedBackgroundColor: Colors.white,
          initiallyExpanded: widget.initiallyExpanded ?? isExpanded,
          maintainState: true,
          backgroundColor: Colors.grey.shade400,
          tilePadding: EdgeInsets.symmetric(horizontal: 8.h),
          iconColor: isExpanded ? Colors.white : appColor1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          collapsedIconColor: appColor1,
          childrenPadding: const EdgeInsets.all(0),
          title: Row(
            children: [
              Image.asset(
                'assets/icons/ic.png',
                height: 35.h,
                width: 55.w,
              ),
              SizedBox(
                width: 5.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ABA KHQR',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    'Scan to pay with any bank app',
                    style: TextStyle(
                      color: isExpanded ? Colors.black : Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Icon(
            isExpanded ? Icons.close : Icons.arrow_drop_down,
            size: 16.h,
            color: Colors.black,
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: ListTile(
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14.h,
                  color: Colors.black,
                ),
                title: Row(
                  children: [
                    Image.asset(
                      'assets/icons/aba.png',
                      height: 35.h,
                      width: 55.w,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ABA Payway',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 0.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: ListTile(
                title: Platform.isIOS ? applePayButton : googlePayButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
