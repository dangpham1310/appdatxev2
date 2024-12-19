import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import './inputOTP.dart';
// Import your PasswordScreenCustomer widget

class PhoneScreen extends StatelessWidget {
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
                top: MediaQuery.of(context).size.height * 0.8,
                left: 30,
                right: 30,
                child: GestureDetector(
                  onTap: () async {
                    await _postNumber(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'Gửi OTP tới số điện thoại',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                    style: TextStyle(color: CupertinoColors.black),
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
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

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(phone: phone),
        ),
      );
  }
}
