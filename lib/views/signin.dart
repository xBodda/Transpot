import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpot/services/auth_model.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/utils/keyboard.dart';
import 'package:transpot/utils/size_config.dart';
import 'package:transpot/views/signup.dart';
import 'package:transpot/views/user/find_bus.dart';

import '../utils/FormError.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  static String routeName = "/signin";

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  late String _email;
  late String _password;


  final List<String> _errors = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Sign In",
            style: TextStyle(
              color: secondaryColor,
              fontSize: 20,
              fontFamily: 'Lato',
            ),
          ),
          backgroundColor: secondaryColorDark,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getSuitableScreenWidth(20),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: getSuitableScreenWidth(40),
                  ),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: secondaryColorDark,
                      fontSize: getSuitableScreenWidth(25),
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: getSuitableScreenWidth(10)),
                  const Text(
                    "Sign in with your email and password \nor sign in with social media",
                    style: TextStyle(fontFamily: 'Lato'),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: getSuitableScreenWidth(60)),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (newValue) => _email = newValue!,
                          onChanged: (value) {
                            if (value.isEmpty ||
                                emailValidatorRegExp.hasMatch(value)) {
                              removeError(error: invalidEmailError);
                            } else if (value.isNotEmpty) {
                              removeError(error: emailNullError);
                            }
                            return;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(error: emailNullError);
                              return "";
                            } else if (value.isNotEmpty &&
                                !emailValidatorRegExp.hasMatch(value)) {
                              addError(error: invalidEmailError);
                              return "";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                                fontFamily: 'Lato',
                                color: secondaryColorDark.withOpacity(0.5),
                                fontWeight: FontWeight.bold),
                            labelText: "E-mail",
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: getSuitableScreenWidth(20),
                                horizontal: getSuitableScreenWidth(30)),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(
                                  right: getSuitableScreenWidth(25)),
                              child: Icon(
                                Icons.email_outlined,
                                size: getSuitableScreenWidth(28),
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: getSuitableScreenHeight(30)),
                        TextFormField(
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          obscureText: true,
                          onSaved: (newValue) => _password = newValue!,
                          onChanged: (value) {
                            if (value.length >= 8 || value.isEmpty) {
                              removeError(error: shortPassError);
                            } else if (value.isNotEmpty) {
                              removeError(error: passNullError);
                            }
                            return;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(error: passNullError);
                              return '';
                            } else if (value.length < 8 && value.isNotEmpty) {
                              addError(error: shortPassError);
                              return '';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                                fontFamily: 'Lato',
                                color: secondaryColorDark.withOpacity(0.5),
                                fontWeight: FontWeight.bold),
                            labelText: "Password",
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: getSuitableScreenWidth(20),
                                horizontal: getSuitableScreenWidth(30)),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(right: getSuitableScreenWidth(26)),
                              child: Icon(
                                Icons.lock_outline_rounded,
                                size: getSuitableScreenWidth(28),
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: getSuitableScreenHeight(20)),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext bc) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: Text("Done"),
                                  );
                                }),
                            child: const Text(
                              "Forgot Password ?",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: secondaryColorDark,
                                  fontSize: 14,
                                  fontFamily: 'Lato'),
                            ),
                          ),
                        ),
                        FormError(errors: _errors),
                        SizedBox(height: getSuitableScreenHeight(20)),
                        ElevatedButton(
                          onPressed: () => onPressedIconWithText(),
                          style: ElevatedButton.styleFrom(
                            primary: primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          child: const Text("Sign In",
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: getSuitableScreenHeight(20)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem> getDropdownItems() {
    List<DropdownMenuItem<dynamic>> dropdownItems = [];
    for (int i = 0; i < governorates.length; i++) {
      String gov = governorates[i];
      var newItem = DropdownMenuItem(
        child: Text(gov),
        value: gov,
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
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

  void onPressedIconWithText() async {
    Future.delayed(const Duration(milliseconds: 600), () async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          await context.read<AuthModel>().signOut();
          await context.read<AuthModel>().signIn(email: _email, password: _password);

          User? user = context.read<AuthModel>().CurrentUser();

          if (user != null) {
            Keyboard.hideKeyboard(context);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Welcome to Transpot"),
                duration: Duration(milliseconds: 3000),
                behavior: SnackBarBehavior.floating,
                backgroundColor: secondaryColorDark,
              ),
            );

            await Future.delayed(const Duration(seconds: 2), () {});

            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const FindBus()), (Route<dynamic> route) => false,);
            print("----------${user.email}----------");
          } else {

          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Error Signing In"),
              duration: Duration(milliseconds: 3000),
              behavior: SnackBarBehavior.floating,
              backgroundColor: secondaryColorDark,
            ),
          );
          print(e);
        }
      }
    });
  }
}
