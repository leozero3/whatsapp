import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/Login.dart';
import 'package:whatsapp/RouteGenerator.dart';

 final ThemeData temaPadrao = ThemeData(
     primaryColor: Color(0xff075E54), accentColor: Color(0xff25D366)
);


  final ThemeData temaIOS = ThemeData(
      primaryColor: Colors.grey[200], accentColor: Color(0xff25D366)
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: Login(),
    theme: Platform.isIOS ? temaIOS : temaPadrao,

    initialRoute: '/',
    onGenerateRoute: RouteGenerator.generateRoute,

    debugShowCheckedModeBanner: false,
  ));
}
