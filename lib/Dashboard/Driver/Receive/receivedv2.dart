import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListReceive extends StatefulWidget {
  const ListReceive({super.key});

  @override
  State<ListReceive> createState() => _ListReceiveState();
}

class _ListReceiveState extends State<ListReceive> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "Danh Sách Nhận Xe",
          style: TextStyle(color: Colors.white),
        ),
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
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCard(),
                SizedBox(height: 10),
                _buildCard(),
                SizedBox(height: 10),
                _buildCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          // Cupertino DIalog

          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text("Xác nhận"),
                content: Text("Bạn có chắc chắn muốn nhận chuyến này không?"),
                actions: [
                  CupertinoDialogAction(
                    child: Text("Hủy"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text("Đồng ý"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      background: Container(
        color: Color(0xFF4092B5),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          CupertinoIcons.arrow_left_circle_fill,
          color: Colors.white,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF40B59F).withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.all(
                      10.0), // Padding for the first column
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRow(
                        icon: CupertinoIcons.location_fill,
                        text: 'Nhà Nghỉ An Khánh, Vũ Bản, Bình Lục, Hà nam',
                      ),
                      SizedBox(height: 5),
                      _buildRow(
                        icon: CupertinoIcons.location_solid,
                        text:
                            'Đại học Bách khoa Hà Nội, 1 Đại Cồ Việt, Bách Khoa, Hai Bà Trưng, Hà Nội',
                      ),
                      SizedBox(height: 5),
                      _buildRow(
                        icon: CupertinoIcons.time,
                        text: '2024-3-12  -  Giờ: 16:42:00',
                      ),
                      SizedBox(height: 5),
                      _buildDoubleRow(
                        icon1: CupertinoIcons.money_dollar_circle,
                        text1: '240 nghìn VND',
                        icon2: CupertinoIcons.car_detailed,
                        text2: '1 chỗ',
                      ),
                      SizedBox(height: 5),
                      _buildRow(
                        icon: CupertinoIcons.money_dollar_circle,
                        text: 'Phí nhận: 48 nghìn VND',
                        textStyle: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 5),
                      _buildRow(
                        icon: CupertinoIcons.text_bubble,
                        text: 'Ghi chú: Có mang theo chó mèo',
                        textStyle: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   width: 70, // Adjust width as needed
              //   decoration: BoxDecoration(
              //     color: Color(0xFF40B59F),
              //     borderRadius: BorderRadius.circular(12.0),
              //   ),
              //   child: CupertinoButton(
              //     padding: EdgeInsets.zero,
              //     child: Center(
              //       child: Text(
              //         "Nhận",
              //         style: TextStyle(
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //     onPressed: () {
              //       // Your onPressed logic goes here
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoubleRow({
    required IconData icon1,
    required String text1,
    required IconData icon2,
    required String text2,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildRow(
            icon: icon1,
            text: text1,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildRow(
            icon: icon2,
            text: text2,
          ),
        ),
      ],
    );
  }

  Widget _buildRow(
      {required IconData icon, required String text, TextStyle? textStyle}) {
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
            size: 16,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: (textStyle ?? TextStyle()).copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(CupertinoApp(
    home: ListReceive(),
  ));
}
