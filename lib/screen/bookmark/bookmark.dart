import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:video_app/admin/widget/show_video.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/controller/ads_controller.dart';
import 'package:video_app/helper/ads.dart';
import 'package:video_app/model/video.dart';
import 'package:video_app/screen/home/widget/home_box.dart';

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

  @override
  void initState() {
    getDevicId();
    // TODO: implement initState
    super.initState();
  }

  final _adController = NativeAdController();

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
              'BOOKMARK ',
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
                itemCount: snapshot.data!.docs.length +
                    (snapshot.data!.docs.length >= 5 ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == 5) {
                    return _adController.ad != null &&
                            _adController.adLoaded.isTrue
                        ? SizedBox(
                            height: 130.h,
                            child: AdWidget(ad: _adController.ad!))
                        : null;
                  } else if (index > 5) {
                    VideoModel videoModel = VideoModel.fromMap(
                        snapshot.data!.docs[index - 1].data());
                    return HomeBox(
                      id: snapshot.data!.docs[index - 1].id,
                      onTap: () {
                        Get.to(() => ShowVideo(
                              videoUrl: videoModel.videoUrl!,
                            ));
                      },
                      videoModel: videoModel,
                    );
                  } else {
                    VideoModel videoModel =
                        VideoModel.fromMap(snapshot.data!.docs[index].data());
                    return HomeBox(
                      id: snapshot.data!.docs[index].id,
                      onTap: () {
                        Get.to(() => ShowVideo(
                              videoUrl: videoModel.videoUrl!,
                            ));
                      },
                      videoModel: videoModel,
                    );
                  }
                }),
          );
        },
      ),
    );
  }
}
