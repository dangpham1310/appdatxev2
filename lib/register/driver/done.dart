import 'dart:io';
import 'package:flutter/material.dart';

class DriverDone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true, // Allow going back
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Thông Báo'),
            centerTitle: true,
            shadowColor: Color.fromARGB(0, 251, 251, 251),
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.teal,
                    size: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Kết quả đã được gửi đến quản trị viên.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Cảm ơn bạn đã tham gia!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      exit(0); // Exit the application
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // Button color/ Button color
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 12.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Thoát Ứng Dụng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
