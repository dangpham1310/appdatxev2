import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Dashboard/Customer/mainpage.dart';

class PasswordScreenCustomer extends StatefulWidget {
  const PasswordScreenCustomer({Key? key}) : super(key: key);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreenCustomer> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
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
    String enteredOTP =
        _controllers.map((controller) => controller.text).join();

    ;
    Future<void> _sendPassword() async {
      final url = 'https://api.dantay.vn/API/authentication/login';

      final response = await http.post(
        Uri.parse(url),
        body: {'phone': phone, 'password': enteredOTP},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['accessToken'] != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', responseData['accessToken']);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardApp()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Mật Khẩu không đúng'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xảy ra lỗi'),
          ),
        );
      }
    }

    _sendPassword();

    ;
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
                    0.65, // 15% from the top of the screen
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
                        scale: 1.0, // Adjust the scale factor as needed
                        child: Image.asset(
                          'assets/images/trangthaicuoi.png', // Provide the path to your image asset
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // TextFields for OTP input
                          for (int i = 0; i < 6; i++)
                            GestureDetector(
                              onTap: () {
                                _focusNodes[i].requestFocus();
                              },
                              child: Container(
                                width: 40,
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: CupertinoTextField(
                                  controller: _controllers[i],
                                  focusNode: _focusNodes[i],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      _focusPreviousField(i);
                                    } else {
                                      _focusNextField(i);
                                    }
                                  },
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                        ],
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
            ],
          ),
        ),
      ),
    );
  }
}
