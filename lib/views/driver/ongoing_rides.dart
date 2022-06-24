import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpot/components/drawer.dart';
import 'package:transpot/services/auth_model.dart';
import 'package:transpot/services/main_variables.dart';
import 'package:transpot/services/user_model.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/utils/size_config.dart';
import 'package:transpot/views/home.dart';
import 'package:transpot/views/user/checkout.dart';

class OngoingRides extends StatefulWidget {
  const OngoingRides({Key? key}) : super(key: key);

  static String routeName = "/ongoing_rides";

  @override
  _OngoingRidesState createState() => _OngoingRidesState();
}

class _OngoingRidesState extends State<OngoingRides> {

  late Future allRides;
  late User u;


  @override
  void initState() {
    u = Provider.of<AuthModel>(context, listen: false).CurrentUser()!;
    allRides = Provider.of<MainVariables>(context, listen: false).getAllRides(u);
    super.initState();
  }

  User? userx = FirebaseAuth.instance.currentUser;
  late User user;

  @override
  Widget build(BuildContext context) {
    user = context.read<AuthModel>().CurrentUser()!;
    final UserModel u = UserModel(uid: user.uid);
    return Consumer<MainVariables>(builder: (_, gv, __) {
      gv.getUserData(user);
      // gv.getAllBuses();
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Ongoing Rides",
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
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: gv.RidesDetails.length,
                itemBuilder: (context, index) => rideCard(gv,gv.RidesDetails[index]['user_id'], index, gv.RidesDetails[index]['ride_id'])),
          ),
        ),
      );
    });
  }

  Card rideCard(MainVariables mv, String userName, int index, String rideId) {
    return Card(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: primaryColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getSuitableScreenWidth(20),
            vertical: getSuitableScreenHeight(15),
          ),
          child: SizedBox(
            width: double.maxFinite,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ticket ${index+1}",
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        color: secondaryColorDark),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      mv.dismissRide(rideId);
                      Navigator.of(context).pushNamed(OngoingRides.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: const Text("Dismiss",
                        style: TextStyle(
                            fontFamily: 'Lato', fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              SizedBox(
                height: getSuitableScreenHeight(10),
              ),
            ]),
          ),
        ),
      );
  }
}
