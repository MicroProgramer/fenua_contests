import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/views/screens/admin/screen_edit_contest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContestItemAdmin extends StatefulWidget {
  const ContestItemAdmin({Key? key}) : super(key: key);

  @override
  _ContestItemAdminState createState() => _ContestItemAdminState();
}

class _ContestItemAdminState extends State<ContestItemAdmin> {
  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * 0.3;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: containerHeight,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg')),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(blurRadius: 5, color: Colors.white)]),
      margin: EdgeInsets.all(10),
      child: Stack(
        children: [
          Positioned(
              right: 0,
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 5, right: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.alarm),
                    SizedBox(
                      width: 5,
                    ),
                    Text("20 Days left"),
                  ],
                ),
              )),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      color: Color(0xD4121212),
                      height: containerHeight * 0.2,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(right: 10),
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Clavier Gaming K55",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                      child: Container(
                        color: appPrimaryColor,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      height: containerHeight * .20,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => EditContestScreen());
                          },
                          style: ElevatedButton.styleFrom(
                              primary: appPrimaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Text("Edit"),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                    child: Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: appPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  height: containerHeight * .3,
                  width: containerHeight * .3,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
