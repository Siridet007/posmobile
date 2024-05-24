// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pos_mobile/page/select.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  bool remember = false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  String? useCode;

  Future<void> loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username.text = prefs.getString('username') ??
          ''; // โหลดค่า username และตั้งค่าใน TextField
      remember = prefs.getBool('remember') ??
          false; // โหลดค่า rememberMe และตั้งค่าใน Checkbox
      if (remember) {
        password.text = prefs.getString('password') ??
            ''; // ถ้า rememberMe เป็น true โหลดค่า password และตั้งค่าใน TextField
      }
    });
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username.text);
    await prefs.setBool('remember', remember);
    if (remember) {
      await prefs.setString('password', password.text);
    } else {
      await prefs.remove(
          'password'); // ถ้าไม่ต้องจดจำรหัสผ่าน ให้ลบค่า password ที่บันทึกไว้
    }
  }

  Future<void> checklogin() async {
    FormData formData = FormData.fromMap({
      "param": "auth",
      "user": username.text,
      "password": password.text,
      "system_id": "0019",
    });
    String urlAPI = "http://172.2.100.14/usercontrol/datamodule/mainlib.php";
    Response response = await Dio().post(urlAPI, data: formData);
    if (response.data['found'] == 'Y') {
      saveData();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectPage(
            username: username.text,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                    color: const Color.fromRGBO(237, 0, 140, 1)),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ),
              ),
              const Text(
                '  Alert',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          content: const Text(
            'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(237, 0, 140, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'เข้าใจแล้ว',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return exit(0);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.pink[50],
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.pink[100],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 95,
                        height: 95,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromRGBO(45, 113, 134, 1),
                          border: Border.all(
                            color: const Color.fromRGBO(45, 113, 134, 1),
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: ClipOval(
                            child: Image.network(
                              'http://172.2.200.15/fos3/personpic/${username.text}.jpg',
                              fit: BoxFit.fitWidth,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/images/notperson.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 290,
                        height: 50,
                        child: TextField(
                          controller: username,
                          style: const TextStyle(
                              fontSize: 24, color: Colors.black),
                          onChanged: (value) {
                            setState(() {
                              useCode = username.text;
                            });
                            username.value = TextEditingValue(
                              text: value.toUpperCase(),
                              selection: username.selection,
                            );
                          },
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: const TextStyle(
                                fontSize: 24, color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 200, 215, 212),
                            suffixIcon: const Icon(Icons.person),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 290,
                        height: 50,
                        child: TextField(
                          controller: password,
                          obscureText: _obscureText, // ซ่อนตัวอักษรใน Password
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 200, 215, 212),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              color: Colors.white,
                              child: Checkbox(
                                fillColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.grey;
                                  }
                                  return Colors.grey;
                                }),
                                value: remember,
                                onChanged: (value) {
                                  setState(() {
                                    remember = value!;
                                  });
                                },
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  remember = !remember;
                                });
                              },
                              child: const Text(
                                'REMEMBER',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed:
                              username.text.isEmpty || password.text.isEmpty
                                  ? null
                                  : () {
                                      setState(() {
                                        checklogin();
                                      });
                                    },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => const Color.fromRGBO(237, 0, 140, 1),
                            ),
                          ),
                          icon: const Icon(Icons.login),
                          label: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
