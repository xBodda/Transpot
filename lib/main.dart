import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transpot/components/routes.dart';
import 'package:transpot/components/splash_screen.dart';
import 'package:transpot/services/auth_model.dart';
import 'package:transpot/services/main_variables.dart';
import 'package:transpot/services/map_service.dart';
import 'package:transpot/services/notifier_service.dart';
import 'package:transpot/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:transpot/views/user/checkout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      
      providers:[
        Provider<AuthModel>(create: (_) => AuthModel(FirebaseAuth.instance)),
        StreamProvider(
          initialData: 0,
          create: (context) => context.read<AuthModel>().authStateChanges,
        ),
        ChangeNotifierProvider(create: (context) => MainVariables()),
        ChangeNotifierProvider(create: (context) => MapService()),
        ChangeNotifierProvider<UINotifiersModel>(create: (context) => UINotifiersModel()),
      ],
      child: MaterialApp(
        title: 'Transpot',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: primaryLightColor,
          fontFamily: "Lato",
          textTheme: const TextTheme(
            bodyText1: TextStyle(color: secondaryColorDark),
            bodyText2: TextStyle(color: secondaryColorDark),
          ),
          inputDecorationTheme: inputDecorationTheme(),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashPage(),
        routes: routes,
      ),
    );
  }

  InputDecorationTheme inputDecorationTheme() {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(width: 3, color: secondaryColorDark),
      gapPadding: 10,
    );

    OutlineInputBorder outlineInputErrorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: const BorderSide(width: 3, color: Color(0xffea4b4b)),
      gapPadding: 10,
    );
    return InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        border: outlineInputBorder,
        errorStyle: const TextStyle(height: 0),
        errorBorder: outlineInputErrorBorder
      );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
