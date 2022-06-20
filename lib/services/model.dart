import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:visitorapp/pages/admin/adminhome.dart';
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

  Future<String?> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return 'wrong';
      } else {
        return 'fail';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signUp(String email, password, username, phone, name) async {
    bool requested = false;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) {
          print(value.user?.uid);
          var docRef = FirebaseFirestore.instance
              .collection("visitordetails")
              .doc(value.user?.uid);
          docRef.set({
            'id': username,
            'name': name,
            'phone': phone,
            'requested': requested
          });
        },
      );
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'weak';
      } else if (e.code == 'email-already-in-use') {
        return 'exists';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> removeRequest(String docId, context) async {
    var docVisitor = FirebaseFirestore.instance
        .collection("visitordetails")
        .doc(_auth.currentUser!.uid);
    docVisitor.update({
      'requested': false,
    });
    await FirebaseFirestore.instance
        .collection("visitorrequest")
        .doc(_auth.currentUser!.uid)
        .collection('requests')
        .doc(docId)
        .delete()
        .then(
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

  Future<void> updateRequest(
      String docId, String userId, String type, BuildContext context) async {
    print(type);
    bool requested = false;
    var docVisitorRequest =
        FirebaseFirestore.instance.collection("visitorrequest").doc(docId);
    var docVisitorDetails =
        FirebaseFirestore.instance.collection("visitordetails").doc(userId);
    if (type == 'Approved') {
      await docVisitorRequest.update({
        'status': 'Approved',
      });
      await docVisitorDetails.update({
        'requested': requested,
      }).then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => InitializeAdminHome(),
            ),
            (route) => false,
          ));
    }

    if (type == 'Rejected') {
      await docVisitorRequest.update({
        'status': 'Rejected',
      });
      await docVisitorDetails.update({
        'requested': requested,
      }).then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => InitializeAdminHome(),
            ),
            (route) => false,
          ));
    }
  }

  Future<List> getRequestList() async {
    requestList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('visitorrequest')
        .where("uid", isEqualTo: _auth.currentUser!.uid)
        .get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  Future<List> getCurrentRequest() async {
    requestList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('visitorrequest')
        .where("status", isEqualTo: 'Pending')
        .where("uid", isEqualTo: _auth.currentUser!.uid)
        .get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  Future<List> getPendingRequestList() async {
    requestList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('visitorrequest')
        .where("status", isEqualTo: 'Pending')
        .get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
    return allData;
  }

  Future<List> getApprovedRequestList() async {
    requestList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('visitorrequest')
        .where("status", isEqualTo: 'Approved')
        .get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
    return allData;
  }

  Future<List> getRejectedRequestList() async {
    requestList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('visitorrequest')
        .where("status", isEqualTo: 'Rejected')
        .get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
    return allData;
  }

  Future<String> addRequest(
      String date2, childname2, reason2, status2, uid2, context) async {
    String success = 'Success';
    String name = '';
    bool requested = true;
    final visitorDoc = FirebaseFirestore.instance
        .collection("visitordetails")
        .doc(_auth.currentUser!.uid);
    visitorDoc.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        requested = data['requested'];
        name = data['name'];

        if (!requested) {
          var docRef =
              FirebaseFirestore.instance.collection("visitorrequest").doc();
          docRef.set({
            'date': date2,
            'name': name,
            'childname': childname2,
            'reason': reason2,
            'status': status2,
            'uid': uid2,
            'docId': docRef.id
          });

          var docVisitor = FirebaseFirestore.instance
              .collection("visitordetails")
              .doc(_auth.currentUser!.uid);
          docVisitor.update({
            'requested': true,
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
                            builder: (BuildContext context) =>
                                InitializeVisitorRequest(),
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
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('REQUEST'),
                  content: Text(
                      'Already Requested. Please wait for admin confirmation'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text('Okay'),
                    )
                  ],
                );
              });
          return success;
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return success;
  }
}
