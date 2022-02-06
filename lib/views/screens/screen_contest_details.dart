import 'package:carousel_slider/carousel_slider.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContestDetailsScreen extends StatelessWidget {
  const ContestDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> sliderImages = [];

    return Scaffold(
      backgroundColor: appSecondaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Clever Gaming k55"),
        backgroundColor: appSecondaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.share),
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
                    width: Get.width,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20),
                    height: Get.height * .1,
                    color: appSecondaryColorDark,
                    child: Hero(
                      tag: "contest_name",
                      child: Text(
                        "Clever Gaming K55",
                        style: TextStyle(
                            color: appTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
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
                      "Ali Khan",
                      style: normal_h4Style_bold,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "End of contest",
                          style: normal_h3Style_bold
                              .merge(TextStyle(color: Colors.black)),
                        ),
                        Text(
                          "Fri 25/03",
                          style: normal_h4Style,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Long Description Long Description Long Description Long Description Long Description Long Description Long Description Long Description Long Description Long Description Long Description Long Description Long Description Long Description ",
                      style: normal_h3Style,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      tileColor: appSecondaryColorDark,
                      title: Text(
                        "Game Rules",
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
                      "Extra Chances".toUpperCase(),
                      style: normal_h2Style_bold,
                    ),
                    onPressed: () {},
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
