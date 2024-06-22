import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './recent.dart';
import './receivedv2.dart';

class Receive extends StatefulWidget {
  const Receive({super.key});

  @override
  State<Receive> createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String pickUpLocation = '';
  String dropOffLocation = '';

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
                        selectedTime = TimeOfDay.fromDateTime(newDateTime);
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
                            controller:
                                TextEditingController(text: pickUpLocation),
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
                            controller:
                                TextEditingController(text: dropOffLocation),
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
                                      'Chọn Ngày',
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
                                      'Chọn Giờ',
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListReceive(),
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
                      pickUpLocation = location;
                    });
                  },
                  onLocationDestinationSelected: (String location) {
                    setState(() {
                      dropOffLocation = location;
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
