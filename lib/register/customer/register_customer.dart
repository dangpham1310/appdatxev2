import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_reminder/Dashboard/Customer/mainpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerInput extends StatefulWidget {
  const CustomerInput({Key? key}) : super(key: key);

  @override
  _CustomerInputState createState() => _CustomerInputState();
}

class _CustomerInputState extends State<CustomerInput> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referencePhoneController = TextEditingController();
  String phone = "";

  @override
  void initState() {
    super.initState();
    _loadPhone();
  }

  Future<void> _loadPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = prefs.getString('phone') ?? '';
    });
  }

  void _validateInputs() async {
    String errorMessage = '';
    if (_nameController.text.isEmpty) {
      errorMessage = 'Vui lòng điền đầy đủ thông tin';
    } else if (_passwordController.text.isEmpty) {
      errorMessage = 'Vui lòng nhập mật khẩu';
    } else if (_confirmPasswordController.text.isEmpty) {
      errorMessage = 'Vui lòng xác nhận mật khẩu';
    } else if (_passwordController.text != _confirmPasswordController.text) {
      errorMessage = 'Mật khẩu và xác nhận mật khẩu không khớp';
    }

    if (errorMessage.isNotEmpty) {
      _showErrorDialog(errorMessage);
    } else {
      bool success = await _saveData();
      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardApp(),
          ),
        );
      } else {
        _showErrorDialog('Đăng ký thất bại. Vui lòng thử lại.');
      }
    }
  }

  Future<bool> _saveData() async {
    try {
      var uri = Uri.parse(
          'https://api.dannycode.site/API/authentication/create_customer');
      var response = await http.post(uri, body: {
        'phone': phone,
        'name': _nameController.text,
        'password': _passwordController.text,
        'reference': _referencePhoneController.text,
      });

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', jsonResponse['accessToken']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Lỗi'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            // Nền giao diện
            Column(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Transform.scale(
                        scale: 1,
                        child: Image.asset(
                          'assets/images/Group 11.png',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 0.0),
                          Text(
                            'Nhập thông tin cá nhân',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          CupertinoTextField(
                            style: TextStyle(color: CupertinoColors.black),
                            controller: _nameController,
                            placeholder: 'Họ Và Tên',
                            keyboardType: TextInputType.text,
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            "Nhập Mật Khẩu",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.blueGrey[600]),
                          ),
                          SizedBox(height: 10.0), // SizedBox to add spacing
                          CupertinoTextField(
                            style: TextStyle(color: CupertinoColors.black),
                            controller: _passwordController,
                            placeholder: 'Mật Khâu',
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            maxLength: 6,
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            "Xác Nhận Mật Khẩu",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.blueGrey[600]),
                          ),
                          SizedBox(height: 10.0),
                          CupertinoTextField(
                            style: TextStyle(color: CupertinoColors.black),
                            controller: _confirmPasswordController,
                            placeholder: 'Xác Nhận Mật Khẩu',
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            maxLength: 6,
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Center(
                            child: CupertinoTextField(
                              style: TextStyle(color: CupertinoColors.black),
                              controller: _referencePhoneController,
                              placeholder: 'Số Điện Thoại Người Giới Thiệu',
                              keyboardType: TextInputType.number,
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Center(
                            child: CupertinoButton(
                              onPressed: _validateInputs,
                              color: Color(0xFF40B59F),
                              child: Text(
                                'Tiếp Theo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0), // Add some space
                          Center(
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                'Bằng cách bấm Tiếp Theo, tôi đồng ý với điều khoản và điều kiện của ứng dụng',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Nút Back
            Positioned(
              top: 20, // Adjust vị trí dưới thanh trạng thái
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
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referencePhoneController.dispose();
    super.dispose();
  }
}
