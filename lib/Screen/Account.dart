import 'package:flutter/material.dart';
import 'package:movie/Config/Colors.dart';
import 'package:movie/Config/firestoreservice.dart';
import 'package:movie/Screen/Search.dart';

class Account extends StatefulWidget {
  Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  TextEditingController _passController = new TextEditingController();
  TextEditingController _newPassController = new TextEditingController();
  Map<String, dynamic> userData = new Map<String, dynamic>();
  final formKey = GlobalKey<FormState>();
  bool check = false;

  void openTextBox() {
    check = false;
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: Form(
              key: formKey,
              child: Container(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                        obscureText: true,
                        controller: _passController,
                        decoration:
                            InputDecoration(labelText: "Nhập password cũ"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập password cũ";
                          } else if (value != userData['password']) {
                            return "Mật khẩu cũ không chính xác";
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        obscureText: true,
                        controller: _newPassController,
                        decoration:
                            InputDecoration(labelText: "Nhập password mới"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập password mới";
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        obscureText: true,
                        decoration:
                            InputDecoration(labelText: "Nhập lại password mới"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập lại password mới";
                          } else if (_newPassController.text != value) {
                            return "Nhập lại mật khẩu không chính xác";
                          }
                        }),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      new FireStoreService().updatePassword(
                          _newPassController.text,
                          userData['email'],
                          userData['password']);
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Đổi mật khẩu thành công"),
                            );
                          });
                      setState(() {
                        check = true;
                      });
                    }
                  },
                  child: Text("Đổi mật khẩu"))
            ],
          );
        }));
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    final data = await new FireStoreService().getUser();
    setState(() {
      userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Config.colorBackground,
        appBar: AppBar(
            backgroundColor: Config.colorBackground,
            title: Text("Thông tin tài khoản")),
        body: Column(children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Họ tên:',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  userData['name'] != null ? userData['name'] : "",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Email:',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  userData['email'] != null ? userData['email'] : "",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Địa chỉ:',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  userData['address'] != null ? userData['address'] : "",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TextButton(
              onPressed: openTextBox,
              child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Đổi mật khẩu",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ))),
        ]),
      ),
    );
  }
}
