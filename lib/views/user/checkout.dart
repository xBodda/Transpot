import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpot/components/drawer.dart';
import 'package:transpot/services/auth_model.dart';
import 'package:transpot/services/user_model.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/utils/keyboard.dart';
import 'package:transpot/utils/size_config.dart';
import 'package:transpot/views/user/payment.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  static String routeName = "/checkout";

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _errors = [];

  late int _amount;

  late User user;
  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    user = context.read<AuthModel>().CurrentUser()!;
    final UserModel u = UserModel(uid: user.uid);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
              "Add Money",
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
                Column(
                  children: [
                    Card(
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
                            vertical: getSuitableScreenHeight(40),
                          ),
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Wallet Topup",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.normal,
                                        color: secondaryColorDark),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: getSuitableScreenHeight(10),
                              ),
                            ]),
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
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: 
                                (value) => _amount = int.parse(value!),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  addError(error: "Please enter an amount");
                                  return "";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    fontFamily: 'Lato',
                                    color: secondaryColorDark.withOpacity(0.5),
                                    fontWeight: FontWeight.bold),
                                labelText: "Amount",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: getSuitableScreenWidth(20),
                                    horizontal: getSuitableScreenWidth(30)),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(
                                      right: getSuitableScreenWidth(25)),
                                  child: Icon(
                                    Icons.money_off,
                                    size: getSuitableScreenWidth(28),
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: getSuitableScreenHeight(20),
                            ),
                            const Divider(
                              color: secondaryColor,
                              thickness: 1,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 25,
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  onPressedIconWithText(u);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 70, vertical: 15),
                                ),
                                child: const Text("Go To Checkout",
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  void addError({required String error}) {
    if (!_errors.contains(error)) {
      setState(() {
        _errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (_errors.contains(error)) {
      setState(() {
        _errors.remove(error);
      });
    }
  }

  void onPressedIconWithText(UserModel u) async {
    Future.delayed(const Duration(milliseconds: 400), () async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          // ignore: use_build_context_synchronously
          User? user = context.read<AuthModel>().CurrentUser();

          if (user != null) {
            // ignore: use_build_context_synchronously
            Keyboard.hideKeyboard(context);

            u.addToCart('1', "Wallet Topup", _amount, '1'); 

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