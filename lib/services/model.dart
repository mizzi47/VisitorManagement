import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:visitorapp/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:visitorapp/pages/visitor/visitorhome.dart';

import '../pages/visitor/visitorrequest.dart';

class Request {
  final String date, name, reason, status, uid;

  Request(this.date, this.name, this.reason, this.status, this.uid);
}

class Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static List<Request> requestList = [];

  Future<void> signOut(context) async {
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SignIn(),
      ),
          (route) => false,
    );
  }

  Future<void> signIn(String email, String password, context) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => InitializeVisitor(),
      ),
          (route) => false,
    );
  }

  Future<void> removeRequest(String docId, context) async {
    await FirebaseFirestore.instance.collection("visitorrequest").doc(docId).delete().then(
          (doc) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => InitializeVisitorRequest(),
            ),
                (route) => false,
          ),
      onError: (e) => print("Error updating document $e"),
    );
  }

  Future<List> getRequestList() async {
    requestList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('visitorrequest').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
    return allData;
  }
  Future<String> addRequest(
      String date2, name2, reason2, status2, uid2, context) async {
    String success = 'successfully';
    var docRef  = FirebaseFirestore.instance.collection("visitorrequest").doc();
    docRef.set({
      'date': date2,
      'name': name2,
      'reason': reason2,
      'status': status2,
      'uid': uid2,
      'docId': docRef.id
    });

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('REQUEST'),
            content: Text('Successfully Added!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => InitializeVisitorRequest(),
                    ),
                    (route) => false,
                  );
                },
                child: Text('Okay'),
              )
            ],
          );
        });
    return success;
  }

}
