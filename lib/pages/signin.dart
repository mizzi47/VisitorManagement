import 'package:flutter/material.dart';
import 'package:visitorapp/pages/admin/adminhome.dart';
import 'package:visitorapp/pages/signup.dart';
import 'package:visitorapp/pages/visitor/visitorhome.dart';
import 'package:visitorapp/services/model.dart';
import 'package:visitorapp/widget.dart' as wdg;

class SignIn extends StatefulWidget {
  static const String id = 'mentor sample 1';

  @override
  _SignInState createState() => _SignInState();
}

Map<String, String> uis = {
  SignIn.id: 'Sign in',
  SignUp.id: 'Sign in',
};

class _SignInState extends State<SignIn> {
  Model _db = Model();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController adm_username = TextEditingController();
  TextEditingController adm_password = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final adm_formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.green.shade900,
          Colors.green.shade500,
          Colors.green.shade400,
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Align(
                alignment: Alignment.centerRight,
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Admin Login'),
                          content: Container(
                            height: 250,
                            child: Form(
                              key: adm_formkey,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: "Username",
                                      ),
                                      controller: adm_username,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter username';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        hintText: "Password",
                                      ),
                                      controller: adm_password,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter password';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: TextButton(
                                        onPressed: () async {
                                          if (adm_formkey.currentState!
                                              .validate()) {
                                            if (adm_username.text == 'admin' &&
                                                adm_password.text == '0000') {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (BuildContext context) =>
                                                      InitializeAdminHome(),
                                                ),
                                                    (route) => false,
                                              );
                                            } else {
                                              Navigator.pop(context);
                                              showDialog(
                                                  barrierDismissible: true,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                        content: Text(
                                                            'Wrong username/password'));
                                                  });
                                            }
                                          }
                                        },
                                        child: const Text(
                                          "Sign in",
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Colors.black26,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                      height: 20,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(child: Text('Admin'))),
                )),
            // #login, #welcome
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "VISITOR MANAGEMENT",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Welcome Back",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        // #email, #password
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(171, 171, 171, .7),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)),
                            ],
                          ),
                          child: Form(
                            key: formkey,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade200)),
                                  ),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                    controller: email,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter email';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade200)),
                                  ),
                                  child: TextFormField(
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                    controller: password,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter password';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // #login
                        Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.green[800]),
                          child: Center(
                            child: TextButton(
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  wdg.showLoaderDialog(context);
                                  final status = await _db.signIn(
                                      email.text, password.text);
                                  print(status);
                                  if (status!.contains('success')) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            InitializeVisitor(),
                                      ),
                                      (route) => false,
                                    );
                                  } else if(status!.contains('wrong')){
                                    Navigator.pop(context);
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Row(
                                            children: [
                                              const Text('Wrong Username/Password'),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }else{
                                    Navigator.pop(context);
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Row(
                                            children: [
                                              const Text('No user found'),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // #login SNS
                        const Text(
                          "Does not have an account?",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.grey.shade700,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const SignUp(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
