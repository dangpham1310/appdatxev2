import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Dashboard/Driver/mainpage.dart';
import './ForgotPassword/inputphone.dart';


class PasswordScreen extends StatefulWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String phone = '';

  @override
  void initState() {
    super.initState();
    _loadPhone();
  }

  void forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhoneScreen()),
    );
  }

  Future<void> _loadPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = prefs.getString('phone') ?? '';
    });
  }

  void _checkOTP() async {
    String enteredOTP = _controller.text;
    final url = 'https://api.dannycode.site/API/authentication/login';
    final response = await http.post(Uri.parse(url), body: {
      'phone': phone,
      'password': enteredOTP,
    });
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (responseBody['message'] == "logged"){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã Đăng Nhập Nơi Khác'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (responseBody['message'] != "fail") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', responseBody['accessToken']);
      await prefs.setString("name", responseBody['name']);
      await prefs.setString("coin", responseBody['coin'].toString());
      await prefs.setInt("loadFirstTime", 1);
      await prefs.setBool('isLoggedInDriver', true); // Set the login flag
      await prefs.setBool('isLoggedInCustomer', false); // Set the login flag

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardDriver()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mật Khẩu Sai'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: SingleChildScrollView(
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
                top: MediaQuery.of(context).size.height *
                    0.85, // 15% from the top of the screen
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: forgotPassword,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor:
                              Color.fromARGB(255, 255, 255, 255), // Text color
                        ),
                        child: Text('Quên mật khẩu?'),
                      )

                      // Adjusted the height to accommodate for the moved text
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
                        'Vui lòng nhập Mật Khẩu',
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
                          controller: _controller,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 6,
                          obscureText: true, // Mask the input with dots
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _checkOTP,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Color.fromARGB(255, 70, 196, 173),
                        ),
                        child: Text('Xác Nhận'),
                      ),
                    ],
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
