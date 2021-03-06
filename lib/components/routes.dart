import 'package:flutter/material.dart';
import 'package:transpot/views/driver/driver_find_ride.dart';
import 'package:transpot/views/driver/driver_signin.dart';
import 'package:transpot/views/driver/driver_signup.dart';
import 'package:transpot/views/driver/ongoing_rides.dart';
import 'package:transpot/views/home.dart';
import 'package:transpot/views/signin.dart';
import 'package:transpot/views/signup.dart';
import 'package:transpot/views/user/book_tickets.dart';
import 'package:transpot/views/user/buses.dart';
import 'package:transpot/views/user/checkout.dart';
import 'package:transpot/views/user/find_bus.dart';
import 'package:transpot/views/user/packages.dart';
import 'package:transpot/views/user/payment.dart';
import 'package:transpot/views/user/track_bus.dart';
import 'package:transpot/views/user/wallet.dart';

final Map<String, WidgetBuilder> routes = {
  // User Routes
  SignUp.routeName: (context) => const SignUp(),
  SignIn.routeName: (context) => const SignIn(),
  FindBus.routeName: (context) => const FindBus(),
  Home.routeName: (context) => const Home(),
  Bus.routeName: (context) => const Bus(),
  Wallet.routeName: (context) => const Wallet(),
  Packages.routeName: (context) => const Packages(),
  Payment.routeName: (context) => const Payment(),
  Checkout.routeName: (context) => const Checkout(),
  BookTickets.routeName: (context) => const BookTickets(),
  TrackBus.routeName: (context) => const TrackBus(),

  // Driver Routes
  DriverSignIn.routeName: (context) => const DriverSignIn(),
  DriverSignUp.routeName: (context) => const DriverSignUp(),
  DriverFindRide.routeName: (context) => const DriverFindRide(),
  OngoingRides.routeName: (context) => const OngoingRides(),
};