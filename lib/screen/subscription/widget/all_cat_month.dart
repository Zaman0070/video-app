import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:video_app/constant/color.dart';

class AllCatMonth extends StatelessWidget {
  final int index;
  final int selectIndex;
  final String price;
  final VoidCallback onTap;
  const AllCatMonth(
      {super.key,
      required this.index,
      required this.selectIndex,
      required this.price,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
                color: selectIndex == index ? appColor1 : Colors.grey.shade600),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'All Category'.tr,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Divider(
                  color: Colors.grey.shade600,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Icons.check,
                      color: appColor1,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        'Access to all videos in a VIP-Palms category'.tr,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Icons.check,
                      color: appColor1,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        'Access to all videos in a Lessons category'.tr,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Divider(
                  color: Colors.grey.shade600,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  price,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: appColor1),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
