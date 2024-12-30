import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Home/home.dart';
import './PickCar/pickcar.dart';
import 'History/history.dart';
import 'Profile/profile.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardApp extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardApp> {
  int _currentIndex = 0;

  // create init
  @override
  void initState() {
    super.initState();
    RunDashboardDriver();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List pages = [
      HomePage(onImageTap: () => _onTabTapped(1)),
      PickCar(),
      HistoryPage(),
      ProfilePage(),
    ];
    return WillPopScope(
      onWillPop: () async {
        // Prevent the app from being popped
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: false,
        extendBody: false,
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: Colors.white,
          activeColor: Color(0xFF40B59F),
          items: [
            _bottomNavigationBarItem(Icons.home, 'Trang Chủ'),
            _bottomNavigationBarItem(Icons.car_rental, 'Đặt Xe'),
            _bottomNavigationBarItem(Icons.history, 'Lịch Sử'),
            _bottomNavigationBarItem(Icons.person, 'Hồ Sơ'),
          ],
          onTap: _onTabTapped,
          currentIndex: _currentIndex,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: pages[_currentIndex],
            ),
            // Ensure the CupertinoTabBar remains fixed at the bottom

          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
      IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}

void RunDashboardDriver() async {
  Future<void> postData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('FCMToken') ?? '';
    String url = 'https://api.dannycode.site/api/FCMTokenDriver';
    final response = await http.post(
      Uri.parse(url),
      body: {'FCMToken': '${token}'},
    );
    print(response.body);
  }

  postData();
}
