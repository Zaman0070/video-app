import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/constant/widget/loading.dart';

class ChangePrice extends StatefulWidget {
  const ChangePrice({super.key});

  @override
  State<ChangePrice> createState() => _ChangePriceState();
}

class _ChangePriceState extends State<ChangePrice> {
  TextEditingController allPriceTextController = TextEditingController();
  TextEditingController yallPriceTextController = TextEditingController();
  TextEditingController singPriceTextController = TextEditingController();
  TextEditingController ysingPriceTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text('Change Price', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'All Category Price month',
                style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45.h,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: allPriceTextController,
                  decoration: InputDecoration(
                    hintText: 'Enter All Category Price',
                    hintStyle: TextStyle(
                        color: textColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300),
                    fillColor: widgtColor,
                    filled: true,
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
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      SmartDialog.showLoading(
                        animationBuilder: (controller, child, animationParam) {
                          return Loading(
                            text: 'Please wait...',
                          );
                        },
                      );
                      await FirebaseFirestore.instance
                          .collection('price')
                          .doc('ehEWIZZymdNkj7UZz2CM9L7zBUd2')
                          .update({'all': allPriceTextController.text});
                      SmartDialog.dismiss();
                      Get.back();
                    },
                    child: Container(
                      height: 30.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        gradient: const LinearGradient(colors: [
                          appColor1,
                          appColor2,
                        ]),
                      ),
                      child: const Center(child: Text('Update')),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'All Category Price year',
                style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45.h,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: yallPriceTextController,
                  decoration: InputDecoration(
                    hintText: 'Enter All Category Price',
                    hintStyle: TextStyle(
                        color: textColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300),
                    fillColor: widgtColor,
                    filled: true,
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
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      SmartDialog.showLoading(
                        animationBuilder: (controller, child, animationParam) {
                          return Loading(
                            text: 'Please wait...',
                          );
                        },
                      );
                      await FirebaseFirestore.instance
                          .collection('price')
                          .doc('ehEWIZZymdNkj7UZz2CM9L7zBUd2')
                          .update({'allYear': yallPriceTextController.text});
                      SmartDialog.dismiss();
                      Get.back();
                    },
                    child: Container(
                      height: 30.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        gradient: const LinearGradient(colors: [
                          appColor1,
                          appColor2,
                        ]),
                      ),
                      child: const Center(child: Text('Update')),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Single Category Price month',
                style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45.h,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: singPriceTextController,
                  decoration: InputDecoration(
                    hintText: 'Enter Single Category Price',
                    hintStyle: TextStyle(
                        color: textColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300),
                    fillColor: widgtColor,
                    filled: true,
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
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      SmartDialog.showLoading(
                        animationBuilder: (controller, child, animationParam) {
                          return Loading(
                            text: 'Please wait...',
                          );
                        },
                      );
                      await FirebaseFirestore.instance
                          .collection('price')
                          .doc('ehEWIZZymdNkj7UZz2CM9L7zBUd2')
                          .update({'single': singPriceTextController.text});
                      SmartDialog.dismiss();
                      Get.back();
                    },
                    child: Container(
                      height: 30.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        gradient: const LinearGradient(colors: [
                          appColor1,
                          appColor2,
                        ]),
                      ),
                      child: const Center(child: Text('Update')),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Single Category Price year',
                style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45.h,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: ysingPriceTextController,
                  decoration: InputDecoration(
                    hintText: 'Enter Single Category Price',
                    hintStyle: TextStyle(
                        color: textColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300),
                    fillColor: widgtColor,
                    filled: true,
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
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      SmartDialog.showLoading(
                        animationBuilder: (controller, child, animationParam) {
                          return Loading(
                            text: 'Please wait...',
                          );
                        },
                      );
                      await FirebaseFirestore.instance
                          .collection('price')
                          .doc('ehEWIZZymdNkj7UZz2CM9L7zBUd2')
                          .update(
                              {'singleYear': ysingPriceTextController.text});
                      SmartDialog.dismiss();
                      Get.back();
                    },
                    child: Container(
                      height: 30.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        gradient: const LinearGradient(colors: [
                          appColor1,
                          appColor2,
                        ]),
                      ),
                      child: const Center(child: Text('Update')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
