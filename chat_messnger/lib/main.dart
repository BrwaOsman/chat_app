// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_messnger/page/home.dart';
import 'package:chat_messnger/page/login.dart';
import 'package:chat_messnger/route.dart';
import 'package:chat_messnger/server/server_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// Import the generated file
// import 'firebase_options.dart';



import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
//   await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
// );
  // Future<FirebaseApp> _initialization = Firebase.initializeApp();



  runApp(
    // Messnger()
MultiProvider(
   child: Router_page(),
 providers: [
        ChangeNotifierProvider(create: (context) => Server_auth())

 ],

  )
      );
}