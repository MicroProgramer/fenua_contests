import 'package:fenua_contests/views/layouts/item_layouts/item_user.dart';
import 'package:flutter/material.dart';
class UsersLayoutAdmin extends StatelessWidget {
  const UsersLayoutAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 20,
        itemBuilder: (_, index){
          return UserItem();
        });
  }
}
