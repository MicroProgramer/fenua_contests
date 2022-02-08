import 'package:fenua_contests/helpers/styles.dart';
import 'package:flutter/material.dart';

class WinnerItem extends StatelessWidget {
  const WinnerItem({Key? key}) : super(key: key);

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Winner Name",
              style: TextStyle(
                  color: appPrimaryColor, fontWeight: FontWeight.bold),
            ),
            Text("Contest Name"),
          ],
        ),
        subtitle: Text("20 Jan, 2022"),
        trailing: Text("App Image"),
      ),
    );
  }
}
