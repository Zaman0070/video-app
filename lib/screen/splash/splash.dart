import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:video_app/admin/auth/admin_login.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/constant/widget/app_button.dart';
import 'package:video_app/constant/widget/loading.dart';
import 'package:video_app/screen/bottom_nav/bottom_nav.dart';
import 'package:video_app/services/share_pref.dart';

// ignore: must_be_immutable
class Splash extends StatelessWidget {
  Splash({super.key});
  SharePref _sharePref = SharePref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(
            flex: 2,
          ),
          InkWell(
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => Colors.transparent),
              onLongPress: () {
                Get.to(() => const AdminLogin());
              },
              child: Image.asset('assets/icons/splash.png')),
          const Spacer(),
          Text('Watch your favorite videos anytime, anywhere',
              style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor)),
          AppButton(
              label: 'Continue',
              onPressed: () async {
                _sharePref.saveType('user', 'login');
                SmartDialog.showLoading(
                  animationBuilder: (controller, child, animationParam) {
                    return Loading(
                      text: 'Please wait...',
                    );
                  },
                );
                OSDeviceState? status = await OneSignal.shared.getDeviceState();
                log(status!.userId!);

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(status.userId)
                    .set({'device_id': status.userId}).whenComplete(() {
                  SmartDialog.dismiss();
                  Get.offAll(() => const BottomBars());
                });
              }),
          SizedBox(height: 20.h),
        ],
      ),
    ));
  }
}
