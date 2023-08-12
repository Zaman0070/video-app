import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_app/admin/widget/show_video.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/controller/ads_controller.dart';
import 'package:video_app/helper/ads.dart';
import 'package:video_app/model/video.dart';
import 'package:video_app/screen/auth/login.dart';
import 'package:video_app/screen/home/widget/home_box.dart';

class VideoList extends StatelessWidget {
  final String query;
  VideoList({super.key, required this.query});

  final _adController = NativeAdController();

  @override
  Widget build(BuildContext context) {
    _adController.ad = AdHelper.loadNativeAd(adController: _adController);

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('videos')
          .where('category', isEqualTo: query)
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
        return ListView.builder(
            padding: EdgeInsets.only(bottom: 70.h, top: 10.h, right: 15.w),
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length +
                (snapshot.data!.docs.length >= 5 ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == 5) {
                return _adController.ad != null && _adController.adLoaded.isTrue
                    ? SizedBox(
                        height: 130.h, child: AdWidget(ad: _adController.ad!))
                    : null;
              } else if (index > 5) {
                VideoModel videoModel =
                    VideoModel.fromMap(snapshot.data!.docs[index - 1].data());
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
                    if (videoModel.paid == 'paid' &&
                        FirebaseAuth.instance.currentUser == null) {
                      Get.to(() => const Login());
                    } else {
                      Get.to(() => ShowVideo(
                            videoUrl: videoModel.videoUrl!,
                          ));
                    }
                  },
                  videoModel: videoModel,
                );
              }
            });
      },
    );
  }
}
