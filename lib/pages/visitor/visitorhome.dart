import 'dart:async';
import 'package:visitorapp/pages/visitor/visitorrequest.dart';
import 'package:visitorapp/widget.dart';
import 'package:visitorapp/pages/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var document;
String uname = '';
final FirebaseAuth _auth = FirebaseAuth.instance;

class Init {
  static Future initialize() async {
    await _loadFirestore();
  }

  static _loadFirestore() async {
    document = await FirebaseFirestore.instance
        .collection('visitordetails')
        .doc(_auth.currentUser!.uid)
        .get();
    uname = document.data['name'].toString();
    print(uname);
    //TODO register services
  }
}

class InitializationApp extends StatelessWidget {
  final Future _initFuture = Init.initialize();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Initialization',
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Visitorhome();
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
        ),
      ),
    );
  }
}

class Visitorhome extends StatefulWidget {
  @override
  _Visitorhome createState() => _Visitorhome();
}

class _Visitorhome extends State<Visitorhome> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void initState() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final docRef = FirebaseFirestore.instance
        .collection("visitordetails")
        .doc(_auth.currentUser!.uid);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        uname = data['name'];
      },
      onError: (e) => print("Error getting document: $e"),
    );
    super.initState();
    setState(() {});
  }

  final formkey = GlobalKey<FormState>();

  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController name = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('VISITOR MANAGEMENT'),
        backgroundColor: Colors.green,
        leading: GestureDetector(
          child: Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onTap: () {
            showLoaderDialog(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SignIn(),
              ),
              (route) => false,
            );
          },
        ),
      ),
      body: Column(
        children: [
          Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                InkWell(
                  onTap: () async {
                    final docRef = FirebaseFirestore.instance
                        .collection("visitordetails")
                        .doc(_auth.currentUser!.uid);
                    docRef.get().then(
                      (DocumentSnapshot doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        username.text = data['id'];
                        phone.text = data['phone'];
                        name.text = data['name'];
                      },
                      onError: (e) => print("Error getting document: $e"),
                    );

                    showDialog(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('UPDATE PROFILE'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                TextFormField(
                                  onTap: () {
                                    username.text = '';
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Username",
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  controller: username,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter username';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  onTap: () {
                                    phone.text = '';
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Phone",
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  controller: phone,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter phone';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  onTap: () {
                                    name.text = '';
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Name",
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  controller: name,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter name';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.blue,
                              ),
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.green,
                              ),
                              child: Text('SAVE'),
                              onPressed: () async {
                                showLoaderDialog(context);
                                await FirebaseFirestore.instance
                                    .collection("visitordetails")
                                    .doc(_auth.currentUser!.uid)
                                    .update({
                                  "id": username.text,
                                  "phone": phone.text,
                                  "name": name.text
                                });
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Visitorhome(),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    elevation: 8.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child:
                              Icon(Icons.account_circle, color: Colors.white),
                        ),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'UPDATE PROFILE',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Visitorrrequest()),
                    );
                  },
                  child: Card(
                    elevation: 8.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child: Icon(Icons.file_copy, color: Colors.white),
                        ),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'VISITS REQUEST',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
