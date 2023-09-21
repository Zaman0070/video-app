import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/constant/widget/app_button.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String os = Platform.operatingSystem;
  TextEditingController cardNumberTextController = TextEditingController();
  TextEditingController cVCTextController = TextEditingController();
  TextEditingController nTextController = TextEditingController();
  stripe.CardDetails _card = stripe.CardDetails();
  // var applePayButton = ApplePayButton(
  //   paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
  //   paymentItems: const [
  //     PaymentItem(
  //       label: 'Item A',
  //       amount: '0.01',
  //       status: PaymentItemStatus.final_price,
  //     ),
  //     PaymentItem(
  //       label: 'Item B',
  //       amount: '0.01',
  //       status: PaymentItemStatus.final_price,
  //     ),
  //     PaymentItem(
  //       label: 'Total',
  //       amount: '0.02',
  //       status: PaymentItemStatus.final_price,
  //     )
  //   ],
  //   style: ApplePayButtonStyle.black,
  //   width: double.infinity,
  //   height: 50,
  //   type: ApplePayButtonType.buy,
  //   margin: const EdgeInsets.only(top: 15.0),
  //   onPaymentResult: (result) => debugPrint('Payment Result $result'),
  //   loadingIndicator: const Center(
  //     child: CircularProgressIndicator(),
  //   ),
  // );
  // var googlePayButton = GooglePayButton(
  //   paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
  //   paymentItems: const [
  //     PaymentItem(
  //       label: 'Total',
  //       amount: '0.01',
  //       status: PaymentItemStatus.final_price,
  //     )
  //   ],
  //   type: GooglePayButtonType.pay,
  //   margin: const EdgeInsets.only(top: 15.0),
  //   onPaymentResult: (result) => debugPrint('Payment Result $result'),
  //   loadingIndicator: const Center(
  //     child: CircularProgressIndicator(),
  //   ),
  // );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Pay'.tr,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pay With Card'.tr),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(color: border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(color: border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(color: border),
                          ),
                          hintText: 'Number',
                          hintStyle: const TextStyle(color: Colors.white)),
                      onChanged: (number) {
                        setState(() {
                          _card = _card.copyWith(number: number);
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    width: 80,
                    child: TextField(
                      decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(color: border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(color: border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(color: border),
                          ),
                          hintText: 'CVC'),
                      onChanged: (number) {
                        setState(() {
                          _card = _card.copyWith(cvc: number);
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(color: border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(color: border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(color: border),
                          ),
                          hintText: 'Exp. Month'),
                      onChanged: (number) {
                        setState(() {
                          _card = _card.copyWith(
                              expirationMonth: int.tryParse(number));
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(color: border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(color: border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(color: border),
                          ),
                          hintText: 'Exp. Year'),
                      onChanged: (number) {
                        setState(() {
                          _card = _card.copyWith(
                              expirationYear: int.tryParse(number));
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              AppButton(label: 'Pay', onPressed: () {}),
              const SizedBox(
                height: 35,
              ),
              // Center(child: Platform.isIOS ? applePayButton : googlePayButton),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  const url =
                      'https://link.payway.com.kh/aba?id=2B2E73B0CC9D&code=623217&acc=003148572';
                  if (await canLaunch(url)) {
                    await launch(url,
                        forceWebView: true, enableJavaScript: true);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Center(
                  child: Container(
                    height: 42.h,
                    width: 175.w,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30.r),
                        color: Colors.black),
                    child: Center(
                      child: SvgPicture.asset('assets/icons/aba.svg'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
