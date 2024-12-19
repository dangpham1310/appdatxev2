import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import './OTPScreen.dart';
import '../login/Driver/login.dart'; // Import your PasswordScreen widget
import '../login/Customer/login.dart'; // Import your PasswordScreenCustomer widget

class NextScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                color: Colors.white,
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Rectangle 1217.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.65,
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.65,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 110),
                      Transform.scale(
                        scale: 1.0,
                        child: Image.asset(
                          'assets/images/chuyendoi.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.55,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    await _postNumber(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 110),
                      Transform.scale(
                        scale: 2.0,
                        child: Image.asset(
                          'assets/images/Group 300.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.08,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 110),
                      Transform.scale(
                        scale: 2.0,
                        child: Image.asset(
                          'assets/images/phone_register.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.67,
                left: 0,
                right: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 55, vertical: 5.0),
                  child: CupertinoTextField(
                    
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: CupertinoColors.black),
                    prefix: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Icon(
                        Icons.phone,
                        color: Color.fromARGB(255, 75, 185, 130),
                      ),
                    ),
                    placeholder: 'Nhập Số Điện Thoại',
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _postNumber(BuildContext context) async {
    final phone = _phoneController.text;

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bạn Phải nhập số điện thoại'),
        ),
      );
      return;
    }

    final url = 'https://api.dannycode.site/API/authentication/login_register';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'phone': phone},
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final message = responseBody['message'];
        final role = responseBody['role'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('phone', phone);
        print('Role: $role');
        if (message == 'login') {
          if (role == "driver") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PasswordScreen()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PasswordScreenCustomer()),
            );
          }
        } else if (message == 'register') {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  OTPScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = Offset(0.5, 0.0);
                var end = Offset.zero;
                var curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
