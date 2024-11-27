import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';
import './delete_account.dart';
import 'package:image/image.dart' as img;
import './../../../register/welcome.dart';

class Information extends StatefulWidget {
  const Information({Key? key}) : super(key: key);

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  late String accessToken;
  late Map<String, dynamic> driverInfo;
  int isFirstLoad = 0;

  @override
  void initState() {
    super.initState();
    driverInfo = {};
    _loadProfile();
  }

  void _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken') ?? '';
    isFirstLoad = prefs.getInt("loadFirstTime") ?? 1;
    if (isFirstLoad == 1) {
      // Fetch driver information using accessToken for the first time
      _fetchDriverInfo();
      prefs.setInt("loadFirstTime", 0);
    } else {
      // Load driver information from cache
      _loadCachedDriverInfo();
    }
  }

  void _fetchDriverInfo() async {
    final url = 'https://api.dannycode.site/API/authentication/reload';
    final response = await http.post(
      Uri.parse(url),
      body: {'accessToken': accessToken},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['message'] != "fail") {
        setState(() {
          driverInfo = responseBody; // Update driverInfo with fetched data
          _cacheDriverInfo(driverInfo);
        });
        _saveImagesPermanently();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch profile data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _loadCachedDriverInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedDriverInfo = prefs.getString('driverInfo');

    if (cachedDriverInfo != null) {
      setState(() {
        driverInfo = jsonDecode(cachedDriverInfo);
      });
    } else {
      // If no cached data is found, fetch from the server
      _fetchDriverInfo();
    }
  }

  void _cacheDriverInfo(Map<String, dynamic> info) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('driverInfo', jsonEncode(info));
  }

  Future<void> _saveImagesPermanently() async {
    final directory = await getApplicationDocumentsDirectory();
    final dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 100),
        receiveTimeout: Duration(seconds: 100), // 100 seconds
      ),
    );

    await _downloadAndSaveImage(dio, driverInfo['driverLicenseFrontUrl'],
        '${directory.path}/driverLicenseFront.png');
    await _downloadAndSaveImage(dio, driverInfo['driverLicenseBackUrl'],
        '${directory.path}/driverLicenseBack.png');
    await _downloadAndSaveImage(
        dio, driverInfo['carFrontUrl'], '${directory.path}/carFront.png');
    await _downloadAndSaveImage(
        dio, driverInfo['carBackUrl'], '${directory.path}/carBack.png');
  }

  Future<void> _downloadAndSaveImage(Dio dio, String url, String path) async {
    if (url != null && url.isNotEmpty) {
      try {
        final response = await dio.get(url,
            options: Options(responseType: ResponseType.bytes));
        final imageFile = File(path);
        imageFile.writeAsBytesSync(response.data);
      } catch (e) {
        print('Error downloading image: $e');
      }
    }
  }

  Future<File?> _loadImage(String imageName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$imageName.png';
    final imageFile = File(filePath);
    if (await imageFile.exists()) {
      return imageFile;
    }
    return null;
  }

  void _reloadDriverInfo() async {
    final url = 'https://api.dannycode.site/API/authentication/reload';
    final response = await http.post(
      Uri.parse(url),
      body: {'accessToken': accessToken},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['message'] != "fail") {
        setState(() {
          driverInfo = responseBody; // Update driverInfo with fetched data
          _cacheDriverInfo(driverInfo);
        });
        _saveImagesPermanently();

        // Update loadFirstTime to 1
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('loadFirstTime', 1);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reload profile data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reload profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> clearCache() async {
    // Clear image cache
    PaintingBinding.instance.imageCache.clear();
    // Optionally, also clear network image cache if used
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "Thông Tin Cá Nhân",
          style: TextStyle(color: Colors.white),
        ),
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
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: CupertinoColors.systemGrey,
                    child: Icon(CupertinoIcons.person, size: 40),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CupertinoTextField(
                      placeholder: 'Họ và tên',
                      prefix: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          CupertinoIcons.person_solid,
                          color: Color(0xFF40B59F),
                        ),
                      ),
                      controller:
                          TextEditingController(text: driverInfo['name']),
                      readOnly: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    Icon(CupertinoIcons.location_solid,
                        color: Color(0xFF40B59F)),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Địa chỉ: ${driverInfo['address'] ?? ''}',
                        style: TextStyle(
                          color: CupertinoColors.inactiveGray,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {},
              ),
              CupertinoTextField(
                placeholder: 'Số điện thoại',
                prefix:
                    Icon(CupertinoIcons.phone_solid, color: Color(0xFF40B59F)),
                controller:
                    TextEditingController(text: driverInfo['phone'] ?? ''),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                keyboardType: TextInputType.phone,
                readOnly: true,
              ),
              SizedBox(height: 20),
              Text('Thông tin xe',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(CupertinoIcons.car_detailed, color: Color(0xFF40B59F)),
                  SizedBox(width: 5),
                  Text('Tên Xe: ${driverInfo['vehicleType'] ?? ''}'),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Icon(CupertinoIcons.number, color: Color(0xFF40B59F)),
                  SizedBox(width: 5),
                  Text('Biển Số Xe: ${driverInfo['numberPlate'] ?? ''}'),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Icon(CupertinoIcons.person_2, color: Color(0xFF40B59F)),
                  SizedBox(width: 5),
                  Text(
                    'Số chỗ: ${driverInfo['vehicleSeat'] == "0" ? "4 chỗ" : driverInfo['vehicleSeat'] == "1" ? "7 chỗ" : ''}',
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 20),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CupertinoButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Thông báo'),
                              content: Text(
                                  'Vui lòng liên hệ với tổng đài để xóa tài khoản.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Đóng dialog
                                  },
                                  child: Text('Đóng'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      color: CupertinoColors.destructiveRed,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.delete),
                          SizedBox(width: 8),
                          Text('Xóa Tài Khoản'),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    CupertinoButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        // Preserve the FCM Token
                        String? fcmToken = prefs.getString('FCMToken');
                        print("FCM Token: $fcmToken");
                        // Clear all other data
                        await prefs.clear();

                        // Restore the FCM Token
                        if (fcmToken != null) {
                          await prefs.setString('FCMToken', fcmToken);
                          print('FCM Token preserved: $fcmToken');
                        }

                        await clearCache(); // Clear app cache if needed

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Welcome()),
                        );
                      },
                      color: CupertinoColors.systemGrey,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.square_arrow_left),
                          SizedBox(width: 8),
                          Text('Đăng Xuất'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imageName, String placeholder) {
    return FutureBuilder<File?>(
      future: _loadImage(imageName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.file(
              snapshot.data!,
              width: 150,
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                _reloadDriverInfo(); // Reload driver info if image fails to load
                return Container(
                  width: 150,
                  height: 150,
                  color: CupertinoColors.systemGrey,
                  child: Icon(
                    CupertinoIcons.clear,
                    size: 50,
                    color: CupertinoColors.white,
                  ),
                );
              },
            );
          } else {
            return Container(
              width: 150,
              height: 150,
              color: CupertinoColors.systemGrey,
              child: Icon(
                CupertinoIcons.clear,
                size: 50,
                color: CupertinoColors.white,
              ),
            );
          }
        } else {
          return Container(
            width: 150,
            height: 150,
            color: CupertinoColors.systemGrey,
            child: CupertinoActivityIndicator(),
          );
        }
        ;
      },
    );
  }
}
