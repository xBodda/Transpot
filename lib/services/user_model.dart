import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class UserModel {
  final String uid;
  UserModel({required this.uid});

  Random random = Random();

  final CollectionReference usersInformation = FirebaseFirestore.instance.collection('users');

  final CollectionReference busesInformation = FirebaseFirestore.instance.collection('buses');

  final CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  int userBalance = 0;

  String userType = '';

  String userName = '';

  String phoneNumber = '';

  String userStatus = '';

  Future addUserData(String fullName, String phoneNumber, String governorate,
      String address,String type) async {
    return await usersInformation.doc(uid).set({
      'Full Name': fullName,
      'Phone Number': phoneNumber,
      'Governorate': governorate,
      'Address': address,
      'Balance': 0,
      'Package': 1,
      'type': type,
      'lat': 0,
      'lng': 0,
      'status': 'online',
      'bus_id': "",
    }, SetOptions(merge: true));
  }

  Future getUserData() async {
    await usersInformation.doc(uid).get()
      .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userBalance = documentSnapshot['Balance'];
        userType = documentSnapshot['type'];
        userName = documentSnapshot['Full Name'];
        phoneNumber = documentSnapshot['Phone Number'];
        userStatus = documentSnapshot['status'];
      }
    });
  }

  Future addBusToDriver() async {
    String id = busesInformation.doc().id;
    int busName = random.nextInt(100);

    await usersInformation
        .doc(uid)
        .set({'bus_id': id}, SetOptions(merge: true));

    return busesInformation.doc(id).set({
      'destination': "",
      'id': id,
      'lat': 0,
      'lng': 0,
      'name': 'A$busName',
      'seats': 10,
    }, SetOptions(merge: true));
  }

  Future addToCart(String id, String product, int price, String details) async {
    Map map = Map<String, dynamic>();
    return await usersInformation.doc(uid).set({
      'cart': FieldValue.arrayUnion([
        map = {"id": id, "product": product, "price": price, "details": details}
      ]),
    }, SetOptions(merge: true));
  }

  Future DeleteAttribute(String attribute) async {
    DocumentReference docRef = usersInformation.doc(uid);
    await docRef.update({attribute: FieldValue.delete()});
  }

  Future addToOrders(
      String orderID, List<dynamic> c, String paymentMethod, int total) async {
    return await orders.doc(orderID).set({
      'userID': uid,
      'Status': "Ordered",
      'Payment method': paymentMethod,
      'Total': total,
      'cart': c,
      'Date&Time': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future addOrderToUser(String orderID) async {
    return await usersInformation.doc(uid).set({
      'orders': FieldValue.arrayUnion([orderID])
    }, SetOptions(merge: true));
  }

  Future addToFavs(String prodID) async {
    return await usersInformation.doc(uid).set({
      'Favorites': FieldValue.arrayUnion([prodID])
    }, SetOptions(merge: true));
  }

  Future removeFromFavs(String prodID) async {
    return await usersInformation.doc(uid).set({
      'Favorites': FieldValue.arrayRemove([prodID])
    }, SetOptions(merge: true));
  }

  void addOrder(
      String orderID, List<dynamic> c, String paymentMethod, int total) {
    addToOrders(orderID, c, paymentMethod, total);
    addOrderToUser(orderID);
  }

  Future addBalance(int balance) async {
    getUserData();
    int newBalance = userBalance + balance;
    print("userBalance: $userBalance");
    return await usersInformation.doc(uid).set({
      'Balance': newBalance
    }, SetOptions(merge: true));
  }

  String get UserType => userType;
}
