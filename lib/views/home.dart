import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpot/services/auth_model.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/utils/size_config.dart';
import 'package:transpot/views/driver/driver_signin.dart';
import 'package:transpot/views/signin.dart';
import 'package:transpot/views/signup.dart';
import 'package:transpot/views/user/find_bus.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static String routeName = "/home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/bg.jpg',
                      height: 350,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    color: const Color.fromRGBO(0, 0, 0, 0.2),
                    height: 350,
                    width: double.infinity,
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getSuitableScreenWidth(20),
                    vertical: getSuitableScreenHeight(30),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                        child: Text("Welcome to Transpot",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondaryColorDark)
                            )
                        ),
                        ElevatedButton(
                          onPressed: () async {Navigator.pushNamed(context, SignUp.routeName);},
                          style: ElevatedButton.styleFrom(
                            primary: primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                          ),
                          child: const Text("Create An Account",style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {Navigator.pushNamed(context, SignIn.routeName);},
                          style: ElevatedButton.styleFrom(
                            primary: secondaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                          ),
                          child: const Text("Have An Account ?",style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold)),
                        ),
                        TextButton(
                          child: const Text(
                            "Login As Driver",
                            style: TextStyle(color: secondaryColorDark, fontSize: 14),
                          ),
                          onPressed: () async {
                             Navigator.pushNamed(context, DriverSignIn.routeName);
                          },
                        ),
                    ],
                  ),
                ),
              ),
              ]
              ),
          )
        ),
      ),
    );
  }
}