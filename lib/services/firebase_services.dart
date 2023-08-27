import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:video_app/constant/widget/loading.dart';
import 'package:video_app/model/video.dart';

class FirebaseServices {
  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection("videos");
  final CollectionReference bookmark =
      FirebaseFirestore.instance.collection("bookmark");

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference categoryEng =
      FirebaseFirestore.instance.collection("categoryEnglish");
  final CollectionReference categoryKh =
      FirebaseFirestore.instance.collection("categoryKhmer");

  uploadVideo({required VideoModel data}) async {
    try {
      SmartDialog.showLoading(
        animationBuilder: (controller, child, animationParam) {
          return Loading(
            text: 'Please wait...',
          );
        },
      );
      await productsRef.doc().set(data.toMap()).then((value) {
        Get.back();
        SmartDialog.dismiss();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addWatchList({
    required String postId,
    required String uid,
    required BuildContext context,
  }) async {
    SmartDialog.showLoading(
      animationBuilder: (controller, child, animationParam) {
        return Loading(
          text: 'Please wait...',
        );
      },
    );
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('videos').doc(postId).get();
    List bookmark = (snap.data() as dynamic)['bookmarks'];
    try {
      if (bookmark.contains(uid)) {
        FirebaseFirestore.instance.collection('videos').doc(postId).update({
          'watchList': FieldValue.arrayRemove([uid])
        });
        SmartDialog.dismiss();
      } else {
        FirebaseFirestore.instance.collection('videos').doc(postId).update({
          'watchList': FieldValue.arrayUnion([uid])
        });
        SmartDialog.dismiss();
      }
    } catch (err) {
      err.toString();
    }
  }

  Future<void> addCategoryEng({
    required String uid,
    required String categoryText,
    required BuildContext context,
  }) async {
    DocumentSnapshot snap = await categoryEng.doc(uid).get();
    List categories = (snap.data() as dynamic)['category'];
    try {
      if (categories.contains(categoryText)) {
        return;
      } else {
        categoryEng.doc(uid).update({
          'category': FieldValue.arrayUnion([categoryText])
        });
      }
    } catch (err) {
      err.toString();
    }
  }
  Future<void> addCategoryKh({
    required String uid,
    required String categoryText,
    required BuildContext context,
  }) async {
    DocumentSnapshot snap = await categoryKh.doc(uid).get();
    List categories = (snap.data() as dynamic)['category'];
    try {
      if (categories.contains(categoryText)) {
        return;
      } else {
        categoryKh.doc(uid).update({
          'category': FieldValue.arrayUnion([categoryText])
        });
      }
    } catch (err) {
      err.toString();
    }
  }

  Future<void> addBookmark({
    required String postId,
    required String uid,
    required BuildContext context,
  }) async {
    SmartDialog.showLoading(
      animationBuilder: (controller, child, animationParam) {
        return Loading(
          text: 'Please wait...',
        );
      },
    );
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('videos').doc(postId).get();
    List bookmark = (snap.data() as dynamic)['bookmarks'];
    try {
      if (bookmark.contains(uid)) {
        FirebaseFirestore.instance.collection('videos').doc(postId).update({
          'bookmarks': FieldValue.arrayRemove([uid])
        });
        SmartDialog.dismiss();
      } else {
        FirebaseFirestore.instance.collection('videos').doc(postId).update({
          'bookmarks': FieldValue.arrayUnion([uid])
        });
        SmartDialog.dismiss();
      }
    } catch (err) {
      err.toString();
    }
  }
}
