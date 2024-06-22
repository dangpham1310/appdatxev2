import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Information extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle:
            Text("Thông Tin Cá Nhân", style: TextStyle(color: Colors.white)),
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
                    controller: TextEditingController(text: 'Vũ Văn Lợi'),
                    readOnly: true,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  )),
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
                        'Địa chỉ: 123 Đường ABC, Quận XYZ, TP.HCM',
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
                controller: TextEditingController(text: '0899996922'),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              Text('Thông tin xe',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(CupertinoIcons.car_detailed, color: Color(0xFF40B59F)),
                  SizedBox(width: 5),
                  Text('Tên Xe: Vios'),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Icon(CupertinoIcons.number, color: Color(0xFF40B59F)),
                  SizedBox(width: 5),
                  Text('Biển Số Xe: 18A13845'),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Icon(CupertinoIcons.person_2, color: Color(0xFF40B59F)),
                  SizedBox(width: 5),
                  Text('Số chỗ: 4 chỗ'),
                ],
              ),
              Divider(),
              SizedBox(height: 20),
              Text('Ảnh bằng lái xe',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Image.network(
                        'https://th.bing.com/th/id/OIP.Q8faPAB94taMrjToDsj3AwHaEp?rs=1&pid=ImgDetMain',
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(height: 5),
                      Text('Mặt Trước'),
                    ],
                  ),
                  Column(
                    children: [
                      Image.network(
                        'https://th.bing.com/th/id/OIP.Q8faPAB94taMrjToDsj3AwHaEp?rs=1&pid=ImgDetMain',
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(height: 5),
                      Text('Mặt Sau'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Ảnh xe', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.network(
                    'https://th.bing.com/th/id/OIP.THGKrfVAQSM7viki4CjQXAHaFj?w=2048&h=1536&rs=1&pid=ImgDetMain',
                    width: 150,
                    height: 150,
                  ),
                  Image.network(
                    'https://th.bing.com/th/id/OIP.YIaIdbnkm0q60M8LdOyTzAHaFj?w=728&h=546&rs=1&pid=ImgDetMain',
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CupertinoButton(
                      onPressed: () {
                        // Handle Xóa Tài Khoản action
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
                      onPressed: () {
                        // Handle Đăng Xuất action
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
}
