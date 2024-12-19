import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'recent.dart';
import 'pickcar_dash2.dart';
import 'package:http/http.dart' as http;

void showDistanceErrorDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Thông báo'),
        content: Text('Vui lòng nhập lại Vị trí chính xác'),
        actions: <Widget>[
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
}

void showTimeErrorDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Thông báo'),
        content: Text(
            'Vui lòng nhập lại Thời gian chính xác, sau 15 phút tính từ hiện tại'),
        actions: <Widget>[
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
}

class PickCarGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final Color backgroundColor = brightness == Brightness.dark
        ? CupertinoColors.black
        : CupertinoColors.white;
    return CupertinoApp(
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('vi', 'VN'),
      ],
      home: PickCar(),
    );
  }
}

Position createPositionFromJson(Map<String, dynamic> json) {
  final location = json['geometry']['location'];
  final double latitude = location['lat'];
  final double longitude = location['lng'];

  // Assuming you want to set the timestamp to the current time
  DateTime currentTimestamp = DateTime.now();

  return Position(
    latitude: latitude,
    longitude: longitude,
    timestamp: currentTimestamp,
    accuracy: 0, // Set these values to null or provide specific values
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
  );
}

class PickCar extends StatefulWidget {
  @override
  _PickCarState createState() => _PickCarState();
}

