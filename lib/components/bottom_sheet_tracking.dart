import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpot/services/map_service.dart';
import 'package:transpot/services/notifier_service.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/utils/size_config.dart';

class BottomSheetTrackingMenu extends StatelessWidget {
  String userName = '';
  String phoneNumber = '';
  String busName = '';
  int busSeats = 0;
  BottomSheetTrackingMenu(
      this.userName, this.phoneNumber, this.busName, this.busSeats,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      // ElevatedButton.icon(
                      //   onPressed: () async {},
                      //   style: ElevatedButton.styleFrom(
                      //     side: const BorderSide(width: 2, color: Colors.green),
                      //     primary: Colors.white,
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 40, vertical: 15),
                      //   ),
                      //   icon: const Icon(
                      //     Icons.online_prediction,
                      //     color: Colors.green,
                      //   ),
                      //   label: const Text("I am online now",
                      //       style: TextStyle(
                      //           fontFamily: 'Lato',
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.green)),
                      // ),
                      // const Divider(
                      //   color: secondaryColor,
                      //   thickness: 2,
                      // ),
                      SizedBox(height: getSuitableScreenHeight(20)),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.person,
                      //       color: primaryColor,
                      //       size: getSuitableScreenWidth(20),
                      //     ),
                      //     SizedBox(width: getSuitableScreenHeight(5)),
                      //     Text(
                      //       "Driver Name: ",
                      //       style: TextStyle(
                      //         color: secondaryColorDark,
                      //         fontSize: getSuitableScreenWidth(18),
                      //         fontFamily: 'Lato',
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //     Text(
                      //       "${userName}",
                      //       style: const TextStyle(fontFamily: 'Lato'),
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: getSuitableScreenHeight(20)),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.phone,
                      //       color: primaryColor,
                      //       size: getSuitableScreenWidth(20),
                      //     ),
                      //     SizedBox(width: getSuitableScreenHeight(5)),
                      //     Text(
                      //       "Driver Phone Number: ",
                      //       style: TextStyle(
                      //         color: secondaryColorDark,
                      //         fontSize: getSuitableScreenWidth(18),
                      //         fontFamily: 'Lato',
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //     Text(
                      //       "${phoneNumber}",
                      //       style: const TextStyle(fontFamily: 'Lato'),
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: getSuitableScreenHeight(20)),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.bus_alert,
                      //       color: primaryColor,
                      //       size: getSuitableScreenWidth(20),
                      //     ),
                      //     SizedBox(width: getSuitableScreenHeight(5)),
                      //     Text(
                      //       "Bus Name: ",
                      //       style: TextStyle(
                      //         color: secondaryColorDark,
                      //         fontSize: getSuitableScreenWidth(18),
                      //         fontFamily: 'Lato',
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //     Text(
                      //       "${busName}",
                      //       style: const TextStyle(fontFamily: 'Lato'),
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: getSuitableScreenHeight(20)),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.chair_alt,
                      //       color: primaryColor,
                      //       size: getSuitableScreenWidth(20),
                      //     ),
                      //     SizedBox(width: getSuitableScreenHeight(5)),
                      //     Text(
                      //       "Remaining Seats: ",
                      //       style: TextStyle(
                      //         color: secondaryColorDark,
                      //         fontSize: getSuitableScreenWidth(18),
                      //         fontFamily: 'Lato',
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //     Text(
                      //       "${busSeats}",
                      //       style: const TextStyle(fontFamily: 'Lato'),
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ],
                      // ),
                    ],
                  )))
        ],
      ),
    );
  }
}