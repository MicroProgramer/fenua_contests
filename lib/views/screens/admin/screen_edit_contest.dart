import 'package:carousel_slider/carousel_slider.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/views/layouts/item_layouts/item_user.dart';
import 'package:fenua_contests/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditContestScreen extends StatelessWidget {
  const EditContestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> sliderImages = [];

    double totalHeight = Get.height;

    return Scaffold(
      backgroundColor: appSecondaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Contest"),
        backgroundColor: appSecondaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  CarouselSlider.builder(
                    itemCount: 3,
                    itemBuilder: (_, itemIndex, pageViewIndex) {
                      return Container(
                          color: appPrimaryColor,
                          alignment: Alignment.center,
                          child: Text("$itemIndex"));
                    },
                    options: CarouselOptions(
                        disableCenter: true,
                        enableInfiniteScroll: false,
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        height: 200),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      child: Text(
                        "Edit",
                        style: normal_h3Style_bold
                            .merge(TextStyle(color: Colors.black)),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    width: Get.width,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20),
                    height: Get.height * .1,
                    color: appSecondaryColorDark,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Clever Gaming K55",
                          style: TextStyle(
                              color: appTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      height: Get.height * .1,
                      width: Get.height * .1,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg"))),
                    ),
                    title: Text(
                      "Organized by",
                      style: normal_h3Style_bold
                          .merge(TextStyle(color: Colors.black)),
                    ),
                    subtitle: Text(
                      "You",
                      style: normal_h4Style_bold,
                    ),
                    trailing: Wrap(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "End of contest",
                              style: normal_h3Style_bold
                                  .merge(TextStyle(color: Colors.black)),
                            ),
                            InkWell(
                              onTap: () {
                                Get.bottomSheet(
                                  DatePickerDialog(
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2023)),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Fri 25/03",
                                    style: normal_h4Style,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Icon(
                                      Icons.edit,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(
                          "Long Description Long Description Long Description Long Description Long Description Long Description Long Description Long Description Long Description Long Description Long Description Long Description Long Description Long Description ",
                          style: normal_h3Style,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: Text(
                              "Edit",
                              style: normal_h3Style_bold
                                  .merge(TextStyle(color: Colors.black)),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        ShapeBorder shape = RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10.0)));

                        showModalBottomSheet<dynamic>(
                            isScrollControlled: true,
                            context: context,
                            shape: shape,
                            enableDrag: true,
                            backgroundColor: appPrimaryColor,
                            builder: (context) {
                              return DraggableScrollableSheet(
                                maxChildSize: 0.8,
                                expand: false,
                                builder: (BuildContext context,
                                    ScrollController scrollController) {
                                  return Container(
                                    child: Column(
                                      children: [
                                        AppBar(
                                          shape: shape,
                                          centerTitle: true,
                                          actions: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(Icons.close),
                                            ),
                                          ],
                                          title: Container(
                                              child: /*Icon(
                                              Icons.horizontal_rule_rounded,
                                              color: Colors.white54,
                                              size: 100,
                                            ),*/
                                                  Text(
                                            "20 Participants",
                                            style: heading3_style,
                                          )),
                                          // backgroundColor: appPrimaryColor,
                                          elevation: 2,
                                          automaticallyImplyLeading:
                                              false, // remove back button in appbar.
                                        ),
                                        Expanded(
                                            child: ListView.builder(
                                                controller: scrollController,
                                                itemCount: 20,
                                                itemBuilder: (_, index) {
                                                  return UserItem();
                                                }))
                                      ],
                                    ),
                                  );
                                },
                              );
                            });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      tileColor: appSecondaryColorDark,
                      title: Text(
                        "Participants",
                        style: normal_h2Style_bold,
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: appTextColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: Get.width,
                  color: appSecondaryColor,
                  child: CustomButton(
                    color: appPrimaryColor,
                    width: Get.width * 0.7,
                    child: Text(
                      "Save Chances".toUpperCase(),
                      style: normal_h2Style_bold,
                    ),
                    onPressed: () {
                      showSnackBar("Changes Saved", context);
                      Get.back(closeOverlays: true);
                    },
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
