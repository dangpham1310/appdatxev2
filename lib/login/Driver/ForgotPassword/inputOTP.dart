import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './newpassword.dart';

class OTPScreen extends StatefulWidget {
  final String phone;

  const OTPScreen({Key? key, required this.phone}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), sendOTPfromServer);
  }

  Future<void> sendOTPfromServer() async {
    var url = Uri.parse(
        'https://api.dannycode.site/API/authentication/forgotpassword/${widget.phone}');
    await http.post(url);
  }

  Future<void> _checkOTP() async {
    String enteredOTP = _otpController.text;
    if (enteredOTP.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP phải có 6 chữ số.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    var url =
        Uri.parse('https://api.dannycode.site/API/authentication/checkOTP');
    var response =
        await http.post(url, body: {'phone': widget.phone, 'OTP': enteredOTP});

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse["message"] == "success") {
        // Handle success logic here
        // save OTP to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('OTP', enteredOTP);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordResetScreen(phone: widget.phone),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP Không Chính Xác. Vui Lòng Thử Lại.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Server error. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Stack(
            children: [
              Container(
                color: Colors.white,
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1,
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
                          'assets/images/trangthaicuoi.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 40, // Adjust vị trí dưới thanh trạng thái
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
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
                          'assets/images/OTP.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.65,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Vui lòng nhập OTP đã được gửi qua Zalo',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Pacifico',
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: 240,
                        child: CupertinoTextField(
                          style: TextStyle(color: CupertinoColors.black),
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.80,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: _checkOTP,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Color.fromARGB(255, 70, 196, 173),
                    ),
                    child: Text('Xác Nhận OTP'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
