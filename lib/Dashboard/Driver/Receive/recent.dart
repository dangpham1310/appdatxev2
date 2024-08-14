import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  List<Map<String, String>> recentLocations = [];

  @override
  void initState() {
    super.initState();
    fetchRecentLocations();
  }

  Future<void> fetchRecentLocations() async {
    final prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString('phone') ?? '';

    final response = await http.post(
      Uri.parse('https://api.dantay.vn/api/getRecent'),
      body: {'phone': phone},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        recentLocations = data
            .map((json) => {
                  'pickUp': json['pickUp'].toString(),
                  'pickDrop': json['pickDrop'].toString(),
                })
            .toList();
      });
    } else {
      throw Exception('Failed to load recent locations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            if (recentLocations.isNotEmpty)
              ...recentLocations.map((location) => Container(
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
                          text: location['pickUp'] ?? '',
                          onTap: () {
                            widget.onLocationPickupSelected(
                                location['pickUp'] ?? '');
                          },
                        ),
                        SizedBox(height: 10),
                        _buildRow(
                          icon: CupertinoIcons.location_solid,
                          text: location['pickDrop'] ?? '',
                          onTap: () {
                            widget.onLocationDestinationSelected(
                                location['pickDrop'] ?? '');
                          },
                        ),
                      ],
                    ),
                  ))
            else
              Center(
                child: Text(
                  'No recent locations found.',
                  style: TextStyle(
                      fontSize: 16, color: CupertinoColors.systemGrey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
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
              size: 16,
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

void main() {
  runApp(CupertinoApp(
    home: Scaffold(
      body: Recent(
        onLocationPickupSelected: (pickup) => print('Pickup: $pickup'),
        onLocationDestinationSelected: (destination) =>
            print('Destination: $destination'),
      ),
    ),
  ));
}
