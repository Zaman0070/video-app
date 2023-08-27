import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/constant/color.dart';

class ProfileBox extends StatelessWidget {
  final String image;
  final String title;
  final Function() onTap;
  const ProfileBox(
      {super.key,
      required this.image,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Container(
              height: 45.h,
              width: 45.h,
              decoration: BoxDecoration(
                color: widgtColor,
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  image,
                  color: textColor,
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              title,
              style: TextStyle(
                  color: textColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
