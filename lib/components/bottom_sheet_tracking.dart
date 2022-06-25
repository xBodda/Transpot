import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpot/services/main_variables.dart';
import 'package:transpot/services/map_service.dart';
import 'package:transpot/services/notifier_service.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/utils/size_config.dart';
import 'package:transpot/views/user/book_tickets.dart';

class BottomSheetTrackingMenu extends StatelessWidget {
  String userName = '';
  String phoneNumber = '';
  String busName = '';
  int busSeats = 0;
  String busId = '';

  String current_status = "";
  BottomSheetTrackingMenu(
      this.userName, this.phoneNumber, this.busName, this.busSeats, this.busId,
      {Key? key})
      : super(key: key);

  MainVariables mv = MainVariables();

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
                      ElevatedButton.icon(
                        onPressed: () async {
                          current_status = await mv.getBusStatus(busId);
                          // ignore: use_build_context_synchronously

                          current_status != "offline"
                              ?
                              // ignore: use_build_context_synchronously
                              Navigator.pushNamed(
                                  context,
                                  BookTickets.routeName,
                                  arguments: ScreenArguments(
                                    'Bus ID',
                                    busId,
                                  ),
                                  // ignore: use_build_context_synchronously
                                )
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("This Bus Is Out Of Service"),
                                    duration: Duration(milliseconds: 3000),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: secondaryColorDark,
                                  ),
                                );
                          ;
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(width: 2, color: primaryColor),
                          primary: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        icon: const Icon(
                          Icons.tab,
                          color: primaryColor,
                        ),
                        label: const Text("Book Tickets",
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: primaryColor)),
                      ),
                      const Divider(
                        color: secondaryColor,
                        thickness: 2,
                      ),
                      SizedBox(height: getSuitableScreenHeight(20)),
                      SizedBox(height: getSuitableScreenHeight(20)),
                      SizedBox(height: getSuitableScreenHeight(20)),
                      SizedBox(height: getSuitableScreenHeight(20)),
                    ],
                  )))
        ],
      ),
    );
  }
}