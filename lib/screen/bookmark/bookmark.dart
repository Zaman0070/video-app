import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:video_app/admin/widget/show_video.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/controller/ads_controller.dart';
import 'package:video_app/helper/ads.dart';
import 'package:video_app/model/user_model.dart';
import 'package:video_app/model/video.dart';
import 'package:video_app/screen/home/widget/home_box.dart';
import 'package:video_app/services/firebase_services.dart';

class BookMark extends StatefulWidget {
  BookMark({super.key});

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  String devicId = '';
  void getDevicId() async {
    OSDeviceState? status = await OneSignal.shared.getDeviceState();
    setState(() {
      devicId = status!.userId!;
    });
  }

  UserModel? currentUserData;
  DateTime payDate = DateTime.now();
  DateTime expireDate = DateTime.now();

  getCurrentUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        currentUserData = UserModel.fromMap(value.data()!);
        payDate = DateTime.parse(currentUserData!.payDate!);
        expireDate = DateTime.parse(currentUserData!.expireDate!);
        print(
            currentUserData!.phoneNumber.toString() + "=====================");
        print(payDate.toString() + "=====================");
      });
    });
  }

  @override
  void initState() {
    getDevicId();
    getCurrentUser();
    // TODO: implement initState
    super.initState();
  }

  final _adController = NativeAdController();
  final FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    _adController.ad = AdHelper.loadNativeAd(adController: _adController);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: textColor),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Bookmark'.tr.toUpperCase(),
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
            .collection('videos')
            .where('bookmarks',
                arrayContains: FirebaseAuth.instance.currentUser == null
                    ? devicId
                    : FirebaseAuth.instance.currentUser!.uid)
            .orderBy('time')
            .snapshots(),
        builder: (context, snapshot) {
          bool shouldShowAds = DateTime.now().isAfter(payDate) &&
              DateTime.now().isBefore(expireDate);
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: appColor1,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: appColor1,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
                padding: EdgeInsets.only(
                  bottom: 70.h,
                  top: 10.h,
                ),
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  if (index % 6 == 5 && index != 0) {
                    return _adController.ad != null &&
                            _adController.adLoaded.isTrue &&
                            !shouldShowAds
                        ? SizedBox(
                            height: 130.h,
                            child: AdWidget(ad: _adController.ad!))
                        : Container();
                  }

                  VideoModel videoModel =
                      VideoModel.fromMap(snapshot.data!.docs[index].data());
                  DateTime dateTime =
                      DateTime.fromMillisecondsSinceEpoch(videoModel.time!);
                  return HomeBox(
                    creatTime: DateFormat('dd, MMM yyyy').format(dateTime),
                    viewCount: videoModel.watchList!.length,
                    id: snapshot.data!.docs[index].id,
                    onTap: () async {
                      Get.to(() => ShowVideo(
                            showAd: shouldShowAds,
                            videoUrl: videoModel.videoUrl!,
                          ));
                      FirebaseAuth.instance.currentUser == null
                          ? null
                          : await _firebaseServices.addWatchList(
                              postId: snapshot.data!.docs[index].id,
                              uid: FirebaseAuth.instance.currentUser!.uid,
                              context: context);
                      !shouldShowAds
                          ? AdHelper.showRewardedAd(onComplete: () {})
                          : null;
                    },
                    videoModel: videoModel,
                  );
                }),
          );
        },
      ),
    );
  }
}
