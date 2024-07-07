import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatelessWidget {
  final String startPoint;
  final String endPoint;

  final String DriverPhoneNumber;

  DetailsPage({
    required this.startPoint,
    required this.endPoint,
    r,
    required this.DriverPhoneNumber,
  });

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
        child: SingleChildScrollView(
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
                        'Phạm Thiên Đăng',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Mercedes-Benz E200',
                        style: TextStyle(fontSize: 14.0, color: Colors.grey),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          '51A-12345',
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cước phí', style: TextStyle(fontSize: 14.0)),
                  Text('115.000đ', style: TextStyle(fontSize: 14.0)),
                ],
              ),
              Divider(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Trả qua tiền mặt', style: TextStyle(fontSize: 14.0)),
                  Text('115.000đ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14.0)),
                ],
              ),
              Divider(height: 24.0),
              Text(
                'Mã chuyến đi: 832317303',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
              Text(
                '18/06/2024 | 21:29',
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
                      startPoint,
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
                      endPoint,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.0),
              Text(
                'Số điện thoại Tài Xế',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
              ),
              SizedBox(height: 4.0),
              Text(
                DriverPhoneNumber,
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                    color: CupertinoColors.systemGrey,
                    onPressed: () {
                      // Handle support action
                    },
                    child: Text('Bạn cần hỗ trợ?'),
                  ),
                  CupertinoButton(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                    color: CupertinoColors.activeBlue,
                    onPressed: () {
                      _launchCaller(DriverPhoneNumber);
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
