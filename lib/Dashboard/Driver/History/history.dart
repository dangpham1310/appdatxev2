import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './detailHistory.dart';

class History {
  final int id;
  final String date;
  final String time;
  final String pickUp;
  final String pickDrop;
  final double price;
  final String phonenumber;
  final String phonenumberpick;
  final String driverPhone;
  final bool cancel;
  final bool done;

  History({
    required this.id,
    required this.date,
    required this.time,
    required this.pickUp,
    required this.pickDrop,
    required this.price,
    required this.phonenumber,
    required this.phonenumberpick,
    required this.driverPhone,
    required this.cancel,
    required this.done,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      date: json['date'].toString(),
      time: json['time'].toString(),
      pickUp: json['pickUp'].toString(),
      pickDrop: json['pickDrop'].toString(),
      price: (json['price'] as num).toDouble(),
      phonenumber: json['phonenumber'].toString(),
      phonenumberpick: json['phonenumberpick'].toString(),
      driverPhone: json['driverPhone'].toString(),
      cancel: json['cancel'],
      done: json['done'],
    );
  }
}

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<History> historyList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    final response = await http.post(
      Uri.parse('https://api.dantay.vn/api/history'),
      body: {'accessToken': accessToken},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        historyList = data.map((json) => History.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load history');
    }
  }

  Future<void> refreshHistory() async {
    setState(() {
      isLoading = true;
    });
    await fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: isLoading
            ? Center(child: CupertinoActivityIndicator())
            : CustomScrollView(
                slivers: <Widget>[
                  CupertinoSliverRefreshControl(
                    onRefresh: refreshHistory,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        History history = historyList[index];
                        String status;
                        Color statusColor;
                        print(history.cancel);
                        if (history.done) {
                          status = 'Hoàn thành';
                          statusColor = Color(0xFF40A7B5);
                        } else if (history.cancel) {
                          status = 'Hủy';
                          statusColor = CupertinoColors.systemRed;
                        } else if (history.driverPhone.length > 6) {
                          status = 'Đã nhận';
                          statusColor = CupertinoColors.activeGreen;
                        } else {
                          status = 'Chưa nhận';
                          statusColor = CupertinoColors.systemYellow;
                        }

                        return Column(
                          children: [
                            buildHistoryCard(
                              context: context,
                              status: status,
                              statusColor: statusColor,
                              startPoint: history.pickUp,
                              endPoint: history.pickDrop,
                              date: history.date,
                              phonenumber: history.phonenumber,
                              phonenumberpick: history.phonenumberpick,
                              idHistory: history.id,
                            ),
                            SizedBox(height: 3.0),
                          ],
                        );
                      },
                      childCount: historyList.length,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildStatusWidget(String status, Color statusColor) {
    return Positioned(
      top: 8.0,
      right: 8.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          status,
          style: TextStyle(color: CupertinoColors.white, fontSize: 12.0),
        ),
      ),
    );
  }

  Widget buildHistoryCard({
    required BuildContext context,
    required String status,
    required Color statusColor,
    required String startPoint,
    required String endPoint,
    required String date,
    required String phonenumber,
    required String phonenumberpick,
    required int idHistory,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0), // Add margin here
      child: Stack(
        children: [
          Container(
            margin:
                EdgeInsets.only(top: 8.0), // To ensure status is not clipped
            padding: EdgeInsets.only(left: 15.0, bottom: 0.0),
            decoration: BoxDecoration(
              color: Color(0xFF40B59F).withOpacity(0.3),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 24.0), // Space for the status widget
                Row(
                  children: [
                    Icon(CupertinoIcons.calendar,
                        color: CupertinoColors.systemGrey),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        date,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0), // Space between date and pickup point
                Row(
                  children: [
                    Icon(CupertinoIcons.location,
                        color: CupertinoColors.systemGrey),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        startPoint,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(CupertinoIcons.location_solid,
                        color: CupertinoColors.systemGrey),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        endPoint,
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => DetailsPage(
                            startPoint: startPoint,
                            endPoint: endPoint,
                            bookerPhoneNumber: phonenumberpick,
                            customerPhoneNumber: phonenumber,
                            idHistory: idHistory,
                          ),
                        ),
                      );
                    },
                    child: Text('Chi tiết >',
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          buildStatusWidget(status, statusColor),
        ],
      ),
    );
  }
}

void main() {
  runApp(CupertinoApp(
    home: HistoryPage(),
  ));
}
