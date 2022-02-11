import 'package:cached_network_image/cached_network_image.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/models/contest.dart';
import 'package:fenua_contests/models/user_info.dart';
import 'package:flutter/material.dart';

class WinnerItem extends StatelessWidget {

  UserInfo winner;
  Contest contest;


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
                image: CachedNetworkImageProvider(winner.image_url),
              ),
              shape: BoxShape.circle,
              color: Colors.red),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              winner.first_name + " " + winner.last_name,
              style: TextStyle(
                  color: appPrimaryColor, fontWeight: FontWeight.bold),
            ),
            Text(contest.name),
          ],
        ),
        subtitle: Text(timestampToDateFormat(contest.end_timestamp, "dd MMM, yyyy")),
      ),
    );
  }

  WinnerItem({
    required this.winner,
    required this.contest,
  });
}
