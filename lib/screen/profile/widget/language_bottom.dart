import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/constant/widget/app_button.dart';
import 'package:video_app/controller/language_controller.dart';

class LanguageBottom extends StatefulWidget {
  const LanguageBottom({super.key});

  @override
  State<LanguageBottom> createState() => _LanguageBottomState();
}

class _LanguageBottomState extends State<LanguageBottom> {
  LanguageController languageController = Get.put(LanguageController());
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Choose Language'.tr,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20.h,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  index = 0;
                });
              },
              child: Row(
                children: [
                  Container(
                    height: 25.h,
                    width: 25.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.r),
                        border: Border.all(color: appColor1)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: index == 0
                          ? const CircleAvatar(
                              backgroundColor: appColor1,
                            )
                          : Container(),
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Text(
                    'English',
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  index = 1;
                });
              },
              child: Row(
                children: [
                  Container(
                    height: 25.h,
                    width: 25.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.r),
                        border: Border.all(color: appColor1)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: index == 1
                          ? const CircleAvatar(
                              backgroundColor: appColor1,
                            )
                          : Container(),
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Text(
                    'ខ្មែរ',
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 0.h,
            ),
            AppButton(
                label: "Choose".tr,
                onPressed: () {
                  if (index == 1) {
                    languageController.changeLanguage(1);
                    var loacale = Locale('kh', 'KH');
                    Get.updateLocale(loacale);
                    Get.back();
                  } else if (index == 0) {
                    languageController.changeLanguage(0);
                    var loacale = Locale('en', 'Us');
                    Get.updateLocale(loacale);
                    Get.back();
                  }
                })
          ],
        ),
      ),
    );
  }
}
