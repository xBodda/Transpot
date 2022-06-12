import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transpot/models/cart_item.dart';

class MainVariables extends ChangeNotifier {
  
  MainVariables._privateConstructor();
  static final MainVariables _instance = MainVariables._privateConstructor();

  String _paymentMethod = "Select Method";

  factory MainVariables() {
    return _instance;
  }

  final CollectionReference usersInformation = FirebaseFirestore.instance.collection('users');

  late Map<String, dynamic> _userData;

  List<User> users = [];

  List<dynamic> _CartProds = [];

  List<cartItem> _userCart = [];

  int _total = 0;

  Future getUserData(User user) async {
    DocumentSnapshot documentSnapshot = await usersInformation.doc(user.uid).get();
    // _userData = documentSnapshot.data();
  }

  Map<String, dynamic> get userData => _userData;

  void changePaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  Future getUserCart(User u) async {
    DocumentSnapshot documentSnapshot = await usersInformation.doc(u.uid).get();
    _CartProds = documentSnapshot.get('cart');
    await fillCartList(_CartProds);
    TotalPrice();
  }

  Future fillCartList(var CartProds) async {
    _userCart = [];
    for (int i = 0; i < CartProds.length; i++) {
      _userCart.add(cartItem(
          product: CartProds[i]['product'],
          price: CartProds[i]['price'],
          uid: CartProds[i]['id']));
    }
    print(_userCart);
  }

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

  List<cartItem> get userCart => _userCart;

  int get total => _total;

  String get paymentMethod => _paymentMethod;
}