import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CongratulationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Chúc Mừng"),
        backgroundColor: Color(0xFF40B59F),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  size: 100,
                  color: Color(0xFF40B59F),
                ),
                SizedBox(height: 20),
                Text(
                  "Chúc Mừng!",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF40B59F),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Bạn đã nhận chuyến thành công!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Divider(
                  thickness: 2,
                  color: Color(0xFF40B59F),
                ),
                SizedBox(height: 20),
                _buildInfoRow(
                  icon: CupertinoIcons.location_solid,
                  label: "Điểm đi:",
                  value: "Nhà Nghỉ An Khánh, Vũ Bản, Bình Lục, Hà Nam",
                ),
                SizedBox(height: 10),
                _buildInfoRow(
                  icon: CupertinoIcons.location_solid,
                  label: "Điểm đến:",
                  value: "Đại học Bách khoa Hà Nội, 1 Đại Cồ Việt, Hà Nội",
                ),
                SizedBox(height: 10),
                _buildInfoRow(
                  icon: CupertinoIcons.time,
                  label: "Thời gian:",
                  value: "2024-3-12 - Giờ: 16:42:00",
                ),
                SizedBox(height: 10),
                _buildInfoRow(
                  icon: CupertinoIcons.money_dollar_circle,
                  label: "Giá cước:",
                  value: "240 nghìn VND",
                ),
                SizedBox(height: 10),
                _buildInfoRow(
                  icon: CupertinoIcons.money_dollar_circle,
                  label: "Phí nhận:",
                  value: "48 nghìn VND",
                ),
                SizedBox(height: 10),
                _buildInfoRow(
                  icon: CupertinoIcons.car_detailed,
                  label: "Chỗ ngồi:",
                  value: "1 chỗ",
                ),
                SizedBox(height: 10),
                _buildInfoRow(
                  icon: CupertinoIcons.text_bubble,
                  label: "Ghi chú:",
                  value: "Có mang theo chó mèo",
                ),
                SizedBox(height: 20),
                CupertinoButton(
                  color: Color(0xFF40B59F),
                  child: Text("Quay lại trang chính"),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: CupertinoColors.systemGrey),
            color: Color(0xFF40B59F),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
