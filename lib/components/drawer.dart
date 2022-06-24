import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpot/services/auth_model.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/views/driver/driver_find_ride.dart';
import 'package:transpot/views/driver/ongoing_rides.dart';
import 'package:transpot/views/home.dart';
import 'package:transpot/views/user/find_bus.dart';
import 'package:transpot/views/user/packages.dart';
import 'package:transpot/views/user/wallet.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  AppDrawerState createState() => AppDrawerState();
}

class AppDrawerState extends State<AppDrawer> {
  String user_type = "";
  User? userx = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    if (userx != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userx!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          user_type = documentSnapshot['type'];
          setState(() {
            user_type = user_type;
          });
        }
      });
    }

    setState(() {
      user_type = user_type;
    });
    return Drawer(
      child: user_type == "user" ? Column(
        children: [
          AppBar(
            title: const Text("Transpot"),
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.of(context).pushNamed(FindBus.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.card_membership),
            title: const Text("Packages"),
            onTap: () {
              Navigator.of(context).pushNamed(Packages.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.wallet),
            title: const Text("Wallet"),
            onTap: () {
              Navigator.of(context).pushNamed(Wallet.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Sign Out"),
            onTap: () async {
              await context.read<AuthModel>().signOut();
              Navigator.of(context).pushNamed(Home.routeName);
            },
          ),
        ],
      ) : Column(
              children: [
                AppBar(
                  title: const Text("Transpot"),
                  automaticallyImplyLeading: false,
                  backgroundColor: primaryColor,
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Home"),
                  onTap: () {
                    Navigator.of(context).pushNamed(DriverFindRide.routeName);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bus_alert_rounded),
                  title: const Text("Rides"),
                  onTap: () {
                    Navigator.of(context).pushNamed(OngoingRides.routeName);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text("Sign Out"),
                  onTap: () async {
                    await context.read<AuthModel>().signOut();
                    Navigator.of(context).pushNamed(Home.routeName);
                  },
                ),
              ],
            ),
    );
  }
}
