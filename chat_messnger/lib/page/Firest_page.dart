// ignore_for_file: prefer_const_constructors

import 'package:chat_messnger/server/server_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'friends.dart';

class Fires_page extends StatefulWidget {
  const Fires_page({Key? key}) : super(key: key);

  @override
  _Fires_pageState createState() => _Fires_pageState();
}

class _Fires_pageState extends State<Fires_page> {
  @override
  Widget build(BuildContext context) {
     User? user = Provider.of<Server_auth>(context, listen: true).theUser;
  return user != null ?Freunds():
     Scaffold(
     
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            // color: Colors.amber,
            //  width: 600,
            //   height: 200,

            child: Lottie.asset('asset/lottie/chat_app.json',
                width: 600, height: 200, fit: BoxFit.cover),
          ),
          Text(
            "Wellcome to Chat App",
            style: TextStyle(fontSize: 30, color: Colors.green, fontWeight: FontWeight.bold),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, ('/login'));
              },
              child: Text("skip",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey[400],),))
        ],
      ),
    );
  }
}
