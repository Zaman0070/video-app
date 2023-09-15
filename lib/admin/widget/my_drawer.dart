import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_app/admin/change_price/change_price.dart';
import 'package:video_app/admin/delet_category.dart/delet_category.dart';
import 'package:video_app/screen/bottom_nav/bottom_nav.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh,
      width: 0.8.sw,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/logo/logo.png',
                height: 60.h,
                width: 60.h,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '    Admin',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(
              color: Colors.grey.shade400,
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Get.to(() => const DeleteCategory());
              },
              child: Text(
                'Delete Categories',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Get.to(() => const ChangePrice());
              },
              child: Text(
                'Change Price',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut().whenComplete(() {
                  Get.offAll(() => const BottomBars());
                });
              },
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
