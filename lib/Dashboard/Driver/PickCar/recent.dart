import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Recent extends StatefulWidget {
  const Recent({super.key});

  @override
  State<Recent> createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  final String pickUpPoint = "Địa chỉ điểm đón";
  final String destination = "Địa chỉ điểm đến";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: CupertinoColors.white),
              ),
              child: Column(
                children: [
                  _buildRow(
                    icon: CupertinoIcons.location_fill,
                    text: 'Điểm Đón: $pickUpPoint',
                  ),
                  SizedBox(height: 10), // Divider between rows
                  _buildRow(
                    icon: CupertinoIcons.location_solid,
                    text: 'Điểm Đến: $destination',
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: CupertinoColors.white),
              ),
              child: Column(
                children: [
                  _buildRow(
                    icon: CupertinoIcons.location_fill,
                    text: 'Điểm Đón: $pickUpPoint',
                  ),
                  // Divider between rows
                  SizedBox(
                    height: 10,
                  ),
                  _buildRow(
                    icon: CupertinoIcons.location_solid,
                    text: 'Điểm Đến: $destination',
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: CupertinoColors.white),
              ),
              child: Column(
                children: [
                  _buildRow(
                    icon: CupertinoIcons.location_fill,
                    text: 'Điểm Đón: $pickUpPoint',
                  ),
// Divider between rowss
                  SizedBox(
                    height: 10,
                  ),
                  _buildRow(
                    icon: CupertinoIcons.location_solid,
                    text: 'Điểm Đến: $destination',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: CupertinoColors.systemGrey),
            color: Color(0xFF40B59F),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 16, // Adjust icon size here
          ),
        ),
        SizedBox(width: 30),
        Text(
          text,
          style: TextStyle(
            color: CupertinoColors.black,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}
