import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:visitorapp/widget.dart' as wdg;
import 'package:visitorapp/services/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:visitorapp/pages/signin.dart';
import 'package:bottom_bar/bottom_bar.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
var docRequest;
Model _db = Model();
late Future<List> getPendingRequestList;
late Future<List> getApprovedRequestList;
late Future<List> getRejectedRequestList;

class InitVR {
  static Future initialize() async {
    await _loadFirestore();
  }

  static _loadFirestore() async {
    getPendingRequestList = _db.getPendingRequestList();
    getApprovedRequestList = _db.getApprovedRequestList();
    getRejectedRequestList = _db.getRejectedRequestList();
  }
}

class InitializeAdminHome extends StatelessWidget {
  final Future _initFuture = InitVR.initialize();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Initialization',
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AdminHome();
          } else {
            return wdg.SplashScreen();
          }
        },
      ),
    );
  }
}

class AdminHome extends StatefulWidget {
  @override
  _AdminHome createState() => _AdminHome();
}

class _AdminHome extends State<AdminHome> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  int _currentPage = 0;
  final _pageController = PageController();
  final formkey = GlobalKey<FormState>();

  TextEditingController appointmentDate = new TextEditingController();
  TextEditingController childname = new TextEditingController();
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
                builder: (BuildContext context) => SignIn(),
              ),
              (route) => false,
            );
          },
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          Stack(
            fit: StackFit.expand,
            children: [
              Container(
                height: 500,
                child: Column(
                  children: [
                    Card(
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        height: 40,
                        width: 1000,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(child: Text('APPROVE OR REJECT REQUEST')),
                      ),
                    ),
                    FutureBuilder<List>(
                        future: getPendingRequestList,
                        builder: (context, snapshot) {
                          if (snapshot.hasError)
                            return Text(snapshot.toString());
                          if (snapshot.hasData) {
                            return _buildItem(snapshot.data, context);
                          } else {
                            return wdg.SplashScreen();
                          }
                        }),
                  ],
                ),
              )
            ],
          ),
          Stack(
            fit: StackFit.expand,
            children: [
              Container(
                height: 500,
                child: Column(
                  children: [
                    Card(
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        height: 40,
                        width: 1000,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(child: Text('APPROVED REQUEST')),
                      ),
                    ),
                    FutureBuilder<List>(
                        future: getApprovedRequestList,
                        builder: (context, snapshot) {
                          if (snapshot.hasError)
                            return Text(snapshot.toString());
                          if (snapshot.hasData) {
                            return _buildItem(snapshot.data, context);
                          } else {
                            return wdg.SplashScreen();
                          }
                        }),
                  ],
                ),
              )
            ],
          ),
          Stack(
            fit: StackFit.expand,
            children: [
              Container(
                height: 500,
                child: Column(
                  children: [
                    Card(
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        height: 40,
                        width: 1000,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(child: Text('REJECTED REQUEST')),
                      ),
                    ),
                    FutureBuilder<List>(
                        future: getRejectedRequestList,
                        builder: (context, snapshot) {
                          if (snapshot.hasError)
                            return Text(snapshot.toString());
                          if (snapshot.hasData) {
                            return _buildItem(snapshot.data, context);
                          } else {
                            return wdg.SplashScreen();
                          }
                        }),
                  ],
                ),
              )
            ],
          ),
        ],
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: _buildBottombar(context),
    );
  }

  Widget _buildItem(List? list, BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list?.length,
      itemBuilder: (BuildContext context, int index) {
        IconButton ic = IconButton(
            onPressed: () {},
            icon: Icon(Icons.offline_pin_rounded, color: Colors.white));
        Color clr = Color.fromRGBO(64, 75, 96, .9);
        if (list?[index]['status'] == 'Pending') {
          ic = IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.widgets_sharp,
                color: Colors.white,
                size: 40,
              ));
          clr = Colors.teal;
          return returnCard(list, index, clr, ic, list?[index]['status'], context);
        }
        if (list?[index]['status'] == 'Rejected') {
          ic = IconButton(
              onPressed: () {},
              icon: Icon(Icons.dangerous, color: Colors.white));
          clr = Color.fromRGBO(64, 75, 96, .9);
          return returnCard(list, index, clr, ic, list?[index]['status'], context);
        }
        if (list?[index]['status'] == 'Approved') {
          ic = IconButton(
              onPressed: () {},
              icon: Icon(Icons.offline_pin_rounded, color: Colors.white));
          clr = Color.fromRGBO(64, 75, 96, .9);
          return returnCard(list, index, clr, ic, list?[index]['status'], context);
        }
        return SizedBox(width: 0, height: 0);
      },
    );
  }

  returnCard(List? list, int index, Color clr, IconButton ic, String type, BuildContext context) {
    return InkWell(
      onTap: () {
        if (type == 'Pending') {
          showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('APPROVE OR REJECT'),
                actions: [
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                  }, child: Text('CANCEL', style: TextStyle(color: Colors.black26),)),
                  TextButton(onPressed: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('REJECT?'),
                          actions: [
                            TextButton(onPressed: () {
                              Navigator.pop(context);
                            }, child: Text('CANCEL', style: TextStyle(color: Colors.black26),)),
                            TextButton(onPressed: () {
                              _db.updateRequest(list![index]['docId'], list![index]['uid'], 'Rejected', context);
                            }, child: Text('CONFIRM', style: TextStyle(color: Colors.green),)),
                          ],
                        );
                      },
                    );
                  }, child: Text('REJECT', style: TextStyle(color: Colors.red),)),
                  TextButton(onPressed: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('CONFIRM?'),
                          actions: [
                            TextButton(onPressed: () {
                              Navigator.pop(context);
                            }, child: Text('CANCEL', style: TextStyle(color: Colors.black26),)),
                            TextButton(onPressed: () {
                              _db.updateRequest(list![index]['docId'], list![index]['uid'], 'Approved', context);
                            }, child: Text('CONFIRM', style: TextStyle(color: Colors.green),)),
                          ],
                        );
                      },
                    );

                  }, child: Text('APPROVE', style: TextStyle(color: Colors.green),)),
                ],
              );
            },
          );
        }
      },
      child: Card(
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
                  style: TextStyle(color: Colors.yellowAccent, fontSize: 15),
                ),
                Divider(
                  color: Colors.white,
                ),
                Text(
                  'Name: ' + list?[index]['name'],
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Text(
                  'Reason: ' + list?[index]['reason'],
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Text(
                  'Child: ' + list?[index]['childname'],
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
            trailing: ic,
          ),
        ),
      ),
    );
  }

  Widget _buildBottombar(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: BottomBar(
          backgroundColor: Colors.blueGrey,
          selectedIndex: _currentPage,
          onTap: (int index) {
            _pageController.jumpToPage(index);
            setState(() => _currentPage = index);
          },
          items: <BottomBarItem>[
            BottomBarItem(
              icon: SizedBox(child: Icon(Icons.list)),
              title: Text('ALL TASK'),
              activeColor: Colors.white,
            ),
            BottomBarItem(
              icon: SizedBox(child: Icon(Icons.my_library_books_rounded)),
              title: Text('MY TASK'),
              activeColor: Colors.white,
            ),
            BottomBarItem(
              icon: Icon(Icons.library_add_sharp),
              title: Text('ASSIGN TASK'),
              activeColor: Colors.white,
              darkActiveColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
