import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './../../../register/welcome.dart';

class Information extends StatefulWidget {
  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  String name = 'Loading...';
  String phone = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://api.dannycode.site/API/authentication/infoCustom'),
        body: {'accessToken': accessToken},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['coin'] != 'fail') {
          setState(() {
            name = data['coin'];
            phone = data['name'];
          });
        } else {
          // Handle the failure case here
          print('Failed to load profile');
        }
      } else {
        // Handle the error case here
        print('Error fetching profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle:
            Text("Thông Tin Cá Nhân", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF40B59F),
        leading: GestureDetector(
          onTap: () {
            // Handle the back button tap here
            Navigator.of(context).pop();
          },
          child: Container(
            child: Icon(
              CupertinoIcons.back,
              color: Colors.white, // Set the color of the back button
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: CupertinoColors.systemGrey,
                    child: Icon(CupertinoIcons.person, size: 40),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CupertinoTextField(
                      placeholder: 'Họ và tên',
                      prefix: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          CupertinoIcons.person_solid,
                          color: Color(0xFF40B59F),
                        ),
                      ),
                      controller: TextEditingController(text: name),
                      readOnly: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              CupertinoTextField(
                placeholder: 'Số điện thoại',
                prefix:
                    Icon(CupertinoIcons.phone_solid, color: Color(0xFF40B59F)),
                controller: TextEditingController(text: phone),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                keyboardType: TextInputType.phone,
                readOnly: true,
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CupertinoButton(
                      onPressed: () {
                        // Handle Xóa Tài Khoản action
                      },
                      color: CupertinoColors.destructiveRed,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.delete),
                          SizedBox(width: 8),
                          Text('Xóa Tài Khoản'),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    CupertinoButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Welcome()),
                        );
                      },
                      color: CupertinoColors.systemGrey,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.square_arrow_left),
                          SizedBox(width: 8),
                          Text('Đăng Xuất'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
