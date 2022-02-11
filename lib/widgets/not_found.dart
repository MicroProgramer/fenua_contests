import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  String message;
  String? assetImage;
  String? networkImageUrl;
  Color? color;
  double? imageHeight, imageWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          networkImageUrl != null
              ? Image.network(networkImageUrl!)
              : Image.asset(
                  assetImage ?? "assets/images/nothing.png",
                  color: color,
                  height:
                      imageHeight ?? MediaQuery.of(context).size.height * 0.1,
                  width: imageWidth ?? MediaQuery.of(context).size.height * 0.1,
                ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              message,
              style: TextStyle(color: color),
            ),
          ),
        ],
      ),
    );
  }

  NotFound({
    required this.message,
    this.assetImage,
    this.networkImageUrl,
    this.color,
    this.imageHeight,
    this.imageWidth,
  });
}
