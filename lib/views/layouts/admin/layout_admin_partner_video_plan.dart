import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../helpers/styles.dart';
import '../../../widgets/custom_button.dart';
import '../item_layouts/item_admin_partner_video_plan.dart';

class LayoutAdminPartnerVideoPlan extends StatefulWidget {
  LayoutAdminPartnerVideoPlan({Key? key}) : super(key: key);

  @override
  _LayoutAdminPartnerVideoPlanState createState() =>
      _LayoutAdminPartnerVideoPlanState();
}

class _LayoutAdminPartnerVideoPlanState
    extends State<LayoutAdminPartnerVideoPlan> {
  int plan=1;
  int val = 0;
  /* var sheetController = showBottomSheet(
        context: context,
        builder: (context) => BottomSheetWidget());*/
  void _handleRadioValueChange(value) {
    setState(() {
      val = value;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (_,index){
            return ItemAdminPartnerVideoPlan();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(
              isScrollControlled: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              context: context,
              builder: (context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        padding: EdgeInsets.only(bottom: 20),
                        decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: appPrimaryColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15))),
                              width: Get.width,
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Video Ads Plan ",
                                style: heading3_style.copyWith(color: Colors.white),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Select ads Plan",
                                    style: heading4_style.copyWith(
                                        color: appPrimaryColor),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Transform.scale(
                                    scale: 1.2,
                                    child: RadioListTile(
                                      dense: true,
                                      visualDensity: VisualDensity(
                                        horizontal: VisualDensity.minimumDensity,
                                        vertical: VisualDensity.minimumDensity,
                                      ),
                                      title: Text(
                                        "Basic Plan 50.00\$ per week",
                                        style: normal_h4Style.copyWith(
                                            color: appPrimaryColor),
                                      ),
                                      value: 1,
                                      groupValue: plan,
                                      onChanged: (int? value) {
                                        setState(() {
                                          plan = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Transform.scale(
                                    scale: 1.2,
                                    child: RadioListTile(
                                      dense: true,
                                      visualDensity: VisualDensity(
                                        horizontal: VisualDensity.minimumDensity,
                                        vertical: VisualDensity.minimumDensity,
                                      ),
                                      title: Text(
                                        "Medium Plan 150.00\$ per month",
                                        style: normal_h4Style.copyWith(
                                            color: appPrimaryColor),
                                      ),
                                      value: 2,
                                      groupValue: plan,
                                      onChanged: (int? value) {
                                        setState(() {
                                          plan = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Transform.scale(
                                    scale: 1.2,
                                    child: RadioListTile(
                                      dense: true,
                                      visualDensity: VisualDensity(
                                        horizontal: VisualDensity.minimumDensity,
                                        vertical: VisualDensity.minimumDensity,
                                      ),
                                      title: Text(
                                        "Premium Plan 300.00\$ for 3 months",
                                        style: normal_h4Style.copyWith(
                                            color: appPrimaryColor),
                                      ),
                                      value: 3,
                                      groupValue: plan,
                                      onChanged: (int? value) {
                                        setState(() {
                                          plan = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Select ads duration ",
                                    style: heading4_style.copyWith(
                                        color: appPrimaryColor),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Transform.scale(
                                    scale: 1.2,
                                    child: RadioListTile(
                                      dense: true,
                                      visualDensity: VisualDensity(
                                        horizontal: VisualDensity.minimumDensity,
                                        vertical: VisualDensity.minimumDensity,
                                      ),
                                      title: Text(
                                        "5 Seconds Ad ",
                                        style: normal_h4Style.copyWith(
                                            color: appPrimaryColor),
                                      ),
                                      value: 0,
                                      groupValue: val,
                                      onChanged: (int? value) {
                                        setState(() {
                                          val = value!;
                                        });
                                        _handleRadioValueChange(value!);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Transform.scale(
                                    scale: 1.2,
                                    child: RadioListTile(
                                      dense: true,
                                      visualDensity: VisualDensity(
                                        horizontal: VisualDensity.minimumDensity,
                                        vertical: VisualDensity.minimumDensity,
                                      ),
                                      title: Text(
                                        "15 Seconds Ad",
                                        style: normal_h4Style.copyWith(
                                            color: appPrimaryColor),
                                      ),
                                      value: 1,
                                      groupValue: val,
                                      onChanged: (int? value) {
                                        setState(() {
                                          val = value!;
                                        });
                                        _handleRadioValueChange(value!);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CustomButton(
                                      color: appPrimaryColor,
                                      child: Text(
                                        "Add Subscription",
                                        style: normal_h2Style.copyWith(
                                            color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    });
              });
        },
        child: Icon(Icons.add),
      ),
    );

  }
}