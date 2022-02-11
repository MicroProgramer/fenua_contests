import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/models/user_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ParticipantPublicItem extends StatelessWidget {
  UserInfo user;
  int tickets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.all(10),
        tileColor: Colors.white,
        leading: Container(
          height: Get.height * 0.07,
          width: Get.height * 0.07,
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(user.image_url),
              ),
              shape: BoxShape.circle,),
        ),
        title: Text(
          user.first_name + " " + user.last_name,
          style: TextStyle(color: appPrimaryColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Purchased $tickets tickets"),
      ),
    );
  }

  ParticipantPublicItem({
    required this.user,
    required this.tickets,
  });
}
