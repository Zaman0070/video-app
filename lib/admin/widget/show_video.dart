import 'dart:async';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_app/helper/ads.dart';

class ShowVideo extends StatefulWidget {
  final String videoUrl;

  const ShowVideo({required this.videoUrl, Key? key}) : super(key: key);

  @override
  State<ShowVideo> createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  late String videoUrl = widget.videoUrl;
  bool isPlaying = false;
  Timer? timer;
  int adCount = 0;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 65), (Timer t) {
      if (adCount < 3) {
        setState(() {
          videoPlayerController.pause();
        });
        AdHelper.showRewardedAd(onComplete: () {
          setState(() {
            videoPlayerController.play();
          });
        });
        adCount++;
      } else {
        t.cancel();
      }
    });
    videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((value) => setState(() {
            isPlaying = true;
          }));
    _customVideoPlayerController = CustomVideoPlayerController(
      customVideoPlayerSettings: const CustomVideoPlayerSettings(
          showDurationPlayed: true,
          customVideoPlayerProgressBarSettings:
              CustomVideoPlayerProgressBarSettings(
            showProgressBar: true,
          )),
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isPlaying
            ? CustomVideoPlayer(
                customVideoPlayerController: _customVideoPlayerController)
            : const CircularProgressIndicator(
                color: Colors.transparent,
              ),
      ),
    );
  }
}
