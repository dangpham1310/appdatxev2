import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'congratulation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import './denied.dart';

Future<List<Map<String, dynamic>>> fetchData(String accessToken, String time,
    DateTime datetime, String pickUp, String pickDrop) async {
  // Convert TimeOfDay to string
  final timeString = time.toString();

  // Convert DateTime to ISO8601 string
  final dateString = datetime.toIso8601String();

  final response = await http.post(
    Uri.parse('https://api.dannycode.site/viewlist'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'accessToken': accessToken,
      'time': timeString,
      'date': dateString,
      'pickUp': pickUp,
      'pickDrop': pickDrop,
    }),
  );

  if (response.statusCode == 200) {
    List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(json.decode(response.body));
    return data;
  } else {
    throw Exception('Failed to load data');
  }
}

class ListReceive extends StatefulWidget {
  final String pickUpLocation;
  final String dropOffLocation;
  final TimeOfDay selectedTime;
  final DateTime selectedDate;

  const ListReceive({
    Key? key,
    required this.pickUpLocation,
    required this.dropOffLocation,
    required this.selectedTime,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<ListReceive> createState() => _ListReceiveState();
}

class _ListReceiveState extends State<ListReceive> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      final SendTime = widget.selectedTime.hour.toString() +
          ":" +
          widget.selectedTime.minute.toString();
      if (accessToken != null) {
        final fetchedData = await fetchData(
          accessToken,
          SendTime,
          widget.selectedDate,
          widget.pickUpLocation,
          widget.dropOffLocation,
        );
        setState(() {
          data = fetchedData;
        });
      } else {
        throw Exception('Access token is null');
      }
    } catch (e) {
      print('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "Danh Sách Nhận Xe",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF40B59F),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
        ),
      ),
      child: SafeArea(
        child: data.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return _buildCard(data[index]);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item) {
    return Visibility(
      visible: true,
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            bool? confirm = await showCupertinoDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text(
                    "Xác nhận",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF40B59F),
                    ),
                  ),
                  content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Bạn có chắc chắn muốn nhận chuyến này không?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: Text(
                        "Hủy",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false); // Return false
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text(
                        "Đồng ý",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF40B59F),
                        ),
                      ),
                      onPressed: () {
                        print(item['id']);
                        print(item['price_to_receive']);
                        Navigator.of(context).pop(true); // Return true
                      },
                    ),
                  ],
                );
              },
            );
            if (confirm == true) {
              setState(() {
                data.remove(item); // Remove the card from the list
              });

              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? accessToken = prefs.getString('accessToken');
              String? FCMToken = prefs.getString('FCMToken');

              final response = await http.post(
                Uri.parse('https://api.dannycode.site/received'),
                body: {
                  'accessToken': accessToken,
                  'id': item['id'],
                },
              );

              if (response.body == "Not enough money" ||
                  response.body == "Taken") {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => DeniedPage(),
                  ),
                );
              } else {
                print("FCMToken: $FCMToken");
                print("accessToken: $accessToken");
                print("id: ${item['id']}");

                final response = await http.post(
                  Uri.parse(
                      'https://api.dannycode.site/api/receiveNotification'),
                  body: {
                    'accessToken': accessToken,
                    'id': item['id'],
                    "FCMToken": FCMToken,
                  },
                );

                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => CongratulationPage(item['id']),
                  ),
                );
              }
            }
            return confirm;
          }
          return false;
        },
        background: Container(
          color: Color(0xFF4092B5),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Icon(
            CupertinoIcons.arrow_left_circle_fill,
            color: Colors.white,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF40B59F).withOpacity(0.3),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow(
                          icon: CupertinoIcons.location_fill,
                          text: item['pickUp'],
                        ),
                        SizedBox(height: 5),
                        _buildRow(
                          icon: CupertinoIcons.location_solid,
                          text: item['pickDrop'],
                        ),
                        SizedBox(height: 5),
                        _builTime(
                          icon: CupertinoIcons.time,
                          text: '${item['date']} - Giờ: ${item['time']}',
                        ),
                        SizedBox(height: 5),
                        _buildDoubleRow(
                          icon1: CupertinoIcons.money_dollar_circle,
                          text1: '${item['price']} Nghìn VND',
                          icon2: CupertinoIcons.car_detailed,
                          text2: '${item['numberofSeat']} chỗ',
                        ),
                        SizedBox(height: 5),
                        _buildRow(
                          icon: CupertinoIcons.money_dollar_circle,
                          text:
                              'Tiền Cọc: ${item['price_to_receive']} Nghìn VND',
                          textStyle: TextStyle(color: Colors.red),
                        ),
                        SizedBox(height: 5),
                        _buildRow(
                          icon: CupertinoIcons.text_bubble,
                          text: 'Ghi chú: ${item['note']}',
                          textStyle: TextStyle(color: Colors.blue),
                        ),
                      ],
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

  Widget _buildDoubleRow({
    required IconData icon1,
    required String text1,
    required IconData icon2,
    required String text2,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildRow(
            icon: icon1,
            text: text1,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildRow(
            icon: icon2,
            text: text2,
          ),
        ),
      ],
    );
  }

  Widget _buildRow(
      {required IconData icon, required String text, TextStyle? textStyle}) {
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
            size: 13,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: (textStyle ?? TextStyle()).copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _builTime(
      {required IconData icon, required String text, TextStyle? textStyle}) {
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
            size: 13,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: (textStyle ?? TextStyle(fontWeight: FontWeight.bold))
                .copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
