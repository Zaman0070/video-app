import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:video_app/constant/widget/loading.dart';
import 'package:video_app/model/video.dart';

class VideoController extends GetxController {
  Future<void> updateVideo(VideoModel videoModel, String id) async {
    try {
      SmartDialog.showLoading(
        animationBuilder: (controller, child, animationParam) {
          return Loading(
            text: 'Please wait...',
          );
        },
      );
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(id)
          .update(videoModel.toMap());
      update();
      Get.back();
      SmartDialog.dismiss();
    } catch (e) {}
  }
}
