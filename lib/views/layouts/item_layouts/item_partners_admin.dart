import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../helpers/constants.dart';
import '../../../helpers/styles.dart';
import '../../../models/partner.dart';
import '../../screens/admin/screen_admin_partners_plan.dart';

class ItemPartnersAdmin extends StatefulWidget {
  Partner partner;


  @override
  State<ItemPartnersAdmin> createState() => _ItemPartnersAdminState();

  ItemPartnersAdmin({
    required this.partner,
  });
}

class _ItemPartnersAdminState extends State<ItemPartnersAdmin> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: (){Get.to(ScreenAdminPartnersPlan());},
        leading: Container(
          height: Get.height * 0.07,
          width: Get.height * 0.07,
          decoration: BoxDecoration(
            color: Colors.grey,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(widget.partner.image_url ?? userPlaceHolder),
            ),
            shape: BoxShape.circle,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.all(10),
        tileColor: Colors.white,
        title: Text(
          widget.partner.name,
          style: TextStyle(color: appPrimaryColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(widget.partner.email),
      ),
    );
  }
}
