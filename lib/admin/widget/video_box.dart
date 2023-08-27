import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/model/video.dart';

class VideoBox extends StatelessWidget {
  final VideoModel videoModel;
  final Function() onTap;
  final Function() edit;
  final Function() delete;
  const VideoBox(
      {super.key,
      required this.videoModel,
      required this.onTap,
      required this.edit,
      required this.delete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Container(
          height: 160.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widgtColor,
              image: DecorationImage(
                  image: NetworkImage(videoModel.thumbnailUrl!),
                  fit: BoxFit.cover),
              boxShadow: [
                BoxShadow(
                  color: textColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2), // changes position of shadow
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
                  right: 12,
                  top: 12,
                  child: InkWell(
                    onTap: delete,
                    child: Container(
                      height: 30.h,
                      width: 30.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Image.asset(
                          'assets/icons/delete.png',
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 55,
                  top: 12,
                  child: InkWell(
                    onTap: edit,
                    child: Container(
                      height: 30.h,
                      width: 30.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Image.asset(
                          'assets/icons/editing.png',
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
                const Positioned(
                    bottom: 10,
                    child: Icon(Icons.play_circle_outline,
                        size: 40, color: appColor1)),
                Positioned(
                  bottom: 20,
                  left: 50,
                  child: SizedBox(
                    width: 250.w,
                    child: Text(
                      videoModel.title!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
