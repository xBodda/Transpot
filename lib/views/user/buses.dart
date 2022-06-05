import 'package:flutter/material.dart';
import 'package:transpot/components/drawer.dart';
import 'package:transpot/utils/constants.dart';

class Bus extends StatefulWidget {
  const Bus({Key? key}) : super(key: key);

  static String routeName = "/buses";

  @override
  _BusState createState() => _BusState();
}

class _BusState extends State<Bus> {
  @override
  Widget build(BuildContext context) {
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
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // BusButton("Bus 1"),
                    busCard(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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

  Container BusButton(String time) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(time, textAlign: TextAlign.left ,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const Divider(
            color: secondaryColor,
            thickness: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                "Pick Up",
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                  color: secondaryColorDark,
                ),
              ),
              Text(
                "Drop Off",
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                  color: secondaryColorDark,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text(
                  "City Stars",
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.normal,
                    color: secondaryColorDark,
                  ),
                ),
                Text(
                  "City Center",
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.normal,
                    color: secondaryColorDark,
                  ),
                ),
              ],
            ),
            const Divider(
              color: secondaryColor,
              thickness: 2,
            ),
        ],
      )
    );
  }

  Card busCard() {
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
              title: const Text(
                "A56 Bus",
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.0),
                        child: Text(
                            "From: City Stars, Heliopolis, Egypt"
                            ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.0),
                        child: Text(
                            "To: City Center, New Cairo, Egypt"
                            ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.0),
                        child: Text(
                            "06/06/2020, 10:00 AM"
                            ),
                      )
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.of(context).pushNamed(Bus.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                          width: 2, color: primaryColor),
                      primary: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    icon: const Icon(
                      Icons.check,
                      color: primaryColor,
                    ),
                    label: const Text("Book Now",
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
}
