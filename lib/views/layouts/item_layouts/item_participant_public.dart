import 'package:cached_network_image/cached_network_image.dart';
import 'package:fenua_contests/generated/locales.g.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/models/user_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParticipantPublicItem extends StatelessWidget {
  UserInfo user;
  int tickets;
  bool winner;
  int minTickets;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width * 0.7,
        child: ListTile(
          minLeadingWidth: 50,
          onTap: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.all(10),
          tileColor: Colors.white,
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(user.image_url),
              ),
              shape: BoxShape.circle,
            ),
          ),
          trailing: winner ? Text(
            "Winner",
            style: normal_h2Style_bold.merge(TextStyle(color: Colors.green)),
          ) : Container(height: 10, width: 10,),
          title: Container(
            width: Get.width * 0.5,
            child: Text(
              user.first_name + " " + user.last_name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: (tickets >= minTickets ? appPrimaryColor : Colors.red[200]), fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Text(LocaleKeys.Invested1ticket.tr.replaceAll("1", "$tickets")),
        ),
      ),
    );
  }

  ParticipantPublicItem({
    required this.user,
    required this.tickets,
    required this.winner,
    required this.minTickets,
  });
}
