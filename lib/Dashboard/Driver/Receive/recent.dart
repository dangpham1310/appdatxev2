import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Recent extends StatefulWidget {
  final Function(String) onLocationPickupSelected;
  final Function(String) onLocationDestinationSelected;

  const Recent({
    super.key,
    required this.onLocationPickupSelected,
    required this.onLocationDestinationSelected,
  });

  @override
  State<Recent> createState() => _RecentState();
}

class _RecentState extends State<Recent> {
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
                    text: 'Hà Nội',
                    onTap: () {
                      widget.onLocationPickupSelected('Hà Nội');
                    },
                  ),
                  SizedBox(height: 10), // Divider between rows
                  _buildRow(
                    icon: CupertinoIcons.location_solid,
                    text: 'Nam Định',
                    onTap: () {
                      widget.onLocationDestinationSelected('Nam Định');
                    },
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
                    text: 'Hải Phòng',
                    onTap: () {
                      widget.onLocationPickupSelected('Hải Phòng');
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buildRow(
                    icon: CupertinoIcons.location_solid,
                    text: 'Đà Nẵng',
                    onTap: () {
                      widget.onLocationDestinationSelected('Đà Nẵng');
                    },
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
                    text: 'Thành Phố Hồ Chí Minh',
                    onTap: () {
                      widget.onLocationPickupSelected('Thành Phố Hồ Chí Minh');
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buildRow(
                    icon: CupertinoIcons.location_solid,
                    text: 'Hải Phòng',
                    onTap: () {
                      widget.onLocationDestinationSelected('Hải Phòng');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
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
      ),
    );
  }


}
