import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/constant/widget/app_button.dart';
import 'package:video_app/model/user_model.dart';
import 'package:video_app/screen/auth/login.dart';
import 'package:video_app/screen/bookmark/bookmark.dart';
import 'package:video_app/screen/profile/widget/profile_box.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_app/screen/splash/splash.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: FirebaseAuth.instance.currentUser != null
            ? StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Text('');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: appColor1,
                      ),
                    );
                  }
                  UserModel userModel =
                      UserModel.fromMap(snapshot.data!.data()!);
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(children: [
                      SizedBox(
                        height: 30.h,
                      ),
                      Center(
                        child: CircleAvatar(
                          radius: 60.h,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              const AssetImage('assets/icons/profile.png'),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 50.h,
                            backgroundImage: NetworkImage(
                              userModel.profilePic == ''
                                  ? 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'
                                  : userModel.profilePic.toString(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Text(userModel.email.toString(),
                          style: TextStyle(
                              color: textColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: 50.h,
                      ),
                      ProfileBox(
                        onTap: () {
                          Get.to(() => BookMark());
                        },
                        title: 'Bookmarks',
                        image: 'assets/icons/bookmark.png',
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      ProfileBox(
                        onTap: () async {
                          Share.share(
                              'https://play.google.com/store/apps/details?id=com.theAppForce.videoapp');
                        },
                        title: 'Share',
                        image: 'assets/icons/send.png',
                      ),
                      SizedBox(
                        height: 35.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 55),
                        child: InkWell(
                          onTap: () async {
                            await FirebaseAuth.instance
                                .signOut()
                                .whenComplete(() {
                              Get.offAll(() =>  Splash());
                            });
                          },
                          child: Container(
                            height: 45.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: appColor1),
                              color: widgtColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Text(
                              'Logout',
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500),
                            )),
                          ),
                        ),
                      )
                    ]),
                  );
                })
            : Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo/logo.png',
                      height: 100.h,
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    AppButton(
                        label: 'Login',
                        onPressed: () {
                          Get.to(() => const Login());
                        })
                  ],
                ),
              ));
  }
}
