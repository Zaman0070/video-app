import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/constant/widget/app_button.dart';
import 'package:video_app/constant/widget/loading.dart';
import 'package:video_app/services/firebase_services.dart';

class DeleteCategory extends StatefulWidget {
  const DeleteCategory({super.key});

  @override
  State<DeleteCategory> createState() => _DeleteCategoryState();
}

class _DeleteCategoryState extends State<DeleteCategory> {
  var categoryTextController = TextEditingController();
  var categoryKhmerTextController = TextEditingController();

  CollectionReference collection =
      FirebaseFirestore.instance.collection('categoryKhmer');
  String documentId = 'w2y1FEwCQ8PkuleHMM3PnI2gSmU2';
  String arrayFieldName = 'category';
  List<dynamic> arrayData = [];
  FirebaseServices firebaseServices = FirebaseServices();

  Future<List<dynamic>> _getArrayData() async {
    try {
      DocumentSnapshot snapshot = await collection.doc(documentId).get();

      if (snapshot.exists) {
        List<dynamic> array = snapshot.get(arrayFieldName);
        return array;
      } else {
        return []; // Document doesn't exist or array field is empty
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Delete Category',
              style: TextStyle(color: Colors.white)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(' Category English',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 12.h,
                  ),
                  SizedBox(
                    height: 45.h,
                    child: TextFormField(
                      controller: categoryTextController,
                      decoration: InputDecoration(
                        hintText: 'Enter Category English',
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
                  Text(' Category Khmer',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 12.h,
                  ),
                  SizedBox(
                    height: 45.h,
                    child: TextFormField(
                      controller: categoryKhmerTextController,
                      decoration: InputDecoration(
                        hintText: 'Enter Category Khmer',
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
                  AppButton(
                      label: 'Upload',
                      onPressed: () async {
                        SmartDialog.showLoading(
                          animationBuilder:
                              (controller, child, animationParam) {
                            return Loading(
                              text: 'Please wait...',
                            );
                          },
                        );
                        if (categoryKhmerTextController.text
                                .trim()
                                .isNotEmpty &&
                            categoryTextController.text.trim().isNotEmpty) {
                          await firebaseServices.addCategoryEng(
                              uid: FirebaseAuth.instance.currentUser!.uid,
                              categoryText: categoryTextController.text,
                              context: context);
                          // ignore: use_build_context_synchronously
                          await firebaseServices.addCategoryKh(
                              uid: FirebaseAuth.instance.currentUser!.uid,
                              categoryText: categoryKhmerTextController.text,
                              context: context);
                          SmartDialog.dismiss();
                        } else {
                          SmartDialog.dismiss();
                          Get.snackbar('Error', 'Please enter category both',
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                        }
                      }),
                ],
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text('All Category',
                  style: TextStyle(
                      color: textColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                color: Colors.grey,
                thickness: 0.6.h,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('categoryEnglish')
                      .doc('w2y1FEwCQ8PkuleHMM3PnI2gSmU2')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
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
                    List<dynamic> category = snapshot.data!['category'];
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: category.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(category[index]),
                          trailing: IconButton(
                            onPressed: () async {
                              arrayData = await _getArrayData();
                              log(arrayData.toString());
                              SmartDialog.showLoading(
                                animationBuilder:
                                    (controller, child, animationParam) {
                                  return Loading(
                                    text: 'Please wait...',
                                  );
                                },
                              );
                              await FirebaseFirestore.instance
                                  .collection('categoryEnglish')
                                  .doc('w2y1FEwCQ8PkuleHMM3PnI2gSmU2')
                                  .update({
                                'category':
                                    FieldValue.arrayRemove([category[index]])
                              });
                              await FirebaseFirestore.instance
                                  .collection('categoryKhmer')
                                  .doc('w2y1FEwCQ8PkuleHMM3PnI2gSmU2')
                                  .update({
                                'category':
                                    FieldValue.arrayRemove([arrayData[index]])
                              });
                              SmartDialog.dismiss();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
