import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import để dùng FilteringTextInputFormatter
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../register/phone_screen.dart';

class PasswordResetScreen extends StatefulWidget {
  final String phone;

  const PasswordResetScreen({Key? key, required this.phone}) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _scrollController = ScrollController();

  Future<void> _resetPassword() async {
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng nhập đầy đủ mật khẩu và xác nhận mật khẩu.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mật khẩu xác nhận không khớp.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mật khẩu phải là 6 số.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? otp = prefs.getString('OTP');

    var url =
        Uri.parse('https://api.dannycode.site/API/authentication/setpassword');
    var response = await http.post(url,
        body: {'phone': widget.phone, 'password': password, 'OTP': otp});

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NextScreen()),
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse["message"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Đặt lại mật khẩu thành công. vui lòng đăng nhập lại'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra. Vui lòng thử lại.'),
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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                        'Vui lòng nhập mật khẩu mới của bạn',
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
                          controller: _passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          placeholder: 'Mật khẩu mới',
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 240,
                        child: CupertinoTextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          placeholder: 'Xác nhận mật khẩu',
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
                top: MediaQuery.of(context).size.height * 0.85,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: _resetPassword,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Color.fromARGB(255, 70, 196, 173),
                    ),
                    child: Text('Xác Nhận'),
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
