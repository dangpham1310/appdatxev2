import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeniedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Không Thể Nhận Chuyến",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.clear_circled_solid,
                  size: 100,
                  color: Colors.red,
                ),
                SizedBox(height: 20),
                Text(
                  "Xin Lỗi!",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Bạn không thể nhận chuyến này!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Divider(
                  thickness: 2,
                  color: Colors.red,
                ),
                SizedBox(height: 20),
                Text(
                  "Vui lòng thử lại sau hoặc chọn chuyến khác.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CupertinoButton(
                  color: Colors.red,
                  child: Text("Quay Lại"),
                  onPressed: () {
                    Navigator.of(context).pop();
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
