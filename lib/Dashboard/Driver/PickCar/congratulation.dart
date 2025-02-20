import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // For jsonEncode
// import '../Customer/mainpage.dart'; // Adjust the import path as needed
import '../mainpage.dart';

class PickCarDone extends StatefulWidget {
  final String tripDate;
  final String tripTime;
  final String pickupPoint;
  final String destination;
  final String seats; // Number of seats
  final String notes; // Additional notes
  final String price; // Trip price
  final String accessToken; // Access token
  final String FCMToken; // FCM token

  PickCarDone({
    required this.tripDate,
    required this.tripTime,
    required this.pickupPoint,
    required this.destination,
    required this.seats,
    required this.notes,
    required this.price,
    required this.accessToken, // Accept accessToken as parameter
    required this.FCMToken, // Accept FCMToken as parameter
  });

  @override
  _PickCarDoneState createState() => _PickCarDoneState();
}

class _PickCarDoneState extends State<PickCarDone> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to disable the back button
        return false;
      },
      child: CupertinoApp(
        home: CupertinoPageScaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          navigationBar: CupertinoNavigationBar(
            middle: Text(
              'Chi Tiết Chuyến Đi',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.teal,
            // Disable the leading back button in the navigation bar
            automaticallyImplyLeading: false,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: Colors.teal,
                    size: 100,
                  ),
                ),
                SizedBox(height: 30),
                tripDetailRow(
                  icon: CupertinoIcons.calendar,
                  label: 'Ngày:',
                  value: widget.tripDate,
                ),
                tripDetailRow(
                  icon: CupertinoIcons.time,
                  label: 'Giờ:',
                  value: widget.tripTime,
                ),
                tripDetailRow(
                  icon: CupertinoIcons.location,
                  label: 'Điểm Đi:',
                  value: widget.pickupPoint,
                ),
                tripDetailRow(
                  icon: CupertinoIcons.location_solid,
                  label: 'Điểm Đón:',
                  value: widget.destination,
                ),
                tripDetailRow(
                  icon: CupertinoIcons.person_2,
                  label: 'Số Ghế:',
                  value: widget.seats,
                ), // Number of seats
                tripDetailRow(
                  icon: CupertinoIcons.money_dollar,
                  label: 'Giá:',
                  value: '${widget.price} VND',
                ), // Trip price
                SizedBox(height: 20),
                Text(
                  'Ghi Chú:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.notes,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(
                            builder: (context) => DashboardDriver()),
                        (route) => false,
                      );
                    },
                    color: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    borderRadius: BorderRadius.circular(8),
                    child: Text(
                      'Quay Lại Trang Chủ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tripDetailRow(
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.teal,
            size: 24,
          ),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
