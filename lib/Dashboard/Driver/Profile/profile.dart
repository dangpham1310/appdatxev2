import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'information.dart';
import './historytrans.dart';
import './reference.dart';
import './deAndWi.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'Loading...';
  String coin = '\$100.00';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    name = prefs.getString('name') ?? 'Loading...';
    coin = prefs.getString('coin') ?? '\$100.00';
    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://api.dantay.vn/API/authentication/getCoin'),
        body: {'accessToken': accessToken},
      );
      var data = jsonDecode(response.body);
    }
  }

  Widget buildIconButton(IconData icon, String text, VoidCallback onPressed) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF40B59F).withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.black),
              SizedBox(height: 5),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                color: Color(0xFF40B59F),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "\$" + coin,
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      top: 0, // Adjust to move the icon outside
                      left: MediaQuery.of(context).size.width * 0.5 - 50,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          CupertinoIcons.person_solid,
                          size: 50,
                          color: Color(0xFF40B59F),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          name,
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tiện ích',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildIconButton(Icons.person, 'Thông Tin Cá Nhân', () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => Information(),
                            ),
                          );
                        }),
                        buildIconButton(
                          CupertinoIcons.time,
                          'Lịch Sử Giao Dịch',
                          () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => HistoryTransactionPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildIconButton(
                            CupertinoIcons.group, 'Giới Thiệu Bạn Bè', () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => InvitedFriendsPage(),
                            ),
                          );
                        }),
                        buildIconButton(CupertinoIcons.money_dollar, 'Nạp Rút',
                            () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => NapRutPage(),
                            ),
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Chính Sách',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildIconButton(CupertinoIcons.exclamationmark_circle,
                            'Khiếu Nại', () {}),
                        buildIconButton(
                            CupertinoIcons.doc_text, 'Nội quy', () {}),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildIconButton(CupertinoIcons.lock_shield,
                            'Chính Sách \nBảo Mật', () {}),
                      ],
                    ),
                    SizedBox(height: 20),
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
