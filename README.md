# Transpot

## About
I developed a fully functioning transportaion flutter application that is compatible with both iOS & Android. I built it with the MVVM
( Model-View-ViewModel ) architecture, and I used [**Firebase Authentication**](https://firebase.google.com/products/auth) to securely authenticate users, [**Cloud Firestore**](https://firebase.google.com/products/firestore) to store product details & users' data, [**Firebase Storage**](https://firebase.google.com/products/storage) to store product images, and [**Provider**](https://pub.dev/packages/provider) for state management.

**Note:** I didn't include my `GoogleService-Info.plist` & `google-services.json` files for obvious reasons, so you have to set up your own firebase project to be able to host this application, otherwise it won't work.

## Features
- **Sign-in, Sign-up, Reset password, Log-out.**
- **Users can edit their information** (Name, Phone number, Address).
- **Cache images for faster load times.**
- **Maintain cart.**
- **Book a ride.**
- **View ride status.**
- **All of the above is synced with the database.**
- **Animated buttons with alert messages.**
- **Animated images & navigation bar.**

## Screenshots
| Home_Screen | Sign_In | Sign_Up |
| :---: | :---: | :---:|
| ![Home](https://github.com/xBodda/Transpot/blob/master/SS/Screenshot_20220921-195418.png) | ![Sign-In](https://github.com/xBodda/Transpot/blob/master/SS/Screenshot_20220921-195555.png) | ![Sign-Up](https://github.com/xBodda/Transpot/blob/master/SS/Screenshot_20220921-195611.png) |
| Main_Screen | SideBar | Packages_Screen |
| ![Main-Screen](https://github.com/xBodda/Transpot/blob/master/SS/Screenshot_20220921-195716.png) | ![Side-Bar](https://github.com/xBodda/Transpot/blob/master/SS/Screenshot_20220921-195733.png) | ![Packages]([https://user-images.githubusercontent.com/32794378/141523046-14edc430-2cfb-4569-bd1b-e0b674248d2d.png](https://github.com/xBodda/Transpot/blob/master/SS/Screenshot_20220921-195757.png)) |
| Wallet_Screen | TopUp_Screen | AvailableBuses_Screen |
| ![Wallet](https://github.com/xBodda/Transpot/blob/master/SS/Screenshot_20220921-195809.png) | ![TopUp](https://github.com/xBodda/Transpot/blob/master/SS/Screenshot_20220921-195824.png) | ![Checkout](https://github.com/xBodda/Transpot/blob/master/SS/Screenshot_20220921-195934.png) |
| Checkout_Screen | TopUp_Screen | Drive_Screen |
| ![Checkout]() | ![Checkout](https://github.com/xBodda/Transpot/blob/master/SS/Screenshot_20220921-195913.png) | ![Checkout](https://github.com/xBodda/Transpot/blob/master/SS/Screenshot_20220921-200122.png) |

## Resources
The following resources were used during the development of this project:
- [**Dart documentation**](https://dart.dev/guides)
- [**Flutter documentation**](https://flutter.dev/docs)
- [**FlutterFire documentation**](https://firebase.flutter.dev/docs/overview)
- [**Flutter Apprentice Book**](https://www.raywenderlich.com/books/flutter-apprentice/v2.0)
- [**Stack Overflow: Flutter**](https://stackoverflow.com/questions/tagged/flutter)
- [**Some UI inspirations**](https://github.com/abuanwar072/E-commerce-Complete-Flutter-UI)

**Note:** I uploaded this project to github only to showcase my work and you cannot use it commercially by any means.
