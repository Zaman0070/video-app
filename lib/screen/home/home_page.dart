import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/screen/home/widget/video_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


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
              'FAVOURITE ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              'VIDEOS',
              style: TextStyle(
                  color: appColor2,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 5,
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 12),
          child: Column(
            children: <Widget>[
              ButtonsTabBar(
                height: 45.h,
                buttonMargin: const EdgeInsets.all(2.5),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                radius: 100,
                backgroundColor: appColor2,
                unselectedBackgroundColor: appColor2.withOpacity(0.2),
                unselectedLabelStyle: TextStyle(
                    color: textColor, fontFamily: 'Exo', fontSize: 14.sp),
                labelStyle: TextStyle(
                    color: Colors.white, fontFamily: 'Exo', fontSize: 14.sp),
                tabs: const [
                  Tab(
                    text: "Popular",
                  ),
                  Tab(
                    text: "All Palm",
                  ),
                  Tab(
                    text: "Special Palm",
                  ),
                  Tab(
                    text: "Lesson",
                  ),
                  Tab(
                    text: "Astrology",
                  ),
                ],
              ),
               Expanded(
                child: TabBarView(
                  children: <Widget>[
                    VideoList(
                      query: 'Popular',
                    ),
                    VideoList(
                      query: 'All Palm',
                    ),
                    VideoList(
                      query: 'Special Palm',
                    ),
                    VideoList(
                      query: 'Lesson',
                    ),
                    VideoList(
                      query: 'Astrology',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
