import 'package:cached_network_image/cached_network_image.dart';
import 'package:fenua_contests/controllers/controller_home_screen.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/models/user_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserItem extends StatelessWidget {
  UserInfo user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        // onTap: () {
          // ShapeBorder shape = RoundedRectangleBorder(
          //     borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)));
          //
          // showModalBottomSheet<dynamic>(
          //     isScrollControlled: true,
          //     context: context,
          //     shape: shape,
          //     enableDrag: true,
          //     backgroundColor: appPrimaryColor,
          //     builder: (context) {
          //       return DraggableScrollableSheet(
          //         maxChildSize: 0.8,
          //         expand: false,
          //         builder: (BuildContext context,
          //             ScrollController scrollController) {
          //           return Container(
          //             child: Column(
          //               children: [
          //                 AppBar(
          //                   shape: shape,
          //                   centerTitle: true,
          //                   actions: [
          //                     IconButton(
          //                         tooltip: "Close",
          //                         onPressed: () {
          //                           Get.back();
          //                         },
          //                         icon: Icon(Icons.close))
          //                   ],
          //                   title: Container(
          //                       child: /*Icon(
          //                                     Icons.horizontal_rule_rounded,
          //                                     color: Colors.white54,
          //                                     size: 100,
          //                                   ),*/
          //                           Text(
          //                     "User Details",
          //                     style: heading3_style,
          //                   )),
          //                   // backgroundColor: appPrimaryColor,
          //                   elevation: 2,
          //                   automaticallyImplyLeading:
          //                       false, // remove back button in appbar.
          //                 ),
          //                 SingleChildScrollView(
          //                   child: Column(
          //                     children: [
          //                       Container(
          //                         margin: EdgeInsets.all(10),
          //                         height: Get.height * 0.1,
          //                         width: Get.height * 0.1,
          //                         decoration: BoxDecoration(
          //                           shape: BoxShape.circle,
          //                           image: DecorationImage(
          //                             fit: BoxFit.fill,
          //                             image: CachedNetworkImageProvider(
          //                                 user.image_url),
          //                           ),
          //                         ),
          //                       ),
          //                       Text(
          //                         user.first_name + " " + user.last_name,
          //                         style: normal_h2Style_bold,
          //                       ),
          //                       Padding(
          //                         padding: const EdgeInsets.only(top: 18.0),
          //                         child: Row(
          //                           mainAxisSize: MainAxisSize.max,
          //                           mainAxisAlignment: MainAxisAlignment.center,
          //                           children: [
          //                             Expanded(
          //                               child: Text(
          //                                 "Date of birth:",
          //                                 textAlign: TextAlign.center,
          //                                 style: normal_h2Style_bold,
          //                               ),
          //                             ),
          //                             Expanded(
          //                               child: Text(
          //                                 user.age,
          //                                 textAlign: TextAlign.center,
          //                                 style: normal_h2Style_bold,
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                       Padding(
          //                         padding: const EdgeInsets.only(top: 18.0),
          //                         child: Row(
          //                           mainAxisSize: MainAxisSize.max,
          //                           mainAxisAlignment: MainAxisAlignment.center,
          //                           children: [
          //                             Expanded(
          //                               child: Text(
          //                                 "Tickets:",
          //                                 textAlign: TextAlign.center,
          //                                 style: normal_h2Style_bold,
          //                               ),
          //                             ),
          //                             Expanded(
          //                               child: Text(
          //                                 Get.find<HomeScreenController>(),
          //                                 textAlign: TextAlign.center,
          //                                 style: normal_h2Style_bold,
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           );
          //         },
          //       );
          //     });
        // },
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
            shape: BoxShape.circle,
          ),
        ),
        title: Text(
          user.first_name + " " + user.last_name,
          style: TextStyle(color: appPrimaryColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(user.email),
        // trailing: Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     IconButton(onPressed: (){}, icon: Icon(Icons.block)),
        //   ],
        // ),
      ),
    );
  }

  UserItem({
    required this.user,
  });
}
