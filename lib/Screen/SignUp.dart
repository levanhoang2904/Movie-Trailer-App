import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie/Config/Colors.dart';
import 'package:movie/Config/firestoreservice.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController rePassController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  FontAwesomeIcons.caretLeft,
                                  color: Colors.white,
                                  size: 50,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 40,
                              ),
                              Text(
                                "SIGN UP",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: TextFormField(
                                  controller: nameController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Config.colorBorder)),
                                    hintText: "Enter Name",
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 234, 187, 187)),
                                    labelText: "Name",
                                    labelStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 233, 163, 163),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Vui lòng nhập họ tên";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: TextFormField(
                                      controller: emailController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Config.colorBorder)),
                                        hintText: "Enter Email",
                                        hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 234, 187, 187)),
                                        labelText: "Email",
                                        labelStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 233, 163, 163),
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: TextFormField(
                                      obscureText: true,
                                      controller: passController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Config.colorBorder)),
                                        hintText: "Enter Password",
                                        hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 234, 187, 187)),
                                        labelText: "Password",
                                        labelStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 233, 163, 163),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Vui lòng nhập password";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: TextFormField(
                                      obscureText: true,
                                      controller: rePassController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Config.colorBorder)),
                                        hintText: "Enter repeat password",
                                        hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 234, 187, 187)),
                                        labelText: "Repeat password",
                                        labelStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 233, 163, 163),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      validator: (value) {
                                        if (value != passController.text) {
                                          return "Vui lòng nhập đúng pasword";
                                        } else if (value == null ||
                                            value.isEmpty) {
                                          return "Vui lòng nhập xác nhận password";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: TextFormField(
                                      controller: addressController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Config.colorBorder)),
                                        hintText: "Enter address",
                                        hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 234, 187, 187)),
                                        labelText: "Địa chỉ",
                                        labelStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 233, 163, 163),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Vui lòng nhập địa chỉ";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.077,
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(20)),
                                child: TextButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        new FireStoreService()
                                            .signUp(
                                                nameController.text,
                                                emailController.text,
                                                passController.text,
                                                addressController.text)
                                            .then((value) =>
                                                Navigator.pushNamed(
                                                    context, '/homepage'));
                                      }
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
