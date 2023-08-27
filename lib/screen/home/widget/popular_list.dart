import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:video_app/admin/widget/show_video.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/controller/ads_controller.dart';
import 'package:video_app/helper/ads.dart';
import 'package:video_app/model/video.dart';
import 'package:video_app/screen/auth/login.dart';
import 'package:video_app/screen/home/widget/home_box.dart';
import 'package:video_app/screen/subscription/subscription_page.dart';
import 'package:video_app/services/firebase_services.dart';

// ignore: must_be_immutable
class PopularList extends StatelessWidget {
  PopularList({
    super.key,
  });

  final _adController = NativeAdController();
  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    print(DateTime.now().millisecondsSinceEpoch);
    _adController.ad = AdHelper.loadNativeAd(adController: _adController);

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('videos').snapshots(),
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
        var videos = snapshot.data!.docs;
        videos.sort((a, b) {
          final popularityA = a['watchList'].length;
          final popularityB = b['watchList'].length;
          return popularityB
              .compareTo(popularityA); // Sort in descending order.
        });
        return ListView.builder(
            padding: EdgeInsets.only(bottom: 70.h, top: 10.h, right: 15.w),
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: videos.length,
            itemBuilder: (context, index) {
              if (index % 6 == 5 && index != 0) {
                return _adController.ad != null && _adController.adLoaded.isTrue
                    ? SizedBox(
                        height: 130.h, child: AdWidget(ad: _adController.ad!))
                    : Container();
              }
              VideoModel videoModel = VideoModel.fromMap(videos[index].data());
              DateTime dateTime =
                  DateTime.fromMillisecondsSinceEpoch(videoModel.time!);
              return HomeBox(
                creatTime: DateFormat('dd, MMM yyyy').format(dateTime),
                viewCount: videoModel.watchList!.length,
                id: snapshot.data!.docs[index].id,
                onTap: () async {
                  if (FirebaseAuth.instance.currentUser == null) {
                    Get.to(() => const Login());
                  } else if (videoModel.paid == 'paid') {
                    Get.to(() => const SubscriptionPage());
                  } else {
                    Get.to(() => ShowVideo(
                          videoUrl: videoModel.videoUrl!,
                        ));
                    await _firebaseServices.addWatchList(
                        postId: snapshot.data!.docs[index].id,
                        uid: FirebaseAuth.instance.currentUser!.uid,
                        context: context);
                    AdHelper.showRewardedAd(onComplete: () {});
                  }
                },
                videoModel: videoModel,
              );
            });
      },
    );
  }
}
