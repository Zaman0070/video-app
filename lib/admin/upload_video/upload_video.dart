import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/constant/widget/app_button.dart';
import 'package:video_app/controller/image_controller.dart';
import 'package:video_app/model/video.dart';
import 'package:video_app/services/firebase_services.dart';
import 'package:video_player/video_player.dart';

class UploadVideo extends StatefulWidget {
  const UploadVideo({super.key});

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  ImagePickerController controller = Get.put(ImagePickerController());
  FirebaseServices firebaseServices = FirebaseServices();
  var titleTextController = TextEditingController();
  var descriptionTextController = TextEditingController();

  String videoUrl = '';
  List thumbnail = [];

  List<String> privacy = ['Public', 'Private'];
  List<String> paid = ['paid', 'unpaid'];

  String? selectedValue;
  String? englishCategoryValue;
  String? khmerCategoryValue;
  String? paidValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.5,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        shadowColor: Colors.grey.shade600,
        backgroundColor: widgtColor,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w500),
        title: const Text('Upload Video'),
      ),
      body: GetBuilder<ImagePickerController>(
          init: ImagePickerController(),
          builder: (controller) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.pickedVideo == null
                        ? box(onTap: () async {
                            videoUrl = await controller.pickVideo();
                            print(controller.videoThumbnailUrl);
                            setState(() {});
                          })
                        : Container(
                            height: 100.h,
                            width: 1.sw,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                gradient: const LinearGradient(colors: [
                                  appColor1,
                                  appColor2,
                                ])),
                            child: AspectRatio(
                              aspectRatio: controller
                                  .videoPlayerController.value.aspectRatio,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: VideoPlayer(
                                      controller.videoPlayerController)),
                            ),
                          ),
                    SizedBox(
                      height: 10.h,
                    ),
                    controller.pickedFile == null
                        ? boxThumnail(
                            onTap: () async {
                              thumbnail = await controller
                                  .pickImage(ImageSource.gallery);
                              setState(() {});
                            },
                          )
                        : Container(
                            height: 100.h,
                            width: 1.sw,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                gradient: const LinearGradient(colors: [
                                  appColor1,
                                  appColor2,
                                ])),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.file(
                                File(controller.pickedFile!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 18.h,
                    ),
                    SizedBox(
                      height: 45.h,
                      child: TextFormField(
                        controller: titleTextController,
                        decoration: InputDecoration(
                          hintText: 'Enter Title',
                          hintStyle: TextStyle(
                              color: textColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w300),
                          fillColor: widgtColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(color: border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(color: border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(color: border),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(' Privacy Settings',
                        style: TextStyle(
                            color: textColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 12.h,
                    ),
                    field(
                        onTap: (value) {
                          selectedValue = value;
                          setState(() {});
                        },
                        selectedValue: selectedValue,
                        items: privacy),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(' Choose English Category',
                        style: TextStyle(
                            color: textColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 12.h,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('categoryEnglish')
                            .doc('ehEWIZZymdNkj7UZz2CM9L7zBUd2')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<dynamic> englishCat = snapshot.data!['category'];

                          if (snapshot.hasData) {
                            return field(
                              onTap: (value) {
                                englishCategoryValue = value;
                                setState(() {});
                              },
                              selectedValue: englishCategoryValue,
                              items: englishCat,
                            );
                          }
                          return const Center(
                            child: Text('No Category! Please Add Category'),
                          );
                        }),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(' Choose Khmer Category',
                        style: TextStyle(
                            color: textColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 12.h,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('categoryKhmer')
                            .doc('ehEWIZZymdNkj7UZz2CM9L7zBUd2')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<dynamic> khmerCat = snapshot.data!['category'];

                          if (snapshot.hasData) {
                            return field(
                              onTap: (value) {
                                khmerCategoryValue = value;
                                setState(() {});
                              },
                              selectedValue: khmerCategoryValue,
                              items: khmerCat,
                            );
                          }
                          return const Center(
                            child: Text('No Category! Please Add Category'),
                          );
                        }),
                    SizedBox(height: 12.h),
                    Text(' Free/Paid',
                        style: TextStyle(
                            color: textColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 12.h,
                    ),
                    field(
                        onTap: (value) {
                          paidValue = value;
                          setState(() {});
                        },
                        selectedValue: paidValue,
                        items: paid),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(' Description',
                        style: TextStyle(
                            color: textColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 12.h,
                    ),
                    TextFormField(
                      controller: descriptionTextController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter Description',
                        hintStyle: TextStyle(
                            color: textColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300),
                        fillColor: widgtColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: const BorderSide(color: border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: const BorderSide(color: border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: const BorderSide(color: border),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    AppButton(
                        label: 'Publish',
                        onPressed: () async {
                          titleTextController.text.trim().isNotEmpty &&
                                  selectedValue != null &&
                                  paidValue != null &&
                                  khmerCategoryValue != null &&
                                  englishCategoryValue != null
                              ? controller.pickedVideo != null
                                  ? await firebaseServices.uploadVideo(
                                      data: VideoModel(
                                          categoryKh: khmerCategoryValue,
                                          category: englishCategoryValue,
                                          description:
                                              descriptionTextController.text,
                                          title: titleTextController.text,
                                          paid: paidValue,
                                          privacy: selectedValue,
                                          videoUrl: videoUrl,
                                          time: DateTime.now()
                                              .millisecondsSinceEpoch,
                                          uid: FirebaseAuth
                                              .instance.currentUser!.uid,
                                          thumbnailUrl: thumbnail.isEmpty
                                              ? controller.videoThumbnailUrl
                                              : thumbnail[0],
                                          bookmarks: [],
                                          watchList: []))
                                  : Fluttertoast.showToast(
                                      msg: 'Please select video')
                              : Fluttertoast.showToast(
                                  msg: 'All fields are required');
                        }),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget field(
      {Function(String?)? onTap,
      required String? selectedValue,
      required List<dynamic> items}) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: const Row(
          children: [
            Expanded(
              child: Text(
                'Select Item',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: items
            .map((dynamic item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: onTap,
        buttonStyleData: ButtonStyleData(
          height: 45.h,
          width: 1.sw,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: border,
            ),
            color: widgtColor,
          ),
          elevation: 2,
        ),
        iconStyleData: IconStyleData(
          icon: RotatedBox(
            quarterTurns: 1,
            child: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 17.h,
            ),
          ),
          iconSize: 14,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          elevation: 5,
          maxHeight: 200,
          width: 1.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: widgtColor,
          ),
          offset: const Offset(-20, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 18, right: 18),
        ),
      ),
    );
  }

  Widget box({Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100.h,
        width: 1.sw,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: const LinearGradient(colors: [
              appColor1,
              appColor2,
            ])),
        child: Column(
          children: [
            Image.asset(
              'assets/icons/video.png',
              height: 70.h,
              color: Colors.white,
            ),
            Text(
              'Upload New Video',
              style: TextStyle(color: textColor, fontSize: 18.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget boxThumnail({Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100.h,
        width: 1.sw,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: const LinearGradient(colors: [
              appColor1,
              appColor2,
            ])),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Image.asset(
              'assets/icons/picture.png',
              height: 40.h,
              color: Colors.white,
            ),
            SizedBox(
              height: 16.h,
            ),
            Text(
              'Upload Video Thumbnail',
              style: TextStyle(color: textColor, fontSize: 18.sp),
            ),
          ],
        ),
      ),
    );
  }
}
