import 'dart:async';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_app/helper/ads.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ShowVideo extends StatefulWidget {
  final String videoUrl;
  final bool showAd;

  const ShowVideo({required this.videoUrl, Key? key, required this.showAd})
      : super(key: key);

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
  List<int> adIntervals = [1, 2, 3];
  @override
  void initState() {
    super.initState();
    startAdTimer();

    videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((value) => setState(() {
            isPlaying = true;
            WakelockPlus.enable();
          }));
    _customVideoPlayerController = CustomVideoPlayerController(
      customVideoPlayerSettings: const CustomVideoPlayerSettings(
          showPlayButton: true,
          showDurationPlayed: true,
          playOnlyOnce: true,
          autoFadeOutControls: true,
          controlBarAvailable: true,
          durationAfterControlsFadeOut: Duration(minutes: 5),
          customVideoPlayerProgressBarSettings:
              CustomVideoPlayerProgressBarSettings(
                  showProgressBar: true, allowScrubbing: true)),
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

  void startAdTimer() {
    if (widget.showAd) {
      return;
    } else {
      if (adCount < adIntervals.length) {
        int remainingTime = adIntervals[adCount] * 60; // Convert to seconds
        timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
          remainingTime--;
          if (remainingTime <= 0) {
            t.cancel(); // Stop the timer
            setState(() {
              videoPlayerController.pause();
            });
            AdHelper.showRewardedAd(onComplete: () {
              setState(() {
                videoPlayerController.play();
              });
              adCount++;
              startAdTimer(); // Schedule the next ad
            });
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    WakelockPlus.disable();
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
