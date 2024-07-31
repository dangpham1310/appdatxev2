import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatefulWidget {
  final String startPoint;
  final String endPoint;
  final String bookerPhoneNumber;
  final String customerPhoneNumber;
  final int idHistory;

  DetailsPage({
    required this.startPoint,
    required this.endPoint,
    required this.bookerPhoneNumber,
    required this.customerPhoneNumber,
    required this.idHistory,
  });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<Map<String, dynamic>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = fetchDetails(widget.idHistory);
  }

  Future<Map<String, dynamic>> fetchDetails(int idHistory) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.post(
      Uri.parse('https://api.dantay.vn/api/details'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'accessToken': accessToken, 'idHistory': idHistory.toString()},
    );

    print(response.body);

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print(data);
        return data;
      } catch (e) {
        print('Error decoding JSON: $e');
        throw Exception('Failed to decode response');
      }
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Failed to load details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Thông Tin Chi Tiết Chuyến Đi",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF40B59F),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            child: Icon(
              CupertinoIcons.back,
              color: Colors.white,
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _detailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No details found.'));
            } else {
              final details = snapshot.data!;
              final history = details['history'] ?? {};
              final driver = details['driver'] ?? {};

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driver['name'] ?? 'Chưa có tên tài xế',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              driver['vehicleType'] ?? 'Chưa thể hiển thị',
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.grey),
                            ),
                            SizedBox(height: 8.0),
                            Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                driver['numberPlate'] ?? 'Chưa thể hiển thị',
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 24.0,
                              backgroundColor: Colors.grey.shade200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.star_fill,
                                      color: Colors.yellow, size: 18.0),
                                  SizedBox(height: 2.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Thanh toán',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cước phí', style: TextStyle(fontSize: 14.0)),
                        Text('${history['price'] ?? 'N/A'}đ',
                            style: TextStyle(fontSize: 14.0)),
                      ],
                    ),
                    Divider(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Trả qua tiền mặt',
                            style: TextStyle(fontSize: 14.0)),
                        Text('${history['price'] ?? 'N/A'}đ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0)),
                      ],
                    ),
                    Divider(height: 24.0),
                    Text(
                      'Mã chuyến đi: ${history['id'] ?? 'N/A'}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14.0),
                    ),
                    Text(
                      '${history['date'] ?? 'N/A'} | ${history['time'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Icon(CupertinoIcons.location,
                            color: CupertinoColors.systemGrey),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            widget.startPoint,
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Icon(CupertinoIcons.location_solid,
                            color: CupertinoColors.systemYellow),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            widget.endPoint,
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.0),
                    Text(
                      'Số điện thoại người đặt:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      widget.bookerPhoneNumber,
                      style: TextStyle(fontSize: 13.0, color: Colors.grey),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Số điện thoại khách hàng:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      widget.customerPhoneNumber,
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    SizedBox(height: 32.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 12.0),
                          color: CupertinoColors.systemGrey,
                          onPressed: () {
                            // Handle support action
                          },
                          child: Text('Bạn cần hỗ trợ?'),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 12.0),
                          color: CupertinoColors.activeBlue,
                          onPressed: () {
                            _launchCaller(widget.customerPhoneNumber);
                          },
                          child: Text('Liên hệ'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoButton(
                          color: CupertinoColors.systemRed,
                          onPressed: () {
                            // Handle cancel booking action
                          },
                          child: Text('Hủy chuyến',
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _launchCaller(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
