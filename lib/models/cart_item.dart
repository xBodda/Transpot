import 'package:flutter/material.dart';

class cartItem {
  final String product;
  final int price;
  final String uid;
  final String details;

  cartItem(
      {required this.product,
      required this.price,
      required this.uid,
      required this.details});
}
