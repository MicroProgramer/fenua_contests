import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/widgets/custom_animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdFullScreen extends StatefulWidget {
  int seconds;


  @override
  _AdFullScreenState createState() => _AdFullScreenState();

  AdFullScreen({
    required this.seconds,
  });
}

class _AdFullScreenState extends State<AdFullScreen> {
  bool showSkip = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          "https://images.unsplash.com/photo-1590099914662-a76f2f83b802?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8OSUzQTE2fGVufDB8fDB8fA%3D%3D&w=1000&q=80"))),
            ),
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
                      countdownTotal: widget.seconds,
                      countdownCurrentColor: appPrimaryColor,
                      countdownRemainingColor: appSecondaryColor,
                      countdownTotalColor: Colors.red,
                      textStyle: normal_h2Style_bold.copyWith(color: Colors.black),
                      onUpdated: (unit, remainingTime) => print('Updated'),
                      onFinished: () {
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
                    label: Text("Skip ad"),
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
