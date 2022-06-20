import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpot/components/drawer.dart';
import 'package:transpot/services/auth_model.dart';
import 'package:transpot/services/main_variables.dart';
import 'package:transpot/services/user_model.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/utils/keyboard.dart';
import 'package:transpot/utils/size_config.dart';
import 'package:transpot/views/user/payment.dart';

class Packages extends StatefulWidget {
  const Packages({Key? key}) : super(key: key);

  static String routeName = "/packages";

  @override
  _PackagesState createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _errors = [];
  late int package = 0;

  late User u;

  @override
  void initState() {
    u = Provider.of<AuthModel>(context, listen: false).CurrentUser()!;
    super.initState();
  }

  late User user;

  @override
  Widget build(BuildContext context) {
    user = context.read<AuthModel>().CurrentUser()!;
    final UserModel u = UserModel(uid: user.uid);
    return Consumer<MainVariables>(builder: (_, gv, __) {
    gv.getUserData(user);
    WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          package = gv.UserDetails['Package'];
        });
    });
    // print(gv.UserDetails['Package']);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Packages",
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
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: getSuitableScreenHeight(15),
              vertical: getSuitableScreenWidth(20),
            ),
            child: ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      packageCard('Free Package',0.0, package == 1 ? 'Owned' : 'Free', u, 1, package),
                      packageCard('Premium Package',150.0, package == 2 ? 'Owned' : 'Subscribe',u ,2, package),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
    });
  }

  Card packageCard(String packageName, double price, String buttonName, UserModel u,int packageId, int currentPackage) {
    return Card(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: primaryColor,),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getSuitableScreenWidth(20),
            vertical: getSuitableScreenHeight(10),
          ),
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(packageName, style: const TextStyle(fontSize: 20, fontFamily: 'Lato', fontWeight: FontWeight.bold, color: secondaryColorDark),),
                    Text(
                    "$price EGP",
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        color: secondaryColorDark),
                  )
                  ],
                ),
                const Divider(
                  color: secondaryColor,
                  thickness: 2,
                ),
                Row(
                  children: const [
                    Text("- Access to all Buses anytime", style: TextStyle(fontSize: 16, fontFamily: 'Lato', fontWeight: FontWeight.normal, color: secondaryColorDark),),
                  ],
                ),
                Row(
                  children: const [
                    Text(
                      "- Multiple options for payment",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.normal,
                          color: secondaryColorDark),
                    ),
                  ],
                ),
                SizedBox(
                  height: getSuitableScreenHeight(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                    onPressed: () => currentPackage == packageId ? {} : onPressedIconWithText(u),
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                    ),
                    child: Text(buttonName,style: const TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold)),
                  ),
                  ],
                )
                
              ]
            ),
          ),
        ),
      );
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

            u.addToCart('2', "Premium Package", 150);

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