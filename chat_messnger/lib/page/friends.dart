// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_final_fields

import 'package:chat_messnger/model/msg.dart';
import 'package:chat_messnger/model/user_model.dart';
import 'package:chat_messnger/page/home.dart';
import 'package:chat_messnger/server/firestor.dart';
import 'package:chat_messnger/server/server_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Freunds extends StatefulWidget {
  const Freunds({Key? key}) : super(key: key);

  @override
  _FreundsState createState() => _FreundsState();
}

class _FreundsState extends State<Freunds> with WidgetsBindingObserver {
  User? user = FirebaseAuth.instance.currentUser;
  MSG _msg = MSG();
  TextEditingController _searchInput = TextEditingController();
  String? _getdataSesrch;

  FireStor _fireStor = FireStor();
  bool _iconSearch = false;

  bool? test;
  final FirebaseFirestore _firestor = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("online");
  }

  void setStatus(String status) async {
    await _firestor
        .collection("users")
        .doc(user!.uid)
        .update({"status": status});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("online");
    } else {
      // offline
      setStatus("offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Fiernds"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                    Text(
                      "${user!.email}",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )),
            ListTile(
              title: Text("Log Out"),
              leading: Icon(Icons.logout),
              onTap: () async {
                await Provider.of<Server_auth>(context, listen: false)
                    .logout_system();
                Navigator.pushNamed(context, '/');
                setStatus("offline");
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/profile");
        },
        backgroundColor: Colors.green,
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Recent Massenger",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.white)),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Active"),
                    style: ElevatedButton.styleFrom(primary: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: _searchInput,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  label: Text("search"),
                ),
                onChanged: (value) {
                  if (value.length < 1) {
                    setState(() {
                      _getdataSesrch = null;
                      _iconSearch = false;
                    });
                  } else {
                    setState(() {
                      _getdataSesrch = value;
                      _iconSearch = true;
                    });
                  }
                },
              )),
              IconButton(
                  onPressed: _iconSearch ==false? null: () {
                    setState(() {
                      _getdataSesrch = _searchInput.value.text;
                    });

                    print(_getdataSesrch);
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            // stream: FirebaseFirestore.instance.collection("users").snapshots(),
            stream: _fireStor.getDataUser(_getdataSesrch),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Text("isEmpty");
              } else if (snapshot.hasError) {
                return Text("you have any error");
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return LinearProgressIndicator();
              }
              List<DocumentSnapshot> _docs = snapshot.data!.docs;
              List<UserModel> _users = _docs
                  .map((e) =>
                      UserModel.fromMap(e.data() as Map<String, dynamic>))
                  .toList();
              return Expanded(
                  child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Messnger(
                                    name_sender: _users[index].firstName,
                                    id_sender: _docs[index].id,
                                    Status: _users[index].status)));
                      },
                      child: user!.email != _users[index].email
                          ? show_friend(_users, index)
                          : Container());
                },
              ));
            },
          ),
          Container()
        ],
      ),
    );
  }

  // StreamBuilder show_msg() {
  //   return StreamBuilder(
  //     stream: FirebaseFirestore.instance.collection("msg").snapshots(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData || snapshot.data == null) {
  //         return Text("isEmpty");
  //       } else if (snapshot.hasError) {
  //         return Text("you have any error");
  //       } else if (snapshot.connectionState == ConnectionState.waiting) {
  //         return LinearProgressIndicator();
  //       }
  //       List<DocumentSnapshot> _docs = snapshot.data!.docs;
  //       List<UserModel> _users = _docs
  //           .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
  //           .toList();
  //           return
  //     },
  //   );
  // }

  Container show_friend(List<UserModel> _users, int index) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      // decoration: BoxDecoration(
      //     color: Colors.cyan[700], borderRadius: BorderRadius.circular(20)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                    "https://images.ctfassets.net/hrltx12pl8hq/7yQR5uJhwEkRfjwMFJ7bUK/dc52a0913e8ff8b5c276177890eb0129/offset_comp_772626-opt.jpg?fit=fill&w=800&h=300"),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: _users[index].status != "online"
                    ? Container()
                    : Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3)),
                      ),
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_users[index].firstName}",
                    style: TextStyle(
                        fontSize: 16,
                        // color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Opacity(
                    opacity: 0.64,
                    child: Text(
                      _users[index].firstName == _msg.name
                          ? "${_msg.messnger}"
                          : "not messnger",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Opacity(
            opacity: 0.64,
            child: Text(
              "time",
            ),
          ),
        ],
      ),
    );
  }
}
