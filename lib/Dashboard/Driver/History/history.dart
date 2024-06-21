import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Lịch Sử', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF40B59F),
        leading: null,
        automaticallyImplyLeading: false,
      ),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            buildHistoryCard(
              context: context,
              status: 'Hoàn thành',
              statusColor: Color(0xFF40A7B5),
              phoneButtonColor: Color(0xFF40B59F),
            ),
            SizedBox(height: 16.0),
            buildHistoryCard(
              context: context,
              status: 'Hủy',
              statusColor: CupertinoColors.systemRed,
            ),
            SizedBox(height: 16.0),
            buildHistoryCard(
              context: context,
              status: 'Đã Nhận',
              statusColor: CupertinoColors.activeGreen,
            ),
            SizedBox(height: 16.0),
            buildHistoryCard(
              context: context,
              status: 'Chưa Nhận',
              statusColor: CupertinoColors.systemYellow,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatusWidget(String status, Color statusColor) {
    return Positioned(
      top: 8.0,
      right: 8.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          status,
          style: TextStyle(color: CupertinoColors.white, fontSize: 12.0),
        ),
      ),
    );
  }

  Widget buildHistoryCard({
    required BuildContext context,
    required String status,
    required Color statusColor,
    Color? phoneButtonColor,
  }) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 8.0), // To ensure status is not clipped
          padding: EdgeInsets.only(left: 15.0),
          decoration: BoxDecoration(
            color: Color(0xFF40B59F).withOpacity(0.3),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 24.0), // Space for the status widget
              Row(
                children: [
                  Icon(CupertinoIcons.location,
                      color: CupertinoColors.systemGrey),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Nhà Nghỉ An Khánh, Vũ Bản, Bình Lục, Hà nam',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(CupertinoIcons.location_solid,
                      color: CupertinoColors.systemGrey),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Đại học Bách khoa Hà Nội, 1 Đại Cồ Việt, Bách Khoa, Hai Bà Trưng, Hà Nội',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(CupertinoIcons.time, color: CupertinoColors.systemGrey),
                  SizedBox(width: 8.0),
                  Text(
                    '2024-3-12 - Giờ: 16:42:00',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(CupertinoIcons.money_dollar,
                      color: CupertinoColors.systemGrey),
                  SizedBox(width: 8.0),
                  Text(
                    '240 nghìn VND',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(width: 16.0),
                  Icon(CupertinoIcons.person,
                      color: CupertinoColors.systemGrey),
                  SizedBox(width: 8.0),
                  Text(
                    '1 chỗ',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
              if (status != 'Hủy' && status != 'Chưa Nhận') ...[
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(CupertinoIcons.phone,
                        color: CupertinoColors.systemGrey),
                    SizedBox(width: 8.0),
                    Text(
                      '0909123456',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(width: 16.0),
                    if (phoneButtonColor != null)
                      CupertinoButton(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        color: phoneButtonColor,
                        onPressed: () {},
                        child: Text('Gọi điện thoại',
                            style: TextStyle(fontSize: 12.0)),
                      ),
                  ],
                ),
              ],
              SizedBox(height: 8.0),
              Row(
                children: [
                  Spacer(),
                  CupertinoButton(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    color: Color(0xFFB54040).withOpacity(0.7),
                    onPressed: () {
                      TextEditingController reasonController =
                          TextEditingController();
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text('Báo cáo'),
                            content: Column(
                              children: [
                                Text('Vui lòng nhập lý do báo cáo:'),
                                SizedBox(height: 8.0),
                                CupertinoTextField(
                                  controller: reasonController,
                                  placeholder: 'Lý do',
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: Text('Gửi'),
                                onPressed: () {
                                  // Handle the report submission here
                                  String reason = reasonController.text;
                                  // Do something with the reason
                                  Navigator.of(context).pop();
                                },
                              ),
                              CupertinoDialogAction(
                                child: Text('Hủy'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.exclamationmark_triangle, size: 14),
                        SizedBox(width: 4),
                        Text('Báo cáo',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              if (status == 'Đã Nhận' || status == 'Chưa Nhận') ...[
                SizedBox(height: 8.0),
                Center(
                  child: CupertinoButton(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    color: CupertinoColors.systemRed,
                    onPressed: () {
                      // Handle the cancellation here
                    },
                    child: Text(
                      'Hủy',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 8.0),
            ],
          ),
        ),
        buildStatusWidget(status, statusColor),
      ],
    );
  }
}

void main() {
  runApp(CupertinoApp(
    home: HistoryPage(),
  ));
}
