import 'package:fenua_contests/helpers/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appSecondaryColor,
      appBar: AppBar(
        backgroundColor: appSecondaryColor,
        title: Text("Wallet"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Image.asset(
                "assets/images/wallet.png",
                height: Get.height * 0.2,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wallet_giftcard,
                    size: 30,
                    color: Colors.white,
                  ),
                  Hero(
                    tag: "wallet",
                    child: Text(
                      "100",
                      style: TextStyle(
                          fontSize: Get.height * 0.1,
                          color: Colors.white,
                          fontFamily: "JustBubble"),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  "1 ticket = 1 more chance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Divider(
                height: 50,
                thickness: 5,
                indent: 20,
                endIndent: 20,
              ),
              Text(
                "Win more tickets",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .merge(TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
