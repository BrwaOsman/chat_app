// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unnecessary_new, non_constant_identifier_names, avoid_unnecessary_containers, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../server/server_auth.dart';

class Register_system extends StatefulWidget {
  const Register_system({Key? key}) : super(key: key);

  @override
  _Register_systemState createState() => _Register_systemState();
}

class _Register_systemState extends State<Register_system> {
  final _auth = FirebaseAuth.instance;

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _Confirm_Password = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  bool isChecked = false;
  String email = "";
  String password = "";
  Server_auth _server_auth = Server_auth();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "SING UP ",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              Row(
                children: [
                  Flexible(
                    child: testField("First Name", _firstName, false,
                        RegExp(r'^.{3,}$'), "name(Min. 3 Character)", 0),
                  ),
                  Flexible(
                    child: testField("Last Name", _lastName, false,
                        RegExp(r'^.{3,}$'), "name(Min. 3 Character)", 0),
                  )
                ],
              ),
              testField("Email", _email, false,
                  RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]"), "email", 0),
              testField("Password", _password, true, RegExp(r'^.{6,}$'),
                  "Password(Min. 6 Character)", 0),
              testField("Confirm Password", _Confirm_Password, true,
                  RegExp(r'^.{6,}$'), "Password(Min. 6 Character)", 1),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        password = _password.value.text;
                        email = _email.value.text;
                      });
                      email = email.trim(); //remove spaces
                      email = email.toLowerCase();
                      await Provider.of<Server_auth>(context, listen: false)
                          .register_sytelm(email, password)
                          .then((value) {
                        postDetailsToFirestore();
                      });
                      Navigator.pushNamed(context, '/messnger');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 65, right: 65),
                    child: Text(
                      "Create Account",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an Account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        " Sign in ",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.0, color: Colors.black),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(5, 5),
                          color: Colors.grey,
                          blurRadius: 5)
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.network(
                        "https://pbs.twimg.com/profile_images/1455185376876826625/s1AjSxph_400x400.jpg",
                        width: 40,
                      ),
                      Text(
                        "sign in with google",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding testField(String name, TextEditingController _controller, bool _obs,
      RegExp regex, String validate, int conferm) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      child: TextFormField(
        controller: _controller,
        obscureText: _obs,
        decoration: InputDecoration(
          hintText: ' $name.',
          label: Text(" $name"),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your $name");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid $validate");
          }
          if (conferm == 1) {
            if (_password.text != _Confirm_Password.text) {
              return "Password don't match";
            }
          }
          return null;
        },
      ),
    );
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = _firstName.text;
    userModel.secondName = _lastName.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");
  }
}
