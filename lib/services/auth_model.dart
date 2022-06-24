import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transpot/services/user_model.dart';

class AuthModel {
  late final FirebaseAuth _firebaseAuth;

  AuthModel(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

   User? CurrentUser() => _firebaseAuth.currentUser;

  Future<User?> AnonymousOrCurrent() async {
    if (_firebaseAuth.currentUser == null) {
      await _firebaseAuth.signInAnonymously();
    }
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserCredential> signIn({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        rethrow;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        rethrow;
      }
      rethrow;
    }
  }

  Future<UserCredential> signUp(
      {required String email,
      required String password,
      required String fullName,
      required String phoneNumber,
      required String governorate,
      required String address,
      required String type}) async {
      try {
        UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        User? user = result.user;

        await UserModel(uid: user!.uid).addUserData(fullName, phoneNumber, governorate, address, type);
        return result;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
        rethrow;
      } catch (e) {
        print(e);
        rethrow;
      }
  }

  Future <String> getUserType(User user) async {
    String userType = "";
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userType = documentSnapshot['type'];
      } else {
        userType = 'null';
      }
    });
    
    return userType;
  }
}