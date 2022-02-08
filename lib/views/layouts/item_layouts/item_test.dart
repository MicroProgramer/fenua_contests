import 'package:flutter/material.dart';

class TestItem extends StatelessWidget {
  const TestItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
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
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
