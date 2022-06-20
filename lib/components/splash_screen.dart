import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpot/services/auth_model.dart';
import 'package:transpot/services/main_variables.dart';
import 'package:transpot/services/map_service.dart';
import 'package:transpot/utils/size_config.dart';
import 'package:transpot/views/home.dart';
import 'package:transpot/views/signup.dart';
import 'package:transpot/views/user/find_bus.dart';

import '../main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isLoggedIn = false;
  MainVariables mv = MainVariables();
  MapService ms = MapService();
  @override
  void initState() {
    User? user = context.read<AuthModel>().CurrentUser();
    if (user != null) {
      // Navigator.pushNamed(context, FindBus.routeName);
      isLoggedIn = true;
      mv.updateUserLocation(user, ms.Currentlat, ms.Currentlong);
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (isLoggedIn) {
    //     Navigator.pushNamed(context, FindBus.routeName);
    //   }
    // });
    SizeConfig().init(context);
    return EasySplashScreen(
      logo: Image.asset('assets/logo.png'),
      title: const Text(
        "Transpot",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      showLoader: true,
      loadingText: const Text("Loading..."),
      navigator: isLoggedIn ? const FindBus() : const Home(),
      durationInSeconds: 5,
    );
  }
}
