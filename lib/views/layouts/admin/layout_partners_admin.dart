import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../helpers/constants.dart';
import '../../../models/partner.dart' as model;
import '../item_layouts/item_partners_admin.dart';

class LayoutPartnersAdmin extends StatefulWidget {
  LayoutPartnersAdmin({Key? key}) : super(key: key);

  @override
  _LayoutPartnersAdminState createState() => _LayoutPartnersAdminState();
}

class _LayoutPartnersAdminState extends State<LayoutPartnersAdmin> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: partnersRef.snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        var partner=snapshot.data!.docs.map((e) =>
            model.Partner.fromMap(e.data() as Map<String, dynamic>))
            .toList();

        return ListView.builder(
            itemCount: partner.length,
            itemBuilder: (_,index){
              var partners=partner[index];
              return ItemPartnersAdmin(partner: partners,

              );
            });

      },
    );





  }
}