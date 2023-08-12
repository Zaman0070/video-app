import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/constant/color.dart';

class AppButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  const AppButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 45.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // border: Border.all(color: appColor1.withOpacity(.9)),
              gradient: const LinearGradient(colors: [
                appColor1,
                appColor2,
              ])),
          width: double.infinity,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: 18.0.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
