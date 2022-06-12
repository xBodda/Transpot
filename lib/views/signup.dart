import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpot/services/auth_model.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/utils/keyboard.dart';
import 'package:transpot/utils/size_config.dart';
import 'package:transpot/views/home.dart';
import 'package:transpot/views/user/find_bus.dart';

import '../utils/FormError.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  static String routeName = "/signup";

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  late String _email;
  late String _password;
  late String _confirmPassword;
  late String _fullName;
  late String _phoneNumber;
  late String _address;

  String _selectedGov = 'Cairo';

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
            "Sign Up",
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
                      "Register An Account",
                      style: TextStyle(
                        color: secondaryColorDark,
                        fontSize: getSuitableScreenWidth(25),
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: getSuitableScreenWidth(10)),
                    const Text(
                      "Fill all details in order to create your account",
                      style: TextStyle(fontFamily: 'Lato'),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: getSuitableScreenWidth(45)),
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
                              } else if (value.isNotEmpty && !emailValidatorRegExp.hasMatch(value)) {
                                addError(error: invalidEmailError);
                                return "";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  fontFamily: 'Lato',
                                  color: secondaryColorDark.withOpacity(0.5),
                                  fontWeight: FontWeight.bold
                                  ),
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
                              _password = value;
                              if (value.length >= 8 || value.isEmpty) {
                                removeError(error: shortPassError);
                              } else if (passwordValidatorRegExp
                                  .hasMatch(value)) {
                                removeError(error: invalidPassError);
                              } else if (value.isNotEmpty) {
                                removeError(error: passNullError);
                              } else if (_password == _confirmPassword) {
                                removeError(error: matchPassError);
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                addError(error: passNullError);
                                return "";
                              } else if (!passwordValidatorRegExp
                                  .hasMatch(value)) {
                                addError(error: invalidPassError);
                                return "";
                              } else if (value.length < 8 && value.isNotEmpty) {
                                addError(error: shortPassError);
                                return "";
                              } else if (_password != value) {
                                addError(error: matchPassError);
                                return "";
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
                                padding: EdgeInsets.only(
                                    right: getSuitableScreenWidth(26)),
                                child: Icon(
                                  Icons.lock_outline_rounded,
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
                            onSaved: (newValue) => _confirmPassword = newValue!,
                            onChanged: (value) {
                              _confirmPassword = value;

                              if (_password == _confirmPassword) {
                                removeError(error: matchPassError);
                              }
                            },
                            validator: (value) {
                              if (_password != value) {
                                addError(error: matchPassError);
                                return "";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  fontFamily: 'Lato',
                                  color: secondaryColorDark.withOpacity(0.5),
                                  fontWeight: FontWeight.bold),
                              labelText: "Confirm Password",
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: getSuitableScreenWidth(20),
                                  horizontal: getSuitableScreenWidth(30)),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(
                                    right: getSuitableScreenWidth(26)),
                                child: Icon(
                                  Icons.lock_outline_rounded,
                                  size: getSuitableScreenWidth(28),
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: getSuitableScreenHeight(30)),
                          TextFormField(
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            onSaved: (newValue) => _fullName = newValue!,
                            onChanged: (value) {
                              if (value.isEmpty ||
                                  nameValidatorRegExp.hasMatch(value)) {
                                removeError(error: invalidNameError);
                              } else if (value.isNotEmpty) {
                                removeError(error: nameNullError);
                              }
                              return;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                addError(error: nameNullError);
                                return "";
                              } else if (!nameValidatorRegExp.hasMatch(value)) {
                                addError(error: invalidNameError);
                                return "";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  fontFamily: 'Lato',
                                  color: secondaryColorDark.withOpacity(0.5),
                                  fontWeight: FontWeight.bold),
                              labelText: "Full Name",
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: getSuitableScreenWidth(20),
                                  horizontal: getSuitableScreenWidth(30)),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(
                                    right: getSuitableScreenWidth(26)),
                                child: Icon(
                                  Icons.person_outline_rounded,
                                  size: getSuitableScreenWidth(28),
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: getSuitableScreenHeight(30)),
                          TextFormField(
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            keyboardType: TextInputType.phone,
                            onSaved: (newValue) => _phoneNumber = newValue!,
                            onChanged: (value) {
                              if (value.isEmpty ||
                                  phoneNumValidatorRegExp.hasMatch(value)) {
                                removeError(error: invalidPhoneNumError);
                              } else if (value.isNotEmpty) {
                                removeError(error: phoneNumberNullError);
                              }
                              return;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                addError(error: phoneNumberNullError);
                                return "";
                              } else if (!phoneNumValidatorRegExp.hasMatch(value)) {
                                addError(error: invalidPhoneNumError);
                                return "";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  fontFamily: 'Lato',
                                  color: secondaryColorDark.withOpacity(0.5),
                                  fontWeight: FontWeight.bold),
                              labelText: "Phone Number",
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: getSuitableScreenWidth(20),
                                  horizontal: getSuitableScreenWidth(30)),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(
                                    right: getSuitableScreenWidth(26)),
                                child: Icon(
                                  Icons.phone_android_outlined,
                                  size: getSuitableScreenWidth(28),
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: getSuitableScreenHeight(30)),
                          TextFormField(
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          onSaved: (newValue) => _address = newValue!,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              removeError(error: addressNullError);
                            }
                            return;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(error: addressNullError);
                              return "";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                                fontFamily: 'Lato',
                                color: secondaryColorDark.withOpacity(0.5),
                                fontWeight: FontWeight.bold),
                            labelText: "Address",
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: getSuitableScreenWidth(20),
                                horizontal: getSuitableScreenWidth(30)),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(
                                  right: getSuitableScreenWidth(26)),
                              child: Icon(
                                Icons.location_on_outlined,
                                size: getSuitableScreenWidth(28),
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                            SizedBox(height: getSuitableScreenHeight(30)),
                            
                            Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Governorate",
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: secondaryColorDark,
                                fontSize: SizeConfig.screenWidth * 0.046,
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: secondaryColorDark,
                                  width: 2.8,
                                ),
                              ),
                              child: DropdownButton<dynamic>(
                                value: _selectedGov,
                                items: getDropdownItems(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGov = value!;
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
                            SizedBox(height: getSuitableScreenHeight(20)),
                            FormError(errors: _errors),
                            SizedBox(height: getSuitableScreenHeight(20)),
                            ElevatedButton(
                              onPressed: () => onPressedIconWithText(),
                              style: ElevatedButton.styleFrom(
                                primary: primaryColor,
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              ),
                              child: const Text("Create Account", style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold)),
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
    Future.delayed(const Duration(milliseconds: 400), () async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          //await context.read<auth_viewModel>().signOut();
          await context.read<AuthModel>().signUp(
              email: _email,
              password: _password,
              fullName: _fullName,
              phoneNumber: _phoneNumber,
              governorate: _selectedGov,
              address: _address);

          // ignore: use_build_context_synchronously
          User? user = context.read<AuthModel>().CurrentUser();

          if (user != null) {
            // ignore: use_build_context_synchronously
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

            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => const FindBus()),(Route<dynamic> route) => false,);
            print("----------${user.email}----------");
          } else {
            // setState(() {
            //   _stateTextWithIcon = ButtonState.fail;
            // });
            // Future.delayed(Duration(milliseconds: 1600), () {
            //   setState(() {
            //     _stateTextWithIcon = ButtonState.idle;
            //   });
            // });
            print("Error Signing Up");
          }
        } catch (e) {
          print(e);
          // setState(() {
          //   _stateTextWithIcon = ButtonState.fail;
          // });
          // Future.delayed(Duration(milliseconds: 1600), () {
          //   setState(() {
          //     _stateTextWithIcon = ButtonState.idle;
          //   });
          // });
        }
      } else {
        // setState(() {
        //   _stateTextWithIcon = ButtonState.success;
        // });
        // Future.delayed(Duration(milliseconds: 1600), () {
        //   setState(() {
        //     _stateTextWithIcon = ButtonState.idle;
        //   });
        // });
      }
    });
  }

}

