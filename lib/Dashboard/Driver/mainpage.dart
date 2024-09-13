import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Home/home.dart';
import './PickCar/pickcar.dart';
import './Receive/recieved_car.dart';
import 'History/history.dart';
import 'Profile/profile.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class DashboardDriver extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardDriver> {
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
    return WillPopScope(
      onWillPop: () async {
        // Prevent the app from being popped
        return false;
      },
      child: CupertinoPageScaffold(
        child: Column(
          children: <Widget>[
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: <Widget>[
                  HomePage(onImageTap: () => _onTabTapped(1)),
                  PickCar(),
                  Receive(),
                  HistoryPage(),
                  ProfilePage(),
                ],
              ),
            ),
            // Ensure the CupertinoTabBar remains fixed at the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: CupertinoTabBar(
                backgroundColor: Colors.white,
                activeColor: Color(0xFF40B59F),
                items: [
                  _bottomNavigationBarItem(Icons.home, 'Trang Chủ'),
                  _bottomNavigationBarItem(Icons.car_rental, 'Đặt Xe'),
                  _bottomNavigationBarItem(Icons.list, 'Nhận Xe'),
                  _bottomNavigationBarItem(Icons.history, 'Lịch Sử'),
                  _bottomNavigationBarItem(Icons.person, 'Hồ Sơ'),
                ],
                onTap: _onTabTapped,
                currentIndex: _currentIndex,
              ),
            ),
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
    String url = 'https://api.dantay.vn/api/FCMTokenDriver';
    final response = await http.post(
      Uri.parse(url),
      body: {'FCMToken': '${token}'},
    );
    print(response.body);
  }

  postData();
}
