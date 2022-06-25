import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transpot/models/cart_item.dart';
import 'package:transpot/models/driver.dart';
import 'package:transpot/services/driver_service.dart';

class MainVariables extends ChangeNotifier {
  
  MainVariables._privateConstructor();
  static final MainVariables _instance = MainVariables._privateConstructor();

  String _paymentMethod = "Select Method";

  factory MainVariables() {
    return _instance;
  }

  final CollectionReference usersInformation = FirebaseFirestore.instance.collection('users');

  final CollectionReference busesInformation = FirebaseFirestore.instance.collection('buses');

  final CollectionReference ridesInformation = FirebaseFirestore.instance.collection('rides');

  late Map<String, dynamic> _userData;

  late int userBalance;

  List<User> users = [];

  List<dynamic> _CartProds = [];

  List<cartItem> _userCart = [];

  List<dynamic> busDetails = [];

  List<dynamic> ridesDetails = [];

  var userDetails = Map();

  var buses = Map();

  int _total = 0;

  double busLat = 0;
  double busLng = 0;

  Future getUserData(User user) async {
    await usersInformation
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userBalance = documentSnapshot['Balance'];
        userDetails['Balance'] = documentSnapshot['Balance'];
        userDetails['Package'] = documentSnapshot['Package'];
        userDetails['bus_id'] = documentSnapshot['bus_id'];
      }
    });
    notifyListeners();
  }

  Future getBusData(String busDoc) async {
    await busesInformation
        .doc(busDoc)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // userBalance = documentSnapshot['Balance'];
        buses['name'] = documentSnapshot['name'];
        buses['seats'] = documentSnapshot['seats'];
      }
    });
    notifyListeners();
  }

  Future updateUserLocation(User user, dynamic lat, dynamic lng) async {
    getUserData(user);
    if(userDetails['bus_id'] != null) {
      await busesInformation
          .doc(userDetails['bus_id'])
          .set({'lat': lat, 'lng': lng}, SetOptions(merge: true));
    }

    return await usersInformation
        .doc(user.uid)
        .set({'lat': lat, 'lng': lng}, SetOptions(merge: true));
  }

  Future addBalance(User user,int balance) async {
    int newBalance = userDetails['Balance'] + balance;
    return await usersInformation
        .doc(user.uid)
        .set({'Balance': newBalance}, SetOptions(merge: true));
  }

  Future updateBalance(User user, int balance) async {
    int newBalance = userDetails['Balance'] - balance;
    return await usersInformation
        .doc(user.uid)
        .set({'Balance': newBalance}, SetOptions(merge: true));
  }

  Future upgradePackage(User user, int packageId) async {
    return await usersInformation
        .doc(user.uid)
        .set({'Package': packageId}, SetOptions(merge: true));
  }

  Future getAllBuses() async {
    QuerySnapshot querySnapshot = await busesInformation.get();

    busDetails = querySnapshot.docs.map((doc) => doc.data()).toList();

    print("buses: $busDetails");
    notifyListeners();
  }

  Future getAllRides(User u) async {
    QuerySnapshot querySnapshot = await ridesInformation.where('bus_id', isEqualTo: u.uid).get();

    ridesDetails = querySnapshot.docs.map((doc) => doc.data()).toList();

    print("buses: $ridesDetails");
    notifyListeners();
  }

  Future dismissRide(String rideId) async {
    ridesInformation
    .doc(rideId)
    .delete();
  }

  Future updateBusSeats(String busDoc,int tickets) async {
    int newSeats = buses['seats'] - tickets;
    return await busesInformation
        .doc(busDoc)
        .set({'seats': newSeats}, SetOptions(merge: true));
  }

  Future updateDriverStatus(User user, String status) async {
    return await usersInformation
        .doc(user.uid)
        .set({'status': status}, SetOptions(merge: true));
  }

  Future <String> getBusStatus(String busId) async {
    String current_status = "";

    await usersInformation
        .where('bus_id', isEqualTo: busId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        current_status = doc['status'];
      });
    });

    return current_status;
  }

  Future addDriverRide(User user, String busId, String payment_method) async {
    String driverId = "";

    await usersInformation.
    where('bus_id', isEqualTo: busId).
    get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
            driverId = doc.id;
        });
    });

    String id = ridesInformation.doc().id;

    return await ridesInformation.doc(id).set({
      'bus_id': driverId,
      'user_id': user.uid,
      'ride_id': id,
      'payment_method': payment_method
    });
  }

  void changePaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  static void getNearbyDrivers(
      StreamController<List<Driver>> nearbyDriverStreamController) {
    nearbyDriverStreamController.sink.add(DriverService.getNearbyDrivers());
  }

  Future getUserCart(User u) async {
    DocumentSnapshot documentSnapshot = await usersInformation.doc(u.uid).get();
    _CartProds = documentSnapshot.get('cart');
    await fillCartList(_CartProds);
    TotalPrice();
  }

  // ignore: non_constant_identifier_names
  Future fillCartList(var CartProds) async {
    _userCart = [];
    for (int i = 0; i < CartProds.length; i++) {
      _userCart.add(cartItem(
          product: CartProds[i]['product'],
          price: CartProds[i]['price'],
          uid: CartProds[i]['id'],
          details: CartProds[i]['details'],
          ));
    }
  }

  // ignore: non_constant_identifier_names
  void TotalPrice() {
    if (_userCart.isEmpty) {
      _total = 0;
    } else {
      _total = 0;
    }
    for (int i = 0; i < _userCart.length; i++) {
      _total += (_userCart[i].price * 1);
    }
    notifyListeners();
  }

  void resetCart() {
    _userCart = [];
    notifyListeners();
    TotalPrice();
  }

  void resetPmethod() {
    _paymentMethod = "Select Method";
    notifyListeners();
  }

  void moveCamera(double lat, double lng) {
    busLat = lat;
    busLng = lng;
    notifyListeners();
  }

  List<cartItem> get userCart => _userCart;

  int get total => _total;

  // ignore: non_constant_identifier_names
  int get UserBalance => userBalance;

  String get paymentMethod => _paymentMethod;

  // ignore: non_constant_identifier_names
  Map<String, dynamic> get UserInfo => _userData;

  // ignore: non_constant_identifier_names
  Map get UserDetails => userDetails;

  // ignore: non_constant_identifier_names
  List get BusDetails => busDetails;

  // ignore: non_constant_identifier_names
  List get RidesDetails => ridesDetails;

  // ignore: non_constant_identifier_names
  Map get Buses => buses;

  // ignore: non_constant_identifier_names
  double get BusLat => busLat;

  // ignore: non_constant_identifier_names
  double get BusLng => busLng;
}