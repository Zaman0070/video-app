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
import 'package:video_app/model/user_model.dart';
import 'package:video_app/model/video.dart';
import 'package:video_app/screen/auth/login.dart';
import 'package:video_app/screen/home/widget/home_box.dart';
import 'package:video_app/screen/subscription/subscription_page.dart';
import 'package:video_app/services/firebase_services.dart';

// ignore: must_be_immutable
class PopularList extends StatefulWidget {
  final String category;
  final String query;
  PopularList({
    super.key,
    required this.category,
    required this.query,
  });

  @override
  State<PopularList> createState() => _PopularListState();
}

class _PopularListState extends State<PopularList> {
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
    getCurrentUser();
    super.initState();
  }

  final _adController = NativeAdController();

  final FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    _adController.ad = AdHelper.loadNativeAd(adController: _adController);

    return StreamBuilder(
      stream: widget.query == 'Papular'
          ? FirebaseFirestore.instance.collection('videos').snapshots()
          : FirebaseFirestore.instance
              .collection('videos')
              .where(widget.category, isEqualTo: widget.query)
              .orderBy('time', descending: true)
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
        // var videos = snapshot.data!.docs;
        // videos.sort((a, b) {
        //   final popularityA = a['watchList'].length;
        //   final popularityB = b['watchList'].length;
        //   return popularityB
        //       .compareTo(popularityA); // Sort in descending order.
        // });

        return ListView.builder(
            padding: EdgeInsets.only(bottom: 70.h, top: 10.h, right: 15.w),
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length +
                ((snapshot.data!.docs.length - 1) ~/ 5) +
                1,
            itemBuilder: (context, index) {
              bool shouldShowAds = DateTime.now().isAfter(payDate) &&
                  DateTime.now().isBefore(expireDate);
              if (index == 0) {
                return _adController.ad != null &&
                        _adController.adLoaded.isTrue &&
                        !shouldShowAds
                    ? SizedBox(
                        height: 70.h, child: AdWidget(ad: _adController.ad!))
                    : Container();
              } else if (index % 6 == 5) {
                return _adController.ad != null &&
                        _adController.adLoaded.isTrue &&
                        !shouldShowAds
                    ? SizedBox(
                        height: 70.h, child: AdWidget(ad: _adController.ad!))
                    : Container();
              } else {
                final videoIndex = index - (index ~/ 6) - 1;
                if (videoIndex < snapshot.data!.docs.length) {
                  VideoModel videoModel = VideoModel.fromMap(
                      snapshot.data!.docs[videoIndex].data());
                  DateTime dateTime =
                      DateTime.fromMillisecondsSinceEpoch(videoModel.time!);
                  return HomeBox(
                    creatTime: DateFormat('dd, MMM yyyy').format(dateTime),
                    viewCount: videoModel.watchList!.length,
                    id: snapshot.data!.docs[videoIndex].id,
                    onTap: () async {
                      if (videoModel.paid == 'unpaid') {
                        Get.to(() => ShowVideo(
                              showAd: shouldShowAds,
                              videoUrl: videoModel.videoUrl!,
                            ));
                        FirebaseAuth.instance.currentUser != null
                            ? await _firebaseServices.addWatchList(
                                postId: snapshot.data!.docs[videoIndex].id,
                                uid: FirebaseAuth.instance.currentUser!.uid,
                                context: context)
                            : null;
                        !shouldShowAds
                            ? AdHelper.showRewardedAd(onComplete: () {})
                            : null;
                      } else if (videoModel.paid == 'paid') {
                        if (FirebaseAuth.instance.currentUser == null) {
                          Get.to(() => const Login());
                        } else {
                          Get.to(() => const SubscriptionPage());
                        }
                      }
                    },
                    videoModel: videoModel,
                  );
                } else {
                  return Container();
                }
              }
            });
      },
    );
  }
}
