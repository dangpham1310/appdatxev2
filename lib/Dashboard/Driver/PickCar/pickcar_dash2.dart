import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "./congratulation.dart";
import 'package:flutter/services.dart';

class PickCarDash2 extends StatefulWidget {
  @override
  _PickCarDash2State createState() => _PickCarDash2State();
}

class _PickCarDash2State extends State<PickCarDash2> {
  TextEditingController _priceController = TextEditingController();
  TextEditingController _phonenumberController = TextEditingController();
  TextEditingController _phonenumberpickController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  String phone = '';
  String selectedSeat = ''; // Default selected seat number
  double distance = 0.0; // Default distance
  int price = 0; // Default price
  double constPrice = 0.0; // Default price
  @override
  void initState() {
    super.initState();
    _initializeSavedRole();
  }

  Future<double> postData(double currentDistance) async {
    final prefs = await SharedPreferences.getInstance();
    String url = 'https://api.dannycode.site/api/price';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'distance': '${currentDistance / 1000}',
        "pickUp": prefs.getString('pickUp') ?? "",
        "pickDrop": prefs.getString('pickDrop') ?? "",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> parsedJson = json.decode(response.body);
      print(
          'Distance: ${currentDistance / 1000} - Price: ${parsedJson['price']}');
      return parsedJson['price'];
    }
    throw Exception('Failed to load data');
  }

  Future<void> _initializeSavedRole() async {
    final prefs = await SharedPreferences.getInstance();
    double savedDistance = prefs.getDouble('distance') ?? 0.0;
    double fetchedPrice = await postData(savedDistance);
    final accessToken = prefs.getString('accessToken');
    phone = await prefs.getString('phone') ?? '';
    int roundedPrice = fetchedPrice.round(); // Convert to integer by rounding

    setState(() {
      distance = savedDistance;
      price = roundedPrice; // Convert back to double if needed
      constPrice = fetchedPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        middle: Text("Thông Tin Chi Tiết Chuyến Đi",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF40B59F),
        leading: GestureDetector(
          onTap: () {
            // Handle the back button tap here
            Navigator.of(context).pop();
          },
          child: Container(
            child: Icon(
              CupertinoIcons.back,
              color: Colors.white, // Set the color of the back button
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First row: Banner for ads
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.blue.shade700),
                  ),
                  child: Center(
                    child: Text(
                      'Banner Ads',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF40B59F),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.blue.shade700),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'Giá ước lượng: $price nghìn VND',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(height: 5),
                        _buildDropdownButton(),
                        SizedBox(height: 5),
                        _buildPriceTextField(),
                        SizedBox(height: 5),
                        _buildPhoneTextField(),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildNoteTextField(
                  note: '* Hãy Thêm Ghi chú khi cần thiết nhé',
                  keyboardType: TextInputType.multiline,
                  textFieldHeight: 100.0, // Adjust the height as needed
                ),
                SizedBox(height: 20),
                Center(
                  child: CupertinoButton(
                    onPressed: () async {
                      Future<String> getPhoneAndSave() async {
                        final prefs = await SharedPreferences.getInstance();
                        final accessToken =
                            prefs.getString('accessToken') ?? '';

                        String url =
                            'https://api.dannycode.site/API/authentication/getPhone';

                        try {
                          final response = await http.post(
                            Uri.parse(url),
                            body: {'accessToken': accessToken},
                          );

                          if (response.statusCode == 200) {
                            Map<String, dynamic> responseData =
                                json.decode(response.body);
                            String phone =
                                responseData['phone'] ?? ''; // Handle null case
                            print("This is phone: $phone");

                            // Save the phone number to SharedPreferences
                            await prefs.setString('phone', phone);

                            return phone;
                          } else {
                            // Handle non-200 status codes
                            print(
                                'Failed to retrieve phone number: ${response.statusCode}');
                            return '';
                          }
                        } catch (e) {
                          // Handle exceptions
                          print(
                              'Error occurred while fetching phone number: $e');
                          return '';
                        }
                      }

                      Future<void> postData() async {
                        final prefs = await SharedPreferences.getInstance();
                        String phoneReceive = prefs.getString('phone') ?? '';
                        if (selectedSeat.isEmpty) {
                          return;
                        }
                        String phone =
                            await getPhoneAndSave(); // Get the phone number first
                        String url = 'https://api.dannycode.site/api/pickcar';

                        final response = await http.post(
                          Uri.parse(url),
                          body: {
                            'pickUp': prefs.getString('pickUp') ?? '',
                            'pickDrop': prefs.getString('pickDrop') ?? '',
                            'date': prefs.getString('date') ?? '',
                            'time': prefs.getString('time') ?? '',
                            'numberofSeat': selectedSeat,
                            'price': _priceController.text.trim().isNotEmpty
                                ? _priceController.text
                                : price.toString(),
                            'phonenumber': _phonenumberController.text.trim().isNotEmpty
                                ? _phonenumberController.text
                                : phone,
                            'phonenumberpick': phone, // Use the phone number obtained
                            'note': _noteController.text,
                          },
                        );


                        if (response.statusCode == 200) {
                          print("Post data successfully");
                          print(response.body);
                        } else {
                          throw Exception('Failed to post data');
                        }

                        String url2 =
                            'https://api.dannycode.site/api/sendNotification';

                        final response2 = await http.post(
                          Uri.parse(url2),
                          body: {
                            'pickUp': prefs.getString('pickUp') ?? '',
                            'pickDrop': prefs.getString('pickDrop') ?? '',
                          },
                        );

                        try {
                          final response = await http.post(
                            Uri.parse(
                                'https://api.dannycode.site/api/getLastestHistory'),
                            body: {
                              'accessToken': prefs.getString('accessToken') ??
                                  '', // Get the stored access token
                              'FCMToken': prefs.getString('FCMToken') ??
                                  '', // Get the stored FCM token
                            },
                          );

                          if (response.statusCode == 200) {
                            final responseBody = jsonDecode(response.body);
                            // Handle the response if needed
                            print('Response from server: $responseBody');
                          } else {
                            print(
                                'Failed to send tokens. Status code: ${response.statusCode}');
                          }
                        } catch (e) {
                          print('Error occurred: $e');
                        }
                      }

                      Future performPostDataOperation() async {
                        await postData();
                        return true;
                      }

                      void showConfirmDialog() async {
                        final prefs = await SharedPreferences.getInstance();
                        String phone = prefs.getString('phone') ?? '';
                        // Retrieve stored values from SharedPreferences
                        final pickUp = prefs.getString('pickUp') ?? 'Điểm Đón';
                        final dropOff =
                            prefs.getString('pickDrop') ?? 'Điểm Đến';
                        final date = prefs.getString('date') ?? 'Ngày';
                        final time = prefs.getString('time') ?? 'Giờ';
                        final pickprice = _priceController.text.isEmpty ? price : _priceController.text;
                        final phoneNumber = _phonenumberController.text.isNotEmpty ? _phonenumberController.text : phone;

                        final note = _noteController.text;

                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text('Xác Nhận Thông Tin'),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: 10), // Add some space at the top
                                  Row(
                                    children: [
                                      Icon(CupertinoIcons.location,
                                          size: 20,
                                          color: CupertinoColors.systemGrey),
                                      SizedBox(width: 8),
                                      Text('Điểm Đón: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Flexible(
                                        child: Text(
                                          pickUp,
                                          style: TextStyle(
                                              color:
                                                  CupertinoColors.systemGrey),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5), // Add space between rows
                                  Row(
                                    children: [
                                      Icon(CupertinoIcons.location_fill,
                                          size: 20,
                                          color: CupertinoColors.systemGrey),
                                      SizedBox(width: 8),
                                      Text('Điểm Đến: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Flexible(
                                        child: Text(
                                          dropOff,
                                          style: TextStyle(
                                              color:
                                                  CupertinoColors.systemGrey),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(CupertinoIcons.calendar,
                                          size: 20,
                                          color: CupertinoColors.systemGrey),
                                      SizedBox(width: 8),
                                      Text('Ngày: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Flexible(
                                        child: Text(
                                          date,
                                          style: TextStyle(
                                              color:
                                                  CupertinoColors.systemGrey),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(CupertinoIcons.time,
                                          size: 20,
                                          color: CupertinoColors.systemGrey),
                                      SizedBox(width: 8),
                                      Text('Giờ: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Flexible(
                                        child: Text(
                                          time,
                                          style: TextStyle(
                                              color:
                                                  CupertinoColors.systemGrey),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(CupertinoIcons.person,
                                          size: 20,
                                          color: CupertinoColors.systemGrey),
                                      SizedBox(width: 8),
                                      Text('Số Ghế: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(selectedSeat,
                                          style: TextStyle(
                                              color:
                                                  CupertinoColors.systemGrey)),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(CupertinoIcons.money_dollar,
                                          size: 20,
                                          color: CupertinoColors.systemGrey),
                                      SizedBox(width: 8),
                                      Text('Giá: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('$pickprice Nghìn VND',
                                          style: TextStyle(
                                              color:
                                                  CupertinoColors.systemGrey)),
                                    ],
                                  ),

                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(CupertinoIcons.phone,
                                          size: 20,
                                          color: CupertinoColors.systemGrey),
                                      SizedBox(width: 8),
                                      Text('Số Điện Thoại: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(phoneNumber,
                                          style: TextStyle(
                                              color:
                                                  CupertinoColors.systemGrey)),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(CupertinoIcons.text_bubble,
                                          size: 20,
                                          color: CupertinoColors.systemGrey),
                                      SizedBox(width: 8),
                                      Text('Ghi Chú: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Flexible(
                                        child: Text(
                                          note,
                                          style: TextStyle(
                                              color:
                                                  CupertinoColors.systemGrey),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          10), // Add some space at the bottom
                                ],
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  child: Text('Hủy'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: Text('Xác Nhận'),
                                  onPressed: () async {
                                    performPostDataOperation();

                                    final prefs =
                                        await SharedPreferences.getInstance();

                                    if (selectedSeat.isEmpty) {
                                      return;
                                    } else if (_priceController.text.trim().isNotEmpty &&
                                        price >= (int.tryParse(_priceController.text) ?? 0)) {
                                      return;
                                    } else {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => PickCarDone(
                                            tripDate: prefs.getString('date') ??
                                                'Ngày chuyến đi', // Ngày chuyến đi từ SharedPreferences
                                            tripTime: prefs.getString('time') ??
                                                'Giờ chuyến đi', // Giờ chuyến đi từ SharedPreferences
                                            pickupPoint: prefs
                                                    .getString('pickUp') ??
                                                'Địa chỉ đón', // Điểm đón từ SharedPreferences
                                            destination: prefs
                                                    .getString('pickDrop') ??
                                                'Địa chỉ đến', // Điểm đến từ SharedPreferences // Thay thế bằng thời gian thực tế nếu có
                                            seats:
                                                selectedSeat, // Số ghế đã chọn
                                            notes: _noteController
                                                .text, // Ghi chú từ trường nhập liệu ghi chú
                                            price: _priceController.text.trim().isNotEmpty
                                                ? _priceController.text
                                                : price.toString(),
                                            accessToken: prefs
                                                    .getString("accessToken") ??
                                                '',
                                            FCMToken:
                                                prefs.getString("FCMToken") ??
                                                    '',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }

                      Future<void> checkInformation() async {
                        if (selectedSeat.isEmpty) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text('Thông Báo'),
                                content: Text('Vui lòng chọn số lượng ghế'),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );

                        } else if (_priceController.text.trim().isNotEmpty &&
                            price >= (int.tryParse(_priceController.text) ?? 0)) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text('Thông Báo'),
                                content: Text(
                                    'Vui lòng nhập Giá lớn hơn Giá ước lượng'),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {

                          showConfirmDialog();
                        }
                      }

                      await checkInformation();
                    },
                    color: Color(0xFF276F61),
                    child: Text('Đặt Xe'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueGrey.shade300, width: 1.5),
        color: Colors.white,
      ),
      child: CupertinoButton(
        onPressed: () {
          _showSeatPickerModal(context);
        },
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedSeat.isEmpty
                  ? 'Chọn Số Lượng Ghế'
                  : 'Số Ghế Đã Chọn: $selectedSeat',
              style: TextStyle(
                fontSize: 16,
                color: selectedSeat.isEmpty
                    ? Colors.blueGrey.shade400
                    : Colors.blueGrey.shade800,
                fontWeight:
                    selectedSeat.isEmpty ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            Icon(
              CupertinoIcons.arrow_right_circle_fill,
              color: Colors.blueGrey.shade800,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceTextField() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
          border: Border.all(
            color: Colors.blueGrey.shade300,
            width: 1.5,
          ),
        ),
        child: CupertinoTextField(
          style: TextStyle(color: CupertinoColors.black),
          controller: _priceController,
          placeholder: 'Nhập Giá',
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
            LengthLimitingTextInputFormatter(4), // Giới hạn tối đa 4 số
          ],
          prefix: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(
              CupertinoIcons.money_dollar,
              color: Colors.blueGrey.shade800,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          placeholderStyle: TextStyle(
            fontWeight: FontWeight.w100, // Making the placeholder bold
            color: Colors.blueGrey.shade800,
          ),
          prefixMode: OverlayVisibilityMode
              .notEditing, // To show the prefix even when not editing
          suffix: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 10),
            child: Text(
              'Nghìn VND',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.blueGrey.shade800,
              ),
            ),
          ),
        ));

  }

  Widget _buildPhoneTextField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
        border: Border.all(
          color: Colors.blueGrey.shade300,
          width: 1.5,
        ),
      ),
      child: CupertinoTextField(
        style: TextStyle(color: CupertinoColors.black),
        controller: _phonenumberController,
        placeholder: 'Nhập Số Điện Thoại Khách',
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        keyboardType: TextInputType.number,
        prefix: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Icon(
            CupertinoIcons.phone,
            color: Colors.blueGrey.shade800,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(8), // Adjust to match the outer container
        ),
      ),
    );
  }

  Widget _buildNoteTextField({
    required String note,
    TextInputType keyboardType = TextInputType.text,
    double textFieldHeight = 200.0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: textFieldHeight,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: CupertinoTextField(
            controller: _noteController,
            placeholder: 'Ghi Chú',
            padding: EdgeInsets.zero,
            keyboardType: keyboardType,
            maxLines: null, // Allow the text field to expand vertically
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            note,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blueGrey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  void _showSeatPickerModal(BuildContext context) {
    List<String> seatOptions = ['1', '2', 'Bao 4', 'Bao 7'];
    String tempSelectedSeat =
        selectedSeat; // Temporarily store current selection

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Chọn số lượng ghế'),
          actions: seatOptions.map((seat) {
            return CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  selectedSeat = seat;
                  print("Selected Seat $selectedSeat");
                  if (selectedSeat == "1") {
                    price = (constPrice * 1).round();
                  } else if (selectedSeat == "2") {
                    price = (constPrice * 1.9).round();
                  } else if (selectedSeat == "Bao 4") {
                    price = (constPrice * 3.05).round();
                  } else if (selectedSeat == "Bao 7") {
                    price = (constPrice * 3.5).round();
                  }
                  print("updatePrice: $price");
                });

                Navigator.pop(context); // Close the modal sheet
              },
              child: Text(seat),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context); // Close the modal sheet
            },
            child: Text('Hủy Bỏ'),
          ),
        );
      },
    );
  }
}
