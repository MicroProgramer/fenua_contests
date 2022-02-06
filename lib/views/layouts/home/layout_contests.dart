import 'package:flutter/material.dart';

import '../item_layouts/item_contest.dart';

class ContestsLayout extends StatelessWidget {
  const ContestsLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ContestItem(),
          );
        });
  }
}
