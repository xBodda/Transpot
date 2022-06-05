import 'package:flutter/material.dart';
import 'package:transpot/utils/size_config.dart';

const primaryColor = Color(0xffdaa520);
const primaryLightColor = Color(0xffebeded);
const cardBackgroundColor = Color(0xfff3f4f4);
const primaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const secondaryColor = Color(0xFF979797);
const secondaryColorDark = Color(0xff292929);

const animationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getSuitableScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: secondaryColorDark,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp passwordValidatorRegExp = RegExp(r"^(?=.*?[a-zA-Z])(?=.*?[0-9])");
final RegExp phoneNumValidatorRegExp = RegExp(r"^[0-9]{11}$");
final RegExp nameValidatorRegExp = RegExp(r"^[a-zA-Z\s]*$");

const String emailNullError = "Please Enter Your Email";
const String invalidEmailError = "Please Enter A Valid Email";
const String invalidPassError = "Password must contain both letters and numbers";
const String invalidPhoneNumError = "Phone number must contain 11 numbers";
const String invalidNameError = "Name must contain letters only";
const String passNullError = "Please Enter Your Password";
const String shortPassError = "Password must contain at least 8 characters";
const String matchPassError = "Passwords don't match";
const String nameNullError = "Please Enter Your Name";
const String phoneNumberNullError = "Please Enter your phone number";
const String addressNullError = "Please Enter Your Address";
const String wrongEorP = "Wrong email or password";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getSuitableScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getSuitableScreenWidth(2)),
    borderSide: const BorderSide(color: secondaryColorDark),
  );
}

const List<String> governorates = [
  'Al-Minya',
  'Alexandria',
  'Aswan',
  'Asyut',
  'Beheira',
  'Beni Suef',
  'Cairo',
  'Dakahlia',
  'Damietta',
  'Faiyum',
  'Gharbia',
  'Giza',
  'Ismailia',
  'Kafr El-Sheikh',
  'Luxor',
  'Matrouh',
  'Monufia',
  'New Valley',
  'North Sinai',
  'Port Said',
  'Qalyubia',
  'Qena',
  'Red Sea',
  'Sharqia',
  'Sohag',
  'South Sinai',
  'Suez',
];
