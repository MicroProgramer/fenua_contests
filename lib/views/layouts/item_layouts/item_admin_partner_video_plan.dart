import 'package:flutter/material.dart';

import '../../../helpers/styles.dart';

class ItemAdminPartnerVideoPlan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(blurRadius: 5, color: Color(0x414D5678))],
        color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Basic Plan",style: TextStyle(color: appPrimaryColor, fontWeight: FontWeight.bold,fontSize: 18),
          ),
            ],
        ),

          SizedBox(
            height: 10,
          ),
        Text(
          "50.00\$",
          style: normal_h2Style_bold.copyWith(color: appPrimaryColor),
        ),
        Text(
          "Per Week",
          style: normal_h4Style_bold.copyWith(color: appPrimaryColor),
        ),

        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Icon(
              Icons.check,
              color: appPrimaryColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "1 x Video ad for 5 seconds",
              style: normal_h3Style_bold.copyWith(color: appPrimaryColor),
            ),
          ],
        ),
      ],),
    );
  }
}
