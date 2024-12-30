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
    final phone = prefs.getString('phone') ?? '';

    final response = await http.post(
      Uri.parse('https://api.dannycode.site/api/details'),
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
      backgroundColor: Colors.white,
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
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              driver['vehicleType'] ?? 'Chưa thể hiển thị',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
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
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cước phí',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            )),
                        Text('${history['price'] ?? 'N/A'}đ',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Divider(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Trả qua tiền mặt',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            )),
                        Text('${history['price'] ?? 'N/A'} Nghìn VND',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Divider(height: 24.0),
                    Text(
                      'Mã chuyến đi: ${history['id'] ?? 'N/A'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
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
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
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
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.0),
                    Row(children: [
                      Column(
                        children: [
                          Center(
                            child: Text(
                              'Số điện thoại người đặt',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            widget.bookerPhoneNumber,
                            style:
                                TextStyle(fontSize: 13.0, color: Colors.grey),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Center(
                            child: Text(
                              'Số điện thoại khách hàng',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Center(
                            child: Text(
                              widget.customerPhoneNumber,
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.grey),
                            ),
                          )
                        ],
                      )
                    ]),
                    SizedBox(height: 16.0),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Số điện thoại Tài Xế',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            driver["phone"] ?? 'Chưa thể hiển thị',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.0),
                    if (driver["phone"] !=
                        "Chưa có thông tin số điện thoại tài xế") ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 12.0),
                            color: CupertinoColors.systemGrey,
                            onPressed: () {
                              // Handle support action
                              _showSupportDialog(
                                  context, widget.idHistory.toString());
                            },
                            child: Text('Bạn cần hỗ trợ?'),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 12.0),
                            color: CupertinoColors.activeBlue,
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();

                              final phone = prefs.getString('phone') ?? '';
                              if (widget.bookerPhoneNumber != driver["phone"]) {
                                if (phone == driver["phone"]) {
                                  _launchCaller(widget.customerPhoneNumber);
                                } else {
                                  _launchCaller(driver["phone"]);
                                }
                              } else {
                                _launchCaller(widget.customerPhoneNumber);
                              }
                            },
                            child: Text('Liên hệ'),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 16.0),
                    if (history["done"] == false &&
                        history["cancel"] == false) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CupertinoButton(
                            color: CupertinoColors.systemRed,
                            onPressed: () async {
                              bool? confirm = await showCupertinoDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: Text(
                                      "Xác nhận hủy chuyến",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: CupertinoColors.systemRed,
                                      ),
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        "Bạn có chắc chắn muốn hủy chuyến này không?",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: Text(
                                          "Không",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: CupertinoColors.systemBlue,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                              false); // User cancels the dialog
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: Text(
                                          "Có",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: CupertinoColors.systemRed,
                                          ),
                                        ),
                                        onPressed: () {
                                          Future<void> postData() async {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            final accessToken = prefs
                                                    .getString('accessToken') ??
                                                '';
                                            final FCMToken =
                                                prefs.getString('FCMToken') ??
                                                    '';

                                            final response = await http.post(
                                              Uri.parse(
                                                  'https://api.dannycode.site/cancel'),
                                              headers: {
                                                'Content-Type':
                                                    'application/x-www-form-urlencoded',
                                              },
                                              body: {
                                                'accessToken': accessToken,
                                                'id':
                                                    widget.idHistory.toString()
                                              },
                                            );

                                            final response2 = await http.post(
                                              Uri.parse(
                                                  'https://api.dannycode.site/api/cancelNotification'),
                                              headers: {
                                                'Content-Type':
                                                    'application/x-www-form-urlencoded',
                                              },
                                              body: {
                                                'accessToken': accessToken,
                                                'id':
                                                    widget.idHistory.toString(),
                                                "FCMToken": FCMToken
                                              },
                                            );

                                            if (response.statusCode == 200) {
                                              print("it is work");
                                            } else {
                                              print(
                                                  'Error: ${response.statusCode}');
                                              throw Exception(
                                                  'Failed to load details');
                                            }
                                          }

                                          postData();
                                          Navigator.of(context).pop(
                                              true); // User confirms the cancellation
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirm == true) {
                                Navigator.of(context)
                                    .pop(); // Close the current page after cancellation
                              }
                            },
                            child: Text(
                              'Hủy chuyến',
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ]
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

void _showSupportDialog(BuildContext context, String idHistory) {
  // Tạo TextEditingController để quản lý nội dung nhập
  TextEditingController _contentController = TextEditingController();

  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return AnimatedDialog(
        child: CupertinoAlertDialog(
          title: Text(
            'Khiếu nại',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: CupertinoTextField(
            controller: _contentController, // Gắn controller vào TextField
            placeholder:
                'Nhập nội dung khiếu nại của bạn cho chuyến đi $idHistory',
            maxLines: 5,
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: CupertinoColors.systemGrey, width: 1.0),
            ),
            style: TextStyle(fontSize: 16.0, color: CupertinoColors.black),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                'Hủy',
                style: TextStyle(
                  color: CupertinoColors.systemRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                'Gửi',
                style: TextStyle(
                  color: CupertinoColors.activeGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                // Lấy nội dung từ TextField
                String content = _contentController.text;

                if (content.isEmpty) {
                  // Hiển thị thông báo lỗi nếu nội dung rỗng
                  showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text('Lỗi'),
                        content: Text('Vui lòng nhập nội dung khiếu nại.'),
                        actions: [
                          CupertinoDialogAction(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

                // Gửi yêu cầu khiếu nại với idHistory và content
                final response = await http.post(
                  Uri.parse('https://api.dannycode.site/report'),
                  headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                  },
                  body: {
                    'idHistory': idHistory,
                    'content': content,
                  },
                );

                Navigator.of(context).pop(); // Đóng dialog sau khi gửi

                // Hiển thị thông báo cảm ơn
                _showThankYouDialog(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

void _showThankYouDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return AnimatedDialog(
        child: CupertinoAlertDialog(
          title: Text(
            'Cảm ơn',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Cảm ơn bạn đã gửi khiếu nại. Chúng tôi sẽ xem xét và phản hồi sớm nhất có thể.',
            style: TextStyle(fontSize: 16.0),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                'OK',
                style: TextStyle(
                  color: CupertinoColors.activeBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog cảm ơn
              },
            ),
          ],
        ),
      );
    },
  );
}

class AnimatedDialog extends StatefulWidget {
  final Widget child;

  const AnimatedDialog({Key? key, required this.child}) : super(key: key);

  @override
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    )..forward();

    _scaleAnimation =
        Tween<double>(begin: 0.9, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
