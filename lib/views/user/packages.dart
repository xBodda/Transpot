import 'package:flutter/material.dart';
import 'package:transpot/components/drawer.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/utils/size_config.dart';
import 'package:transpot/views/user/payment.dart';

class Packages extends StatefulWidget {
  const Packages({Key? key}) : super(key: key);

  static String routeName = "/packages";

  @override
  _PackagesState createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {

  @override
  Widget build(Object context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Packages",
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
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: getSuitableScreenHeight(15),
              vertical: getSuitableScreenWidth(20),
            ),
            child: ListView(
              children: [
                Column(
                  children: [
                    packageCard('Free Package',0.0,'Free'),
                    packageCard('Premium Package',150.0, 'Subscribe'),
                  ],
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  Card packageCard(String packageName, double price, String buttonName) {
    return Card(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: primaryColor,),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getSuitableScreenWidth(20),
            vertical: getSuitableScreenHeight(10),
          ),
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(packageName, style: const TextStyle(fontSize: 20, fontFamily: 'Lato', fontWeight: FontWeight.bold, color: secondaryColorDark),),
                    Text(
                    "$price EGP",
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        color: secondaryColorDark),
                  )
                  ],
                ),
                const Divider(
                  color: secondaryColor,
                  thickness: 2,
                ),
                Row(
                  children: const [
                    Text("- Access to all Buses anytime", style: TextStyle(fontSize: 16, fontFamily: 'Lato', fontWeight: FontWeight.normal, color: secondaryColorDark),),
                  ],
                ),
                Row(
                  children: const [
                    Text(
                      "- Multiple options for payment",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.normal,
                          color: secondaryColorDark),
                    ),
                  ],
                ),
                SizedBox(
                  height: getSuitableScreenHeight(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, Payment.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                    ),
                    child: Text(buttonName,style: const TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold)),
                  ),
                  ],
                )
                
              ]
            ),
          ),
        ),
      );
  }

}