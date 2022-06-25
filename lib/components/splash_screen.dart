import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpot/services/auth_model.dart';
import 'package:transpot/services/main_variables.dart';
import 'package:transpot/services/map_service.dart';
import 'package:transpot/utils/size_config.dart';
import 'package:transpot/views/driver/driver_find_ride.dart';
import 'package:transpot/views/home.dart';
import 'package:transpot/views/user/find_bus.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isLoggedIn = false;
  bool isTimer = false;
  MainVariables mv = MainVariables();
  MapService ms = MapService();
  late User user;
  String user_type = "";
  @override
  void initState() {
    User? user = context.read<AuthModel>().CurrentUser();
    if (user != null) {
      isLoggedIn = true;
      if(!isTimer) {
        Timer.periodic(const Duration(seconds: 5), (timer) {
          ms.getUserLocation();
          mv.updateUserLocation(user, ms.Currentlat, ms.Currentlong);
        });
        isTimer = true;
      }
    }
    super.initState();
  }
  
  User? userx = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    if(userx != null){
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
      navigator: user_type == 'user' ? const FindBus() 
                : user_type == 'driver' ? const DriverFindRide() 
                : const Home(),
      durationInSeconds: 5,
    );
  }
}
