import 'dart:async';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:visitorapp/pages/visitor/visitorhome.dart';
import 'package:visitorapp/widget.dart';
import 'package:visitorapp/services/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
var docRequest;

class Init {
  static Future initialize() async {
    await _loadFirestore();
  }

  static _loadFirestore() async {
    final docRef = FirebaseFirestore.instance
        .collection('visitorrequest')
        .doc(_auth.currentUser!.uid);
    docRequest = docRef;
  }
}

class InitializeVisitorRequest extends StatelessWidget {
  final Future _initFuture = Init.initialize();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Initialization',
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Visitorrrequest();
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

class Visitorrrequest extends StatefulWidget {
  @override
  _Visitorrrequest createState() => _Visitorrrequest();
}

class _Visitorrrequest extends State<Visitorrrequest> {
  Model _db = Model();
  late Future<List> getRequestList;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void initState() {
    getRequestList = _db.getRequestList();
    super.initState();
    setState(() {});
  }

  final formkey = GlobalKey<FormState>();

  TextEditingController appointmentDate = new TextEditingController();
  TextEditingController reason = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController name = new TextEditingController();

  var datePicked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('VISITOR MANAGEMENT'),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => InitializeVisitor(),
              ),
                  (route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 25.0,
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  SizedBox(
                    child: Center(
                      child: InkWell(
                        onTap: () async {
                          appointmentDate.text = DateTime.now()
                              .toString()
                              .substring(0, 10);
                          showDialog(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('NEW REQUEST'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      TextFormField(
                                        controller: appointmentDate,
                                        onTap: () async {
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                          datePicked = await DatePicker
                                              .showSimpleDatePicker(
                                            context,
                                            firstDate: DateTime(1960),
                                            dateFormat: "dd-MM-yyyy",
                                            looping: true,
                                          );
                                          appointmentDate.text = datePicked
                                              .toString()
                                              .substring(0, 10);
                                        },
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.calendar_today),
                                          hintText: "Appointment Date",
                                          hintStyle:
                                          TextStyle(color: Colors.grey),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter Appointment Date';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        onTap: () {
                                          reason.text = '';
                                        },
                                        decoration: const InputDecoration(
                                          icon: Icon(Icons.wysiwyg_sharp),
                                          hintText: "Reason",
                                          hintStyle:
                                          TextStyle(color: Colors.grey),
                                        ),
                                        controller: reason,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your Reason';
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
                                    child: Text('Submit'),
                                    onPressed: () async {
                                      SplashScreen();
                                      var order = await _db.addRequest(
                                          appointmentDate.text, 'name2',
                                          reason.text, 'Pending',
                                          _auth.currentUser!.uid, context);
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
                            decoration: BoxDecoration(color: Colors.white12),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0, color: Colors.black))),
                                child: Icon(Icons.add_to_photos_rounded,
                                    color: Colors.black),
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'NEW REQUEST',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  SingleChildScrollView(
                    child: SizedBox(
                      child: SingleChildScrollView(
                        child: Container(
                          height: 500,
                          child: FutureBuilder<List>(
                              future: getRequestList,
                              builder: (context, snapshot) {
                                if (snapshot.hasError)
                                  return Text(snapshot.toString());
                                if (snapshot.hasData) {
                                  return _buildItem(snapshot.data);
                                } else {
                                  return SplashScreen();
                                }
                              }),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(List? list) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list?.length,
      itemBuilder: (BuildContext context, int index) {
        IconButton ic = IconButton(
            onPressed:(){},
            icon: Icon(Icons.offline_pin_rounded, color: Colors.white));
        Color clr = Color.fromRGBO(64, 75, 96, .9);
        if (list?[index]['status'] == 'Pending') {
          ic = IconButton(
              onPressed:(){
                _db.removeRequest(list?[index]['docId'], context);
              },
              icon: Icon(Icons.delete, color: Colors.white));
          clr = Colors.teal;
        }
        if (list?[index]['status'] == 'Rejected') {
          ic = IconButton(
              onPressed:(){},
              icon: Icon(Icons.dangerous, color: Colors.white));
          clr = Color.fromRGBO(64, 75, 96, .9);
        }
        if (list?[index]['status'] == 'Accepted') {
          ic = IconButton(
              onPressed:(){},
              icon: Icon(Icons.offline_pin_rounded, color: Colors.white));
          clr = Color.fromRGBO(64, 75, 96, .9);
        }
        return Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: clr),
            child: ListTile(
              contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                        new BorderSide(width: 1.0, color: Colors.white24))),
                child: Icon(Icons.file_copy_rounded, color: Colors.white),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list?[index]['date'],
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Text(
                    list?[index]['status'],
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
              trailing: ic,
            ),
          ),
        );
      },
    );
  }
}
