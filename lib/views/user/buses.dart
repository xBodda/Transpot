import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpot/components/drawer.dart';
import 'package:transpot/services/auth_model.dart';
import 'package:transpot/services/main_variables.dart';
import 'package:transpot/services/map_service.dart';
import 'package:transpot/services/user_model.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/utils/keyboard.dart';
import 'package:transpot/utils/size_config.dart';
import 'package:transpot/views/user/book_tickets.dart';
import 'package:transpot/views/user/find_bus.dart';
import 'package:intl/intl.dart';
import 'package:transpot/views/user/payment.dart';
import 'package:transpot/views/user/track_bus.dart';

class Bus extends StatefulWidget {
  const Bus({Key? key}) : super(key: key);

  static String routeName = "/buses";

  @override
  _BusState createState() => _BusState();
}

class _BusState extends State<Bus> {
  final _formKey = GlobalKey<FormState>();
  late Future allBuses;
  late User u;

  String formatter = '';

  final int _selectedTickets = 1;

  late int package = 0;

  @override
  void initState() {
    u = Provider.of<AuthModel>(context, listen: false).CurrentUser()!;
    allBuses = Provider.of<MainVariables>(context, listen: false).getAllBuses();
    print(allBuses);
    super.initState();
  }

  late User user;
  @override
  Widget build(BuildContext context) {
    late int total_cost = 0;
    final now = DateTime.now();
    formatter = DateFormat('EEE, d/M/y').format(now);
    user = context.read<AuthModel>().CurrentUser()!;
    final UserModel u = UserModel(uid: user.uid);
    return Consumer<MainVariables>(builder: (_, gv, __) {
      gv.getUserData(user);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          package = gv.UserDetails['Package'];
        });
      });
      // gv.getAllBuses();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Available Buses",
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
          child:
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: gv.BusDetails.length,
              itemBuilder: (context, index) => busCard(gv,gv.BusDetails[index]['name'],gv.BusDetails[index]['seats'],u,gv.BusDetails[index]['id'],
                    gv.BusDetails[index]['lat'],
                    gv.BusDetails[index]['lng'])
          ),
        ),
      ),
    );
    });
  }

  ElevatedButton busButton(String time) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        side: const BorderSide(width: 2, color: primaryColor),
        primary: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        fixedSize: const Size(double.maxFinite, 50)
      ),
      icon: const Icon(Icons.bus_alert_outlined, color: primaryColor),
      label: Text(
        time,
        style: const TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
            color: primaryColor),
      ),
    );
  }

  Card busCard(MainVariables mv,String name, int seats, UserModel u, String busId, double lat, double lng) {
    String current_status = "";
    return Card(
      color: primaryColor,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundColor: primaryColor,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1562620669-98104534c6cd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80'),
                  child: Text(
                    "",
                  ),
                ),
                title: Text(
                  name,
                  style: const TextStyle(fontSize: 20),
                ),
                subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0),
                          child: Text(
                              "$formatter, 10:00 AM"
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0),
                          child: Text(
                              "Seats Available: $seats"
                              ),
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    package == 2 ?
                    TextButton(
                          child: const Text(
                            "Track Bus",
                            style: TextStyle(
                                color: primaryLightColor, fontSize: 14),
                          ),
                          onPressed: () async {
                            Navigator.pushNamed(
                              context,
                              TrackBus.routeName,
                              arguments: TrackBusScreenArguments(
                                lat,
                                lng,
                                busId
                              )
                            );
                          },
                        ) : const Text(""),
                    ElevatedButton.icon(
                      onPressed: () async {
                        current_status = await mv.getBusStatus(busId);
                        // ignore: use_build_context_synchronously

                        current_status != "offline" ?
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(
                        context,
                        BookTickets.routeName,
                        arguments: ScreenArguments(
                          'Bus ID',
                          busId,
                        ),
                      // ignore: use_build_context_synchronously
                      ) : ScaffoldMessenger.of(context).showSnackBar(
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
                        side: const BorderSide(
                            width: 2, color: primaryColor),
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
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }

  List<DropdownMenuItem> getDropdownItems(int ticketNum) {
    List<DropdownMenuItem<dynamic>> dropdownItems = [];
    for (int i = 1; i <= ticketNum; i++) {
      var newItem = DropdownMenuItem(
        value: i,
        child: Text('$i'),
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  onPressedIconWithText(UserModel u) async {
    Future.delayed(const Duration(milliseconds: 400), () async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          // ignore: use_build_context_synchronously
          User? user = context.read<AuthModel>().CurrentUser();

          if (user != null) {
            // ignore: use_build_context_synchronously
            Keyboard.hideKeyboard(context);
            
            u.addToCart('$_selectedTickets', "Regular Ticket", 5, '$_selectedTickets');

            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Payment()),
              (Route<dynamic> route) => false,
            );
          } else {
            print("Error Signing Up");
          }
        } catch (e) {
          print(e);
        }
      } else {
        print("Error Signing Up");
      }
    });
  }
}
