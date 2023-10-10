import 'dart:developer';
import 'dart:io';
import 'package:aba_payment/enumeration.dart';
import 'package:aba_payment/models/aba_merchant.dart';
import 'package:aba_payment/models/aba_transaction.dart';
import 'package:aba_payment/models/aba_transaction_item.dart';
import 'package:aba_payment/services/payway_transaction_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pay/pay.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/helper/config.dart';
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
  bool _isLoading = false;
  final ABAMerchant _merchant = merchant;
  double _total = 6.00;
  double _shipping = 0.0;
  String _firstname = "Thorn";
  String _lastname = "Sonita";
  String _phone = "+85515200361";
  String _email = "jhondoe@testemail.com";
  final String _checkoutApiUrl =
      "https://checkout.payway.com.kh/api/payment-gateway/v1/payments/purchase";
  List<ABATransactionItem> _items = [];

  initialize() {
    if (mounted) {
      setState(() {
        _total = 6.00;
        _shipping = 0.0;
        _firstname = "Thorn";
        _lastname = "Sonita";
        _phone = "+85515200361";
        _email = "jhondoe@testemail.com";
        _items = [
          ABATransactionItem(name: "ទំនិញ 1", price: 1, quantity: 1),
        ];
      });
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

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
            InkWell(
              onTap: () async {
                final service = PaywayTransactionService.instance!;
                final reqTime = service.uniqueReqTime();
                final tranID = service.uniqueTranID();

                var transaction = ABATransaction(
                  merchant: _merchant,
                  tranID: tranID,
                  reqTime: reqTime,
                  amount: double.tryParse(widget.amount),
                  items: [
                    ABATransactionItem(
                        name: "ទំនិញ 1",
                        price: double.tryParse(widget.amount),
                        quantity: 1),
                  ],
                  email: _email,
                  firstname: _firstname,
                  lastname: _lastname,
                  phone: _phone,
                  option: ABAPaymentOption.abapay_deeplink,
                  shipping: _shipping,
                  returnUrl: _checkoutApiUrl,
                );

                var result = await transaction.create();

                log(result.toString());
              },
              child: Padding(
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
