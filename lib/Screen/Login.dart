import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie/Config/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:movie/Config/Colors.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passWordController = TextEditingController();
  bool checkTypePassword = true;

  static Future<User?> Signin(String email, String password) async {
    User? user;
    try {
      UserCredential? userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("Sai tên tài khoản hoặc mật khẩu");
      }
    }
    return user;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passWordController.dispose();
    super.dispose();
  }

  getInfoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('emailInput') != null &&
        prefs.getString('passInput') != null) {
      print(prefs.getString('emailInput'));
      Signin(prefs.getString('emailInput')!, prefs.getString('passInput')!);
      Navigator.pushNamed(context, '/homepage');
    } else
      return;
  }

  @override
  void initState() {
    super.initState();
    getInfoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/backgroundlogin.jpg"),
                  fit: BoxFit.cover)),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            child: Form(
                key: formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Text(
                          "TRAILER MOVIE",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                controller: _emailController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Config.colorBorder)),
                                  hintText: "Enter Email",
                                  hintStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 234, 187, 187)),
                                  labelText: "Email",
                                  labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 233, 163, 163),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Vui lòng nhập Email";
                                  } else {
                                    RegExp regex = RegExp(r'@');
                                    bool ktra = regex.hasMatch(value);
                                    if (ktra == false) {
                                      return "Vui lòng nhập đúng email";
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                controller: _passWordController,
                                obscureText: checkTypePassword,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          checkTypePassword =
                                              !checkTypePassword;
                                        });
                                      },
                                      icon: Icon(checkTypePassword
                                          ? FontAwesomeIcons.eyeSlash
                                          : FontAwesomeIcons.eye)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Config.colorBorder)),
                                  hintText: "Enter Password",
                                  hintStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 234, 187, 187)),
                                  labelText: "Password",
                                  labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 233, 163, 163),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Vui lòng nhập passoword";
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.077,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(20)),
                          child: TextButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  User? user = await Signin(
                                      _emailController.text,
                                      _passWordController.text);
                                  if (user != null) {
                                    print(user);
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString(
                                        'emailInput', _emailController.text);
                                    prefs.setString(
                                        'passInput', _passWordController.text);
                                    Navigator.pushNamed(context, '/homepage');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Tài khoản hoặc mật khẩu không chính xác")),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: Row(
                                children: [
                                  Text("You don't have account? "),
                                  Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              )),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/forgotPassword');
                            },
                            child: Text(
                              "Quên mật khẩu",
                              style: TextStyle(fontSize: 18),
                            ))
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
