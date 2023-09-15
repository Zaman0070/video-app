import 'dart:developer';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/controller/language_controller.dart';
import 'package:video_app/screen/home/widget/popular_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LanguageController languageController = Get.put(LanguageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 22, top: 5, bottom: 5),
          child: Image.asset(
            'assets/logo/logo.png',
            height: 40,
            width: 40,
          ),
        ),
        title: Row(
          children: [
            Text(
              'Favourite'.tr.toUpperCase(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              'Videos'.tr.toUpperCase(),
              style: TextStyle(
                  color: appColor2,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              // ignore: unrelated_type_equality_checks
              .collection(languageController.language == 0
                  ? 'categoryEnglish'
                  : 'categoryKhmer')
              .doc('w2y1FEwCQ8PkuleHMM3PnI2gSmU2')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            List<dynamic> data = snapshot.data!['category'];
            List<Tab> tabs = [
              for (var i = 0; i < data.length; i++)
                Tab(
                  text: data[i],
                )
            ];
            List<Widget> tabView = [
              for (var i = 0; i < data.length; i++)
                PopularList(
                  //   ignore: unrelated_type_equality_checks
                  category: languageController.language == 0
                      ? 'category'
                      : 'categoryKh',
                  query: data[i],
                )
            ];
            log(data.toString());
            return DefaultTabController(
              length: data.length,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ButtonsTabBar(
                      height: 45.h,
                      buttonMargin: const EdgeInsets.all(2.5),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      radius: 100,
                      backgroundColor: appColor2,
                      unselectedBackgroundColor: appColor2.withOpacity(0.2),
                      unselectedLabelStyle: TextStyle(
                          color: textColor, fontFamily: 'Exo', fontSize: 14.sp),
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Exo',
                          fontSize: 14.sp),
                      tabs: tabs,
                    ),
                    Expanded(
                      child: TabBarView(children: tabView),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
