import 'package:flutter/material.dart';
import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(EHealthcareApp());
}

class EHealthcareApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        accentColor: kPrimaryColor,
        backgroundColor: kBackColor,
        primaryColor: kPrimaryColor
      ),
      home: SplashScreen(),
      navigatorObservers: [routeObserver],
      // home: LoginScreen(),
    );
  }
}
