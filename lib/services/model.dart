import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Request {
  final String date, name, reason, status, uid;

  Request(this.date, this.name, this.reason, this.status, this.uid);
}
class Model {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static List<Request> requestList = [];

  Future<List> getRequestList() async {
    requestList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('visitorrequest').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
    return allData;
  }
}