import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_app/admin/upload_video/upload_video.dart';
import 'package:video_app/admin/widget/all_video.dart';
import 'package:video_app/admin/widget/my_drawer.dart';
import 'package:video_app/constant/color.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 1.5,
          centerTitle: true,
          shadowColor: Colors.grey.shade600,
          backgroundColor: widgtColor,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/logo/logo.png',
                height: 40.h,
                width: 40.h,
              ),
            )
          ],
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w500),
          title: const Text('Admin Home'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              box(onTap: () {
                Get.to(() => const UploadVideo());
              }),
              const SizedBox(
                height: 12,
              ),
              Divider(
                color: Colors.grey.shade600,
              ),
              const SizedBox(
                height: 12,
              ),
              Text('All Videos List',
                  style: TextStyle(
                      color: textColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 12,
              ),
              const AllVideo(),
            ],
          ),
        ));
  }
}

Widget box({required Function() onTap}) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(
      'Upload New Video',
      style: TextStyle(color: textColor, fontSize: 18.sp),
    ),
    InkWell(
      onTap: onTap,
      child: Container(
        height: 40.h,
        width: 40.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: const LinearGradient(colors: [
              appColor1,
              appColor2,
            ])),
        child: Image.asset(
          'assets/icons/video.png',
          color: Colors.white,
        ),
      ),
    ),
  ]);
}
