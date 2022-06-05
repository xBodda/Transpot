import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transpot/components/drawer.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/utils/size_config.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  static String routeName = "/wallet";

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Wallet",
            style: TextStyle(
              color: secondaryColor,
              fontSize: 20,
              fontFamily: 'Lato',
            ),
          ),
          backgroundColor: secondaryColorDark,
        ),
        drawer: const AppDrawer(),
        body: SizedBox(
          width: double.infinity,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getSuitableScreenWidth(20),
                  vertical: getSuitableScreenHeight(30),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text("My Wallet", style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    const Divider(
                      color: secondaryColor,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: getSuitableScreenHeight(20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Balance", style: TextStyle(fontSize: 20)),
                        Text("145.00 EGP", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton.icon(
                  onPressed: () async {},
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 2, color: primaryColor),
                    primary: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    elevation: 5
                  ),
                  icon: const Icon(
                    Icons.attach_money_rounded,
                    color: primaryColor,
                  ),
                  label: const Text("Add Money",
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          color: primaryColor)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}