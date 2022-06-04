import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:fenua_contests/interfaces/ads_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/styles.dart';
import '../../widgets/custom_animated_widget.dart';

class AdVideoScreen extends StatefulWidget {
  RewardListener listener;
  VideoPlayerController videoPlayerController;


  @override
  _AdVideoScreenState createState() => _AdVideoScreenState();

  AdVideoScreen({
    required this.listener,
    required this.videoPlayerController,
  });
}

class _AdVideoScreenState extends State<AdVideoScreen> {

  var loading = true;
  var showSkip = false;

  @override
  void initState() {
    widget.videoPlayerController.play();
    widget.videoPlayerController.addListener(() {
      if (loading){
        if (widget.videoPlayerController.value.isPlaying){
          setState(() {
            loading = false;
          });
        }}

    });
    super.initState();
  }

  @override
  void dispose() {
    widget.videoPlayerController.seekTo(Duration(seconds: 0));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: Get.height,
              child: CustomVideoPlayer(
                customVideoPlayerController: CustomVideoPlayerController(
                  context: context,
                  videoPlayerController: widget.videoPlayerController,
                  customVideoPlayerSettings: CustomVideoPlayerSettings(
                    customVideoPlayerProgressBarSettings: CustomVideoPlayerProgressBarSettings(
                      allowScrubbing: false,
                    ),
                    showPlayButton: false,
                    showFullscreenButton: false
                  )
                ),
              ),
            ),
            if (!loading)
            Positioned(
                top: 20,
                right: 20,
                child: AnimatedCrossFade(
                  firstChild: Container(
                    height: Get.height * 0.08,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(.5)
                    ),
                    child: TimeCircularCountdown(
                      unit: CountdownUnit.second,
                      isClockwise: false,
                      countdownTotal: (widget.videoPlayerController.value.duration.inSeconds + 3),
                      countdownCurrentColor: appPrimaryColor,
                      countdownRemainingColor: appSecondaryColor,
                      countdownTotalColor: Colors.red,
                      textStyle: normal_h2Style_bold.copyWith(color: Colors.black),
                      onFinished: () {
                        widget.listener.onRewarded();
                        setState(() {
                          showSkip = true;
                        });
                      },
                    ),
                  ),
                  secondChild: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        animationDuration: Duration(seconds: 1)),
                    label: Text("Rewarded"),
                    icon: Icon(Icons.navigate_next),
                  ),
                  duration: Duration(seconds: 1),
                  crossFadeState: showSkip ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                )),
            Positioned(
              bottom: Get.height * 0.1,
              left: 0,
              right: 0,
              child: CustomAnimatedWidget(
                delayMilliseconds: 1500,
                child: Container(
                  color: appPrimaryColor.withOpacity(0.7),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Text(
                        "Title will be here",
                        style: heading2_style.copyWith(color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Description will be here...",
                        style: normal_h3Style.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
