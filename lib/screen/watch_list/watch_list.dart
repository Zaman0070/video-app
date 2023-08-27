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
import 'package:video_app/model/video.dart';
import 'package:video_app/screen/auth/login.dart';
import 'package:video_app/screen/home/widget/home_box.dart';
import 'package:video_app/services/firebase_services.dart';

class WatchList extends StatefulWidget {
  WatchList({super.key});

  @override
  State<WatchList> createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
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
              'Watch List'.tr.toUpperCase(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('videos')
            .where('watchList',
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
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
                            _adController.adLoaded.isTrue
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
                      if (videoModel.paid == 'paid' &&
                          FirebaseAuth.instance.currentUser == null) {
                        Get.to(() => const Login());
                      } else {
                        Get.to(() => ShowVideo(
                              videoUrl: videoModel.videoUrl!,
                            ));
                        FirebaseAuth.instance.currentUser == null
                            ? null
                            : await _firebaseServices.addWatchList(
                                postId: snapshot.data!.docs[index].id,
                                uid: FirebaseAuth.instance.currentUser!.uid,
                                context: context);
                        AdHelper.showRewardedAd(onComplete: () {});
                      }
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