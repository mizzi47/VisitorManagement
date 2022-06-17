import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:visitorapp/pages/signin.dart';
import 'package:visitorapp/pages/visitor/visitorhome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
    Widget build(BuildContext context) {

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: InitializationApp(),
      );
    }
  }
