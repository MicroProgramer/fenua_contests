import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserItem extends StatelessWidget {
  const UserItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: Colors.white,
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/placeholder.jpg"),
              ),
              shape: BoxShape.circle,
              color: Colors.red),
        ),
        title: Text(
          "User Name",
          style: TextStyle(color: appPrimaryColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Text("20 Jan, 2022"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
                onTap: (){
                  Get.defaultDialog(
                    title: "Alert",
                    middleText: "Are you sure to ban this user?",
                    textConfirm: "Yes",
                    textCancel: "No",
                    confirmTextColor: Colors.white
                  );
                },
                child: Icon(Icons.block)),
          ],
        ),
      ),
    );
  }
}
