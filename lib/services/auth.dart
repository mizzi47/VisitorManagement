import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> signInUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('Login Success');
      return 'Success';
    } catch (e) {
      print(e.toString());
      return 'error';
    }
  }

  // Future regUser(
  //     String email, String password, String nm, String bm, String pn) async {
  //   try {
  //     AuthResult result = await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     FirebaseUser user = result.user;
  //     await DatabaseService(uid: user.uid).updateUserAcc(email);
  //     await DatabaseService(uid: user.uid).updateClientData(nm, bm, pn);
  //     return _userFromFirebaseUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }
  //
  // Future regMech(
  //     String email, String password, String nm, String gm, String pn) async {
  //   try {
  //     AuthResult result = await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     FirebaseUser user = result.user;
  //     await DatabaseService(uid: user.uid).updateMechAcc(email);
  //     await DatabaseService(uid: user.uid).updateMechData(nm, gm, pn);
  //     return _userFromFirebaseUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }
  //
  // Future updUser(String nm, String bm, String pn) async {
  //   try {
  //     muser = await _auth.currentUser();
  //     await DatabaseService(uid: muser.uid).updateClientData(nm, bm, pn);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }
  //
  // Future updMech(String nm, String gm, String pn) async {
  //   try {
  //     muser = await _auth.currentUser();
  //     await DatabaseService(uid: muser.uid).updateMechData(nm, gm, pn);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }
  //
  // updateMap(double lat, double long) async {
  //   try {
  //     muser = await _auth.currentUser();
  //     await DatabaseService(uid: muser.uid).updateMap(lat, long);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }
  //
  // reqMech(String mid) async {
  //   try {
  //     muser = await _auth.currentUser();
  //     await DatabaseService(uid: muser.uid).reqMech(mid);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }
  //
  // addToMech(String mid, String name, String bname, String pnum) async {
  //   try {
  //     muser = await _auth.currentUser();
  //     await DatabaseService(uid: mid).addToMech(muser.uid, name, bname, pnum);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }



  // Future signOut() async {
  //   try {
  //     return await _auth.signOut();
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  //}

}