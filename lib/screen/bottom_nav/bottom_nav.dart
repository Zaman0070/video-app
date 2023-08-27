import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/screen/bookmark/bookmark.dart';
import 'package:video_app/screen/home/home_page.dart';
import 'package:video_app/screen/profile/profile.dart';

class BottomBars extends StatefulWidget {
  const BottomBars({Key? key}) : super(key: key);

  @override
  State<BottomBars> createState() => _BottomBarsState();
}

class _BottomBarsState extends State<BottomBars> {
  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CircleNavBar(
        circleColor: appColor2,
        activeIcons: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/icons/home.png',
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              'assets/icons/bookmark.png',
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/icons/user.png',
              color: Colors.white,
            ),
          ),
        ],
        inactiveIcons: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Image.asset(
              'assets/icons/home.png',
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Image.asset(
              'assets/icons/bookmark.png',
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Image.asset(
              'assets/icons/user.png',
              color: Colors.white,
            ),
          ),
        ],
        color: widgtColor,
        height: 60,
        circleWidth: 50,
        activeIndex: tabIndex,
        onTap: (index) {
          tabIndex = index;
          pageController.jumpToPage(tabIndex);
        },
        // padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: Colors.white24,
        elevation: 2,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          tabIndex = v;
        },
        children: [
          const HomePage(),
          BookMark(),
           Profile(),
        ],
      ),
    );
  }
}
