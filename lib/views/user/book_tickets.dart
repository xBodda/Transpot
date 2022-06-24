import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpot/components/drawer.dart';
import 'package:transpot/services/auth_model.dart';
import 'package:transpot/services/user_model.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/utils/keyboard.dart';
import 'package:transpot/utils/size_config.dart';
import 'package:transpot/views/user/checkout.dart';
import 'package:intl/intl.dart';
import 'package:transpot/views/user/payment.dart';

class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}

class BookTickets extends StatefulWidget {

  static String routeName = "/book_tickets";

  const BookTickets({Key? key}) : super(key: key);

  @override
  _BookTicketsState createState() => _BookTicketsState();
}

class _BookTicketsState extends State<BookTickets> {
  final _formKey = GlobalKey<FormState>();

  String formatter = '';

  String busName = '';
  int busSeats = 0;

  int _selectedTickets = 1;

  late User user;
  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    user = context.read<AuthModel>().CurrentUser()!;
    final UserModel u = UserModel(uid: user.uid);

    FirebaseFirestore.instance
        .collection('buses')
        .doc(args.message)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        busName = documentSnapshot['name'];
        busSeats = documentSnapshot['seats'];
        setState(() {
          busSeats = busSeats;
        });
      }
    });

    final now = DateTime.now();
    formatter = DateFormat('EEE, d/M/y').format(now);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Book Tickets",
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
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getSuitableScreenWidth(20),
                    vertical: getSuitableScreenHeight(30),
                  ),
                  child: Column(
                    children: [
                      Card(
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
                                  busName,
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
                                              "Seats Available: $busSeats"
                                              ),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                      ),
                    ),
                    const Divider(
                      color: secondaryColor,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: getSuitableScreenHeight(20),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Tickets: ",
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: secondaryColorDark,
                              fontSize: SizeConfig.screenWidth * 0.046,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: secondaryColorDark,
                                width: 2.8,
                              ),
                            ),
                            child: DropdownButton<dynamic>(
                              value: _selectedTickets,
                              items: getDropdownItems(busSeats),
                              onChanged: (value) {
                                setState(() {
                                  _selectedTickets = value!;
                                });
                              },
                              dropdownColor: primaryLightColor,
                              style: const TextStyle(
                                color: secondaryColorDark,
                                fontFamily: 'Lato',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      onPressedIconWithText(u, args.message);
                    },
                    style: ElevatedButton.styleFrom(
                        side: const BorderSide(width: 2, color: primaryColor),
                        primary: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        elevation: 5),
                    icon: const Icon(
                      Icons.check,
                      color: primaryColor,
                    ),
                    label: const Text("Book Tickets",
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            color: primaryColor)),
                  ),
                )
              ],
            ),
          ),
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

  onPressedIconWithText(UserModel u, String busId) async {
    Future.delayed(const Duration(milliseconds: 400), () async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          // ignore: use_build_context_synchronously
          User? user = context.read<AuthModel>().CurrentUser();

          if (user != null) {
            // ignore: use_build_context_synchronously
            Keyboard.hideKeyboard(context);
            print("tickets $_selectedTickets");
            for(int i = 0; i < _selectedTickets;i++) {
              u.addToCart("$i", "Regular Ticket", 5, busId);
            }

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