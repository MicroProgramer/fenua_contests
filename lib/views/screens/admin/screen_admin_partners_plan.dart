import 'package:flutter/material.dart';

import '../../../widgets/custom_tab_bar_view.dart';
import '../../layouts/admin/layout_admin_partner_photo_plan.dart';
import '../../layouts/admin/layout_admin_partner_video_plan.dart';

class ScreenAdminPartnersPlan extends StatefulWidget {
  ScreenAdminPartnersPlan({Key? key}) : super(key: key);

  @override
  _ScreenAdminPartnersPlanState createState() =>
      _ScreenAdminPartnersPlanState();
}

class _ScreenAdminPartnersPlanState extends State<ScreenAdminPartnersPlan> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "Video Ads Plan"),
              Tab(text: "Photo Ads Plan"),
            ],
          ),
          title: Text('Subscribed Plan'),
        ),
        body: TabBarView(
          children: [
            LayoutAdminPartnerVideoPlan(),
            LayoutAdminPartnerPhotoPlan()
          ],
        ),
      ),
    );
  }
}