import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpot/services/auth_model.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/views/home.dart';
import 'package:transpot/views/user/find_bus.dart';
import 'package:transpot/views/user/packages.dart';
import 'package:transpot/views/user/wallet.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
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
      ),
    );
  }
}
