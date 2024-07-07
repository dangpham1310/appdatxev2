import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './Home/home.dart';
import './PickCar/pickcar.dart';
import 'History/history.dart';
import 'Profile/profile.dart';

void main() {
  runApp(DashboardApp());
}

class DashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

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
