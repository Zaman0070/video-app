import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:video_app/admin/edit_video.dart/edit_video.dart';
import 'package:video_app/admin/widget/show_video.dart';
import 'package:video_app/admin/widget/video_box.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/constant/widget/loading.dart';
import 'package:video_app/model/video.dart';

class AllVideo extends StatelessWidget {
  const AllVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('videos')
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
        return ListView.builder(
            padding: EdgeInsets.zero,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              VideoModel videoModel =
                  VideoModel.fromMap(snapshot.data!.docs[index].data());
              return VideoBox(
                edit: () {
                  Get.to(() => EditVideo(
                        id: snapshot.data!.docs[index].id,
                        videoModel: videoModel,
                      ));
                },
                delete: () async {
                  SmartDialog.showLoading(
                    animationBuilder: (controller, child, animationParam) {
                      return Loading(
                        text: 'Please wait...',
                      );
                    },
                  );
                  Future.delayed(
                    const Duration(seconds: 2),
                    () async {
                      SmartDialog.dismiss();
                      await FirebaseFirestore.instance
                          .collection('videos')
                          .doc(snapshot.data!.docs[index].id)
                          .delete();
                    },
                  );
                },
                onTap: () {
                  Get.to(() => ShowVideo(
                        showAd: true,
                        videoUrl: videoModel.videoUrl!,
                      ));
                },
                videoModel: videoModel,
              );
            });
      },
    ));
  }
}
