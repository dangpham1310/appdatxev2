import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

Future<List<Map<String, dynamic>>> fetchRecentHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken') ?? '';

  final response = await http.post(
    Uri.parse('https://api.dantay.vn/api/recentpickcar'),
    body: {'accessToken': accessToken},
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load recent history');
  }
}

class Recent extends StatefulWidget {
  const Recent({super.key});

  @override
  State<Recent> createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  late Future<List<Map<String, dynamic>>> _recentHistoryFuture;

  @override
  void initState() {
    super.initState();
    _recentHistoryFuture = fetchRecentHistory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context)
            .size
            .height, // Set the height of the container
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _recentHistoryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No recent history found.'));
            } else {
              List<Map<String, dynamic>> recentHistory = snapshot.data!;

              return SingleChildScrollView(
                child: Column(
                  children: recentHistory.take(3).map((history) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
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
                              text: 'Điểm Đón: ${history['pickUp']}',
                            ),
                            SizedBox(height: 10),
                            _buildRow(
                              icon: CupertinoIcons.location_solid,
                              text: 'Điểm Đến: ${history['pickDrop']}',
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildRow({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: CupertinoColors.black,
              fontSize: 17,
            ),
            maxLines: 3, // Limit to 3 lines
            overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
          ),
        ),
      ],
    );
  }
}
