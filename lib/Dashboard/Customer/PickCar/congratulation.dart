import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../../Driver/mainpage.dart'; // Adjust the import path as needed

class PickCarDone extends StatelessWidget {
  final String tripDate;
  final String tripTime;
  final String pickupPoint;
  final String destination;

  final String seats; // Number of seats
  final String notes; // Additional notes
  final String price; // Trip price

  PickCarDone({
    required this.tripDate,
    required this.tripTime,
    required this.pickupPoint,
    required this.destination,
    required this.seats,
    required this.notes,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoPageScaffold(
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
                value: tripDate,
              ),
              tripDetailRow(
                icon: CupertinoIcons.time,
                label: 'Giờ:',
                value: tripTime,
              ),
              tripDetailRow(
                icon: CupertinoIcons.location,
                label: 'Điểm Đi:',
                value: pickupPoint,
              ),
              tripDetailRow(
                icon: CupertinoIcons.location_solid,
                label: 'Điểm Đón:',
                value: destination,
              ),

              tripDetailRow(
                icon: CupertinoIcons.person_2,
                label: 'Số Ghế:',
                value: seats,
              ), // Number of seats
              tripDetailRow(
                icon: CupertinoIcons.money_dollar,
                label: 'Giá:',
                value: '$price VND',
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
                notes,
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
