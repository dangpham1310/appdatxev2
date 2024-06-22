import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'congratulation.dart';

class ListReceive extends StatefulWidget {
  const ListReceive({Key? key}) : super(key: key);

  @override
  State<ListReceive> createState() => _ListReceiveState();
}

class _ListReceiveState extends State<ListReceive> {
  List<bool> cardVisibility = [
    true,
    true,
    true
  ]; // Track visibility of each card

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
                _buildCard(0),
                SizedBox(height: 10),
                _buildCard(1),
                SizedBox(height: 10),
                _buildCard(2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    return Visibility(
      visible: cardVisibility[index],
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            bool? confirm = await showCupertinoDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text(
                    "Xác nhận",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF40B59F),
                    ),
                  ),
                  content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Bạn có chắc chắn muốn nhận chuyến này không?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: Text(
                        "Hủy",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false); // Return false
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text(
                        "Đồng ý",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF40B59F),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true); // Return true
                      },
                    ),
                  ],
                );
              },
            );
            if (confirm == true) {
              _hideCard(index);
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => CongratulationPage(),
                ),
              );
            }
            return confirm;
          }
          return false;
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
                    padding: const EdgeInsets.all(10.0),
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
                        _builTime(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _hideCard(int index) {
    setState(() {
      cardVisibility[index] = false; // Hide the card
    });
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
            size: 13,
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

  Widget _builTime(
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
            size: 13,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: (textStyle ?? TextStyle(fontWeight: FontWeight.bold))
                .copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
