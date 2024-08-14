import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './recent.dart';
import './receivedv2.dart';
import 'package:http/http.dart' as http;

class Receive extends StatefulWidget {
  const Receive({super.key});

  @override
  State<Receive> createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  DateTime nowDate = DateTime.now();
  String formattedDate = '';
  String _TimeofDay = 'Chọn Giờ';
  TimeOfDay? _selectedTime = TimeOfDay.now();
  TimeOfDay currentTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    TimeOfDay currentTime = TimeOfDay.now();

    // Calculate the new time by adding 15 minutes
    int newHour = currentTime.hour;
    int newMinute = currentTime.minute + 0;
    // Set the new selected time
    _selectedTime = TimeOfDay(hour: newHour, minute: newMinute);
    formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  TextEditingController _pickUpController = TextEditingController();
  TextEditingController _dropOffController = TextEditingController();
  String pickUpLocation = "";
  String dropOffLocation = "";

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
                    initialDateTime: selectedDate,
                    minimumDate: DateTime(2015, 8),
                    maximumDate: DateTime(2101),
                    onDateTimeChanged: (DateTime newDateTime) {
                      selectedDate = newDateTime;
                      formattedDate =
                          DateFormat('dd/MM/yyyy').format(newDateTime);
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Ẩn bàn phím
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  height: 300,
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: CupertinoTextField(
                            placeholder: 'Điểm Đón',
                            placeholderStyle:
                                TextStyle(color: Colors.grey[200]),
                            prefix: Icon(
                              CupertinoIcons.location,
                              color: Colors.grey,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            controller: _pickUpController,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: CupertinoTextField(
                            placeholder: 'Điểm Đến',
                            placeholderStyle:
                                TextStyle(color: Colors.grey[200]),
                            prefix: Icon(
                              CupertinoIcons.location_solid,
                              color: Colors.grey,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            controller: _dropOffController,
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                                      '$_TimeofDay',
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
                            child: Text("Xác Nhận"),
                            onPressed: () {
                              Future<void> saveTimeOfDay(TimeOfDay time) async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final formattedTime =
                                    '${time.hour}:${time.minute}';
                                await prefs.setString('time', formattedTime);
                              }

                              Future<void> sendRecent() async {
                                final prefs =
                                    await SharedPreferences.getInstance();

                                String? phone = prefs.getString('phone') ?? '';

                                final response = await http.post(
                                    Uri.parse(
                                        'https://api.dantay.vn/api/postRecent'),
                                    body: {
                                      'phone': phone,
                                      'pickUp': _pickUpController.text,
                                      'pickDrop': _dropOffController.text,
                                    });
                              }

                              sendRecent();

                              saveTimeOfDay(selectedTime);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListReceive(
                                    pickUpLocation: _pickUpController.text,
                                    dropOffLocation: _dropOffController.text,
                                    selectedTime: selectedTime,
                                    selectedDate: selectedDate,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
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
                Recent(
                  onLocationPickupSelected: (String location) {
                    setState(() {
                      pickUpLocation = _pickUpController.text;
                    });
                  },
                  onLocationDestinationSelected: (String location) {
                    setState(() {
                      dropOffLocation = _dropOffController.text;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
