import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpot/services/auth_model.dart';
import 'package:transpot/services/main_variables.dart';
import 'package:transpot/services/user_model.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/utils/size_config.dart';

// ignore: must_be_immutable
class BottomSheetMapMenu extends StatefulWidget {
  String userName = '';
  String phoneNumber = '';
  String busName = '';
  int busSeats = 0;
  BottomSheetMapMenu({Key? key, required this.userName, required this.phoneNumber, required this.busName, required this.busSeats}) : super(key: key);
  
  @override
  BottomSheetMapMenuState createState() => BottomSheetMapMenuState();
}

class BottomSheetMapMenuState extends State<BottomSheetMapMenu> {
  late User u;

  @override
  void initState() {
    u = Provider.of<AuthModel>(context, listen: false).CurrentUser()!;
    super.initState();
  }
  
  String statusText = "I am online now";
  Color statusColor = Colors.green;
  Widget statusIcon = const Icon(Icons.online_prediction,color: Colors.green,);

  late User user;

  @override
  Widget build(BuildContext context) {
    user = context.read<AuthModel>().CurrentUser()!;
    final UserModel u = UserModel(uid: user.uid); 
    return Consumer<MainVariables>(builder: (_, gv, __) {
    gv.getUserData(user);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          changeStatus(gv, user);
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(width: 2, color: statusColor),
                          primary: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        icon: statusIcon,
                        label: Text(statusText,
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: statusColor)),
                      ),
                      const Divider(
                        color: secondaryColor,
                        thickness: 2,
                      ),
                      SizedBox(height: getSuitableScreenHeight(20)),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: primaryColor,
                            size: getSuitableScreenWidth(20),
                          ),
                          SizedBox(width: getSuitableScreenHeight(5)),
                          Text(
                            "Driver Name: ",
                            style: TextStyle(
                              color: secondaryColorDark,
                              fontSize: getSuitableScreenWidth(18),
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${widget.userName}",
                            style: const TextStyle(fontFamily: 'Lato'),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(height: getSuitableScreenHeight(20)),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: primaryColor,
                            size: getSuitableScreenWidth(20),
                          ),
                          SizedBox(width: getSuitableScreenHeight(5)),
                          Text(
                            "Driver Phone Number: ",
                            style: TextStyle(
                              color: secondaryColorDark,
                              fontSize: getSuitableScreenWidth(18),
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${widget.phoneNumber}",
                            style: const TextStyle(fontFamily: 'Lato'),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(height: getSuitableScreenHeight(20)),
                      Row(
                        children: [
                          Icon(
                            Icons.bus_alert,
                            color: primaryColor,
                            size: getSuitableScreenWidth(20),
                          ),
                          SizedBox(width: getSuitableScreenHeight(5)),
                          Text(
                            "Bus Name: ",
                            style: TextStyle(
                              color: secondaryColorDark,
                              fontSize: getSuitableScreenWidth(18),
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${widget.busName}",
                            style: const TextStyle(fontFamily: 'Lato'),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(height: getSuitableScreenHeight(20)),
                      Row(
                        children: [
                          Icon(
                            Icons.chair_alt,
                            color: primaryColor,
                            size: getSuitableScreenWidth(20),
                          ),
                          SizedBox(width: getSuitableScreenHeight(5)),
                          Text(
                            "Remaining Seats: ",
                            style: TextStyle(
                              color: secondaryColorDark,
                              fontSize: getSuitableScreenWidth(18),
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${widget.busSeats}",
                            style: const TextStyle(fontFamily: 'Lato'),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ))
          )
        ],
      ),
    );
    });
  }

  void changeStatus(MainVariables mv, User u) {
    if(statusText == "I am online now") {
      mv.updateDriverStatus(u,"offline");
      setState(() async {
        statusText = "I am offline now";
        statusColor = Colors.red;
        statusIcon = const Icon(
          Icons.online_prediction,
          color: Colors.red,
        );
      });
    } else {
      mv.updateDriverStatus(u, "online");
      setState(() async {
        statusText = "I am online now";
        statusColor = Colors.green;
        statusIcon = const Icon(
          Icons.online_prediction,
          color: Colors.green,
        );
      });
    }
    
  }
}
