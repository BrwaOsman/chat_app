
// ignore_for_file: prefer_const_constructors

import 'package:chat_messnger/page/Firest_page.dart';
import 'package:chat_messnger/page/friends.dart';
import 'package:chat_messnger/page/home.dart';
import 'package:chat_messnger/page/login.dart';
import 'package:chat_messnger/page/profilr.dart';
import 'package:chat_messnger/page/regisetr.dart';
import 'package:flutter/material.dart';

class Router_page extends StatefulWidget {
  const Router_page({ Key? key }) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Router_page> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
         fixTextFieldOutlineLabel: false,
         
          textTheme: TextTheme(bodyText1: TextStyle()),
          appBarTheme: AppBarTheme(
            // backgroundColor: Colors.red,
          )),
      initialRoute: '/',
      routes: {
        '/':(context) => Fires_page(),
        '/login': (context) => Login_system(),
        '/register': (context) => Register_system(),
        '/messnger': (context) => Messnger(id_sender: '', name_sender: '',),
        '/friends': (context) => Freunds(),
        '/profile':(context) => Profile()
      },
    );
  }
}