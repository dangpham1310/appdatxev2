import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Dashboard/Customer/mainpage.dart';
import './ForgotPassword/inputphone.dart';

class PasswordScreenCustomer extends StatefulWidget {
  const PasswordScreenCustomer({Key? key}) : super(key: key);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreenCustomer> {
  final TextEditingController _controller = TextEditingController();
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  final FocusNode _focusNode = FocusNode();
  final _scrollController = ScrollController(); // Add ScrollController
  String phone = '';
  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (index) => TextEditingController());
    _focusNodes = List.generate(6, (index) => FocusNode());
    _loadPhone();
  }

  void _loadPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = prefs.getString('phone') ?? '';
    });
  }

  @override
  void _checkOTP() {
    // Concatenate all OTP values entered
    String enteredOTP = _controller.text;
    Future<void> _sendPassword() async {
      final url = 'https://api.dannycode.site/API/authentication/login';

      final response = await http.post(
        Uri.parse(url),
        body: {'phone': phone, 'password': enteredOTP},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['message'] == "logged"){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text('Thông báo'),
                content: Text('Đã Đăng Nhập chỗ khác'),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }

        if (responseBody['accessToken'] != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', responseBody['accessToken']);
          await prefs.setBool('isLoggedInDriver', false); // Set the login flag
          await prefs.setBool('isLoggedInCustomer', true);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardApp()),
          );
        } else {
          if(responseBody['message'] == "logged"){
            return;
          }
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text('Thông báo'),
                content: Text('Mật Khẩu Sai'),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );

        }
      }
    }

    _sendPassword();

    ;
  }

  void forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhoneScreen()),
    );
  }

  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _focusNextField(int index) {
    if (index < _focusNodes.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
  }

  void _focusPreviousField(int index) {
    if (index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  void _deleteValue(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusPreviousField(index);
    }
    _controllers[index].clear();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        // Wrap your Scaffold body with SingleChildScrollView
        body: SingleChildScrollView(
          controller:
          _scrollController, // Assign ScrollController to SingleChildScrollView
          child: Stack(
            children: [
              Container(
                color: Colors.white, // Set background color to white
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1,
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/Rectangle 1217.png'), // VÒng lõm
                    fit: BoxFit.fill, // Adjust the fit as needed
                  ),
                ),
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.65,
              ),

              Positioned(
                top: MediaQuery.of(context).size.height *
                    0.08, // 15% from the top of the screen
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 110,
                      ), // Adjusted the height to accommodate for the moved text
                      Transform.scale(
                        scale: 2.0, // Adjust the scale factor as needed
                        child: Image.asset(
                          'assets/images/OTP.png', // Provide the path to your image asset
                          width: 150, // Adjust the width of the image as needed
                          height:
                          150, // Adjust the height of the image as needed
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
                          color: Colors.black, // Thay đổi màu sắc
                          fontFamily: 'Pacifico', // Sử dụng font chữ đặc biệt
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 240,
                        child: CupertinoTextField(
                          style: TextStyle(color: CupertinoColors.black),
                          controller: _controller,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 6,
                          obscureText: true, // Mask input with dots
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
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height *
                    0.9, // 15% from the top of the screen
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
                top: MediaQuery.of(context).size.height *
                    0.80, // 15% from the top of the screen
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _checkOTP,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor:
                          Color.fromARGB(255, 70, 196, 173), // Text color
                        ),
                        child: Text('Xác Nhận'),
                      )

                      // Adjusted the height to accommodate for the moved text
                    ],
                  ),
                ),
              ),
              // Bạn quên mật khẩu?
            ],
          ),
        ),
      ),
    );
  }
}