import 'package:fenua_contests/views/layouts/item_layouts/item_test.dart';
import 'package:fenua_contests/views/layouts/item_layouts/item_winner.dart';
import 'package:flutter/material.dart';
class WinnersLayout extends StatelessWidget {
  const WinnersLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return WinnerItem();
          }),
    );
  }
}
