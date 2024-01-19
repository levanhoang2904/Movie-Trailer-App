import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForggotPassword extends StatefulWidget {
  const ForggotPassword({super.key});

  @override
  State<ForggotPassword> createState() => _ForggotPasswordState();
}

class _ForggotPasswordState extends State<ForggotPassword> {
  TextEditingController _emailController = TextEditingController();

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Link reset password send to your email"),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Text(
            "Enter your email and we will send you a password reset link",
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 20,
          ),
          Form(
              child: TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(), hintText: 'Email'),
          )),
          ElevatedButton(
              onPressed: resetPassword, child: Text("Reset Password"))
        ]),
      ),
    );
  }
}
