// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'dart:math';

import 'package:chat_messnger/model/msg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../server/server_auth.dart';

class Messnger extends StatefulWidget {
  const Messnger({Key? key}) : super(key: key);

  @override
  _MesngerState createState() => _MesngerState();
}

class _MesngerState extends State<Messnger> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  TextEditingController _messnger = TextEditingController();
  TextEditingController _name = TextEditingController();
    ScrollController _scrollController = new ScrollController();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Chat_Messnger"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  await Provider.of<Server_auth>(context, listen: false)
                      .logout_system();
                  Navigator.pushNamed(context, '/');
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: Form(
          key: _globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<QuerySnapshot>(
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('error');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('empty');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return LinearProgressIndicator();
                  }
                  List<DocumentSnapshot> _docs = snapshot.data!.docs;
                   if (_scrollController.hasClients) {
   _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  //  .animateTo(
  //           0.0,
  //           curve: Curves.easeOut,
  //           duration: const Duration(milliseconds: 300),
  //         );
    }
                  
                  List<MSG> _msg = _docs
                      .map((e) => MSG.fromMap(e.data() as Map<String, dynamic>))
                      .toList();

                  return Expanded(
                      child: ListView.builder(
                         reverse: true,
                        // shrinkWrap: true,
                        controller: _scrollController,
                          itemCount: _msg.length,
                          itemBuilder: (context, index) {
                            var action =
                                _msg[index].name != loggedInUser.firstName;
                            return Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                  action==true?  show_messnger(action, _msg, index):button_messnger(_docs,index),
                                    // Text(snapshot.data['name'].toString() ),
                                  action == true ? button_messnger(_docs, index):show_messnger(action, _msg, index)
                                  ],
                                ));
                          }));
                },
                stream:
                    FirebaseFirestore.instance.collection("msg").orderBy("date_time", descending: true).snapshots(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        controller: _messnger,
                        decoration: InputDecoration(
                          hintText: "messnger...",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("msg")
                            .doc()
                            .get();
                        if (_globalKey.currentState!.validate()) {
                          MSG _msg = MSG(
                              messnger: _messnger.value.text,
                              name: "${loggedInUser.firstName}",
                              date_time: DateTime.now().toString());

                          _messnger.text = "";
                          _name.text = "";

                          FirebaseFirestore.instance
                              .collection("msg")
                              .add(_msg.toMap());
                          // .doc()
                          // .set(_msg.toMap(), SetOptions(merge: true));
                        }
                      },
                      child: Icon(Icons.send))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextButton button_messnger(List<DocumentSnapshot<Object?>> _docs, int index) {
    return TextButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection("msg")
                                            .doc(_docs[index].id)
                                            .delete();
                                      },
                                      child: Icon(Icons.delete,
                                          color: Colors.red));
  }

  Column show_messnger(bool action, List<MSG> _msg, int index) {
    return Column(
                                    crossAxisAlignment: action == true
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        _msg[index].name ?? 'no name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 10,
                                              bottom: 10),
                                          decoration: BoxDecoration(
                                              color:action==true? Colors.blue: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Text(
                                              _msg[index].messnger ??
                                                  'no messnger',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white))),
                                      Text(_msg[index].date_time ?? 'no date',
                                          style: TextStyle(fontSize: 15)),
                                    ],
                                  );
  }
}

class $ {}
