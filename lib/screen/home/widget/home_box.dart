import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/model/video.dart';
import 'package:video_app/services/firebase_services.dart';

class HomeBox extends StatefulWidget {
  final String id;
  final VideoModel videoModel;
  final Function()? onTap;
  final int viewCount;
  final String creatTime;
  const HomeBox(
      {super.key,
      required this.videoModel,
      this.onTap,
      required this.id,
      required this.viewCount,
      required this.creatTime});

  @override
  State<HomeBox> createState() => _HomeBoxState();
}

class _HomeBoxState extends State<HomeBox> {
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
    super.initState();
  }

  final FirebaseServices _firebaseServices = FirebaseServices();
  bool isBookmark = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Container(
          height: 180.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: appColor1.withOpacity(0.1)),
          child: Column(
            children: [
              Container(
                height: 155.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: widgtColor,
                    image: DecorationImage(
                        image: NetworkImage(widget.videoModel.thumbnailUrl!),
                        fit: BoxFit.cover),
                    boxShadow: [
                      BoxShadow(
                        color: textColor.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset:
                            const Offset(0, 2), // changes position of shadow
                      ),
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black, Colors.transparent])),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            Icons.bookmark,
                            size: 32,
                            color: widget.videoModel.bookmarks!.contains(
                                    FirebaseAuth.instance.currentUser == null
                                        ? devicId
                                        : FirebaseAuth
                                            .instance.currentUser!.uid)
                                ? appColor2
                                : Colors.white,
                          ),
                          onPressed: () async {
                            OSDeviceState? status =
                                await OneSignal.shared.getDeviceState();
                            // ignore: use_build_context_synchronously
                            await _firebaseServices.addBookmark(
                                postId: widget.id,
                                uid: FirebaseAuth.instance.currentUser == null
                                    ? status!.userId!
                                    : FirebaseAuth.instance.currentUser!.uid,
                                context: context);
                            setState(() {
                              isBookmark = !isBookmark;
                            });
                          },
                        ),
                      ),
                      const Positioned(
                          bottom: 10,
                          right: 10,
                          child: Icon(Icons.play_arrow,
                              size: 32, color: Colors.white)),
                      Positioned(
                        bottom: 20,
                        left: 15,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 250.w,
                              child: Text(
                                widget.videoModel.title!,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: 250.w,
                              child: Text(
                                widget.videoModel.description!,
                                style: const TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.creatTime,
                      style: TextStyle(fontSize: 10.sp),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          size: 12.h,
                          color: textColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.viewCount.toString(),
                          style: TextStyle(fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