class _PickCarState extends State<PickCar> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final String pickUpPoint = "Địa chỉ điểm đón";
  final String destination = "Địa chỉ điểm đến";
  bool _isMounted = false;
  List<String> _titles = ['Trang Chủ', 'Danh Sách', 'Lịch Sử', 'Hồ Sơ'];

  // Function to handle bottom navigation item ta
  TimeOfDay? _selectedTime = TimeOfDay.now();
  int _selectedIndex = 0;
  double distance = 0.0;
  double Price = 0.0;
  double constPrice = 0.0;

  // ignore: non_constant_identifier_names
  List<dynamic> places = [];
  List<dynamic> detailsPickUp = [];
  List<dynamic> detailsDropOff = [];

  TextEditingController _pickUpController = TextEditingController();
  TextEditingController _dropOffController = TextEditingController();
  TextEditingController _seatController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  // ignore: non_constant_identifier_names

  String searchText = "";
  String mainText = "";
  String secondText = "";

  bool isShowPickUp = false;
  bool isHiddenPickUp = true;

  bool isShowDropOff = false;
  bool isHiddenDropOff = true;

  Position? positionPickUp;
  Position? positionDropOff;

  Timer? _debounce;

  String savedRole = ''; // Define savedRole globally

  String? _savedRole;
  DateTime nowDate = DateTime.now();
  String formattedDate = '';
  String _TimeofDay = 'Chọn Giờ';

  bool _isLoading = false;
  @override
  void initState() {
    _isMounted = false;
    super.initState();

    TimeOfDay currentTime = TimeOfDay.now();

    // Calculate the new time by adding 15 minutes
    int newHour = currentTime.hour;
    int newMinute = currentTime.minute + 0;

    // Adjust the hour and minute if necessary
    if (newMinute >= 60) {
      newHour += 1;
      newMinute -= 60;
    }
    if (newHour >= 24) {
      newHour = 0;
    }

    // Set the new selected time
    _selectedTime = TimeOfDay(hour: newHour, minute: newMinute);
    formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  Future<double> fetchDistance() async {
    final url = Uri.parse(
        "https://api.dannycode.site/getdistance/${positionPickUp?.latitude}/${positionPickUp?.longitude}/${positionDropOff?.latitude}/${positionDropOff?.longitude}");
    try {
      final response = await http.get(url);

      print("Link urlmap: $url");

      if (response.statusCode == 200) {
        Map<String, dynamic> firstPath = json.decode(response.body)['paths'][0];
        return (firstPath['distance'] + 0.0);
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return 0.0;
      }
    } catch (error) {
      print('Error fetchDistance: $error');
      return 0.0;
    }
  }

  Future<void> fetchDataPickUp(String input) async {
    try {
      // Clear the previous places data and flags
      setState(() {
        places = [];
        isShowPickUp = false;
        isHiddenPickUp = false;
      });

      // Cancel the previous timer if it exists
      _debounce?.cancel();

      // Set a new timer for 3 seconds
      _debounce = Timer(Duration(milliseconds: 500), () async {
        if (input.length >= 2) {
          final url =
              Uri.parse('https://api.dannycode.site/autocomplete/$input');

          var response = await http.get(url);

          setState(() {
            final jsonResponse = jsonDecode(response.body);
            places = jsonResponse['predictions'] as List<dynamic>;
            isShowPickUp = true;
            isHiddenPickUp = true;
          });
        } else {
          // If input has less than 8 characters, clear the list and reset flags
          setState(() {
            places = [];
            isShowPickUp = false;
            isHiddenPickUp = false;
          });
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print('$e');
    }
  }

  Future<void> fetchDataDropOff(String input) async {
    try {
      // Clear the previous places data and flags
      setState(() {
        places = [];
        isShowDropOff = false;
        isHiddenDropOff = false;
      });

      // Cancel the previous timer if it exists
      _debounce?.cancel();

      // Set a new timer for 3 seconds
      _debounce = Timer(Duration(milliseconds: 500), () async {
        if (input.length >= 2) {
          final url =
              Uri.parse('https://api.dannycode.site/autocomplete/$input');

          var response = await http.get(url);

          setState(() {
            final jsonResponse = jsonDecode(response.body);
            places = jsonResponse['predictions'] as List<dynamic>;
            isShowDropOff = true;
            isHiddenDropOff = true;
          });
        } else {
          // If input has less than 8 characters, clear the list and reset flags
          setState(() {
            places = [];
            isShowDropOff = false;
            isHiddenDropOff = false;
          });
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print('$e');
    }
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: CupertinoColors.white, // Ensure the background color is set
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    minimumDate: DateTime(2015, 8),
                    maximumDate: DateTime(2101),
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        selectedDate = newDateTime;
                        print(newDateTime);
                        formattedDate =
                            DateFormat('dd/MM/yyyy').format(newDateTime);
                      });
                    },
                  ),
                ),
                CupertinoButton(
                  child: Text('Hoàn tất'),
                  onPressed: () {
                    Navigator.of(context).pop(selectedDate);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showCupertinoModalPopup<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: CupertinoColors.white, // Ensure the background color is set
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 200,
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (DateTime newDateTime) {
                        setState(() {
                          selectedTime = TimeOfDay.fromDateTime(newDateTime);
                          _TimeofDay = selectedTime.hour.toString() +
                              ':' +
                              selectedTime.minute.toString();
                        });
                      },
                    ),
                  ),
                ),
                CupertinoButton(
                  child: Text('Hoàn tất'),
                  onPressed: () {
                    Navigator.of(context).pop(selectedTime);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        print(selectedTime);
      });
    }
  }

  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // Removed the fixed height and used a flexible container
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF40B59F),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.blue.shade700),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: _buildTextFieldLocationPickUp(
                              _pickUpController, 'Điểm Đón'),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: _buildTextFieldLocationDropOff(
                              _dropOffController, 'Điểm Đến'),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => _showTimePicker(context),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.time,
                                        color:
                                            Color.fromARGB(255, 146, 129, 129)),
                                    SizedBox(width: 5),
                                    Text(
                                      _TimeofDay,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showDatePicker(context),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.calendar,
                                        color: Colors.grey),
                                    SizedBox(width: 5),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: CupertinoButton(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Color(0xFF276F61),
                            child: _isLoading
                                ? CupertinoActivityIndicator() // Hiển thị spinner khi đang loading
                                : Text("Xác Nhận"),
                            onPressed: _isLoading
                                ? null // Vô hiệu hóa nút khi đang loading
                                : () async {
                                    setState(() {
                                      _isLoading = true; // Bắt đầu loading
                                    });

                                    try {
                                      Future<void> saveTimeOfDay(
                                          TimeOfDay time) async {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        final formattedTime =
                                            '${time.hour}:${time.minute}';
                                        await prefs.setString(
                                            'time', formattedTime);
                                      }

                                      if (formattedDate ==
                                          DateFormat('dd/MM/yyyy')
                                              .format(nowDate)) {
                                        DateTime nowDate = DateTime.now();

                                        final nowPlus15Minutes =
                                            nowDate.add(Duration(minutes: 15));
                                        final selectedDateTime = DateTime(
                                            nowDate.year,
                                            nowDate.month,
                                            nowDate.day,
                                            selectedTime.hour,
                                            selectedTime.minute);

                                        if (formattedDate ==
                                            DateFormat('dd/MM/yyyy')
                                                .format(nowDate)) {
                                          if (selectedDateTime
                                              .isBefore(nowPlus15Minutes)) {
                                            showTimeErrorDialog(context);
                                            return;
                                          }
                                        }
                                      }
                                      saveTimeOfDay(selectedTime);
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setString(
                                          'pickUp', _pickUpController.text);
                                      await prefs.setString(
                                          'pickDrop', _dropOffController.text);
                                      await prefs.setString(
                                          'date', formattedDate);
                                      await prefs.setString('time',
                                          '${selectedTime.hour}:${selectedTime.minute}');
                                      await prefs.setString(
                                          'seat', _seatController.text);

                                      distance = await fetchDistance();
                                      if (distance == 0) {
                                        showDistanceErrorDialog(context);
                                        return;
                                      }

                                      await prefs.setDouble(
                                          'distance', distance);
                                      Navigator.of(context).push(
                                        CupertinoPageRoute(
                                          builder: (context) => PickCarDash2(),
                                        ),
                                      );
                                    } finally {
                                      setState(() {
                                        _isLoading = false; // Kết thúc loading
                                      });
                                    }
                                  },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Gần Đây',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 17,
                    ),
                  ),
                ),
                Recent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldLocationPickUp(
      TextEditingController controller, String labelText) {
    return Stack(
      children: [
        if (isShowPickUp)
          Container(
            height: 220,
            margin: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: const BoxDecoration(color: CupertinoColors.white),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 120,
              ),
              child: _buildListViewPickUp(),
            ),
          ),
        CupertinoTextField(
          style: TextStyle(color: CupertinoColors.black),
          controller: controller,
          onChanged: (text) {
            if (text != null) {
              setState(() {
                searchText = text;
              });
              fetchDataPickUp(text);
            }
            isHiddenPickUp = true;
          },
          placeholder: labelText,
          //   placeholder: 'Điểm Đón',
          placeholderStyle: TextStyle(color: Colors.grey[200]),
          prefix: Icon(
            CupertinoIcons.location,
            color: Colors.grey,
          ),
          padding: EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          suffix: GestureDetector(
            onTap: () {
              controller.clear();
              // Add any additional logic you need when the clear button is pressed
            },
            child: Icon(CupertinoIcons.clear_thick_circled,
                color: CupertinoColors.systemGrey),
          ),
        ),
      ],
    );
  }

  Widget _buildListViewPickUp() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: places.length,
      itemBuilder: (context, index) {
        final coordinate = places[index];

        return GestureDetector(
          onTap: () async {
            setState(() {
              isShowPickUp = false;
              isHiddenPickUp = false;
            });

            final url = Uri.parse(
                'https://api.dannycode.site/buildlist/${coordinate['description']}');
            var response = await http.get(url);
            final jsonResponse = jsonDecode(response.body);
            detailsPickUp = jsonResponse['results'] as List<dynamic>;

            _pickUpController.text = coordinate['description'];
            mainText = coordinate['structured_formatting']?['main_text'];
            secondText = coordinate['structured_formatting']?['secondary_text'];

            if (detailsPickUp.isNotEmpty && index < detailsPickUp.length) {
              positionPickUp = createPositionFromJson(detailsPickUp[index]);
            } else {
              print('Error: detailsPickUp is empty or index is out of range');
              positionPickUp = createPositionFromJson(detailsPickUp[0]);
            }

            // Print the values
            print("MainText: $mainText");
            print("SecondText: $secondText");
            print('Latitude: ${positionPickUp?.latitude}');
            print('Longitude: ${positionPickUp?.longitude}');
            print('Timestamp: ${positionPickUp?.timestamp}');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: CupertinoColors.activeBlue,
                  size: 15,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    coordinate['description'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: const TextStyle(
                      color: CupertinoColors.inactiveGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextFieldLocationDropOff(
      TextEditingController controller, String labelText) {
    return Stack(
      children: [
        if (isShowDropOff)
          Container(
            height: 220,
            margin: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: const BoxDecoration(color: CupertinoColors.white),
            child: _buildListViewDropOff(),
          ),
        CupertinoTextField(
          style: TextStyle(color: CupertinoColors.black),
          controller: controller,
          onChanged: (text) {
            if (text != null) {
              setState(() {
                searchText = text;
              });
              fetchDataDropOff(text);
            }
            isHiddenDropOff = true;
          },
          placeholder: labelText,
          placeholderStyle: TextStyle(color: Colors.grey[200]),
          prefix: Icon(
            CupertinoIcons.location_solid,
            color: Colors.grey,
          ),
          padding: EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          suffix: GestureDetector(
            onTap: () {
              controller.clear();
              // Add any additional logic you need when the clear button is pressed
            },
            child: Icon(CupertinoIcons.clear_thick_circled,
                color: CupertinoColors.systemGrey),
          ),
        ),
      ],
    );
  }

  Widget _buildListViewDropOff() {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        final coordinate = places[index];

        return GestureDetector(
          onTap: () async {
            setState(() {
              isShowDropOff = false;
              isHiddenDropOff = false;
            });

            final url = Uri.parse(
                'https://api.dannycode.site/buildlist/${coordinate['description']}');
            var response = await http.get(url);
            final jsonResponse = jsonDecode(response.body);
            detailsDropOff = jsonResponse['results'] as List<dynamic>;

            _dropOffController.text = coordinate['description'];
            mainText = coordinate['structured_formatting']['main_text'];
            secondText = coordinate['structured_formatting']['secondary_text'];

            if (detailsDropOff.isNotEmpty && index < detailsDropOff.length) {
              positionDropOff = createPositionFromJson(detailsDropOff[index]);
            } else {
              print('Error: detailsDropOff is empty or index is out of range');
              positionDropOff = createPositionFromJson(detailsDropOff[0]);
            }

            // Print the values
            print("Link uri: ${coordinate['description']}");
            print("MainText: $mainText");
            print("SecondText: $secondText");
            print('Latitude: ${positionDropOff?.latitude}');
            print('Longitude: ${positionDropOff?.longitude}');
            print('Timestamp: ${positionDropOff?.timestamp}');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: CupertinoColors.activeBlue,
                  size: 15,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    coordinate['description'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: const TextStyle(
                      color: CupertinoColors.inactiveGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
