import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/views/layouts/item_layouts/item_contest_admin.dart';
import 'package:flutter/material.dart';

import '../item_layouts/item_contest.dart';

class ContestsAdminLayout extends StatelessWidget {
  const ContestsAdminLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appSecondaryColor,
      floatingActionButton: FloatingActionButton(onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ContestItemAdmin(),
            );
          })
    );
  }
}
