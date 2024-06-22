import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './detailHistory.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            buildHistoryCard(
              context: context,
              status: 'Hoàn thành',
              statusColor: Color(0xFF40A7B5),
              startPoint: 'Nhà Nghỉ An Khánh, Vũ Bản, Bình Lục, Hà nam',
              endPoint:
                  'Đại học Bách khoa Hà Nội, 1 Đại Cồ Việt, Bách Khoa, Hai Bà Trưng, Hà Nội',
            ),
            SizedBox(height: 3.0),
            buildHistoryCard(
              context: context,
              status: 'Hủy',
              statusColor: CupertinoColors.systemRed,
              startPoint: 'Nhà Nghỉ An Khánh, Vũ Bản, Bình Lục, Hà nam',
              endPoint:
                  'Đại học Bách khoa Hà Nội, 1 Đại Cồ Việt, Bách Khoa, Hai Bà Trưng, Hà Nội',
            ),
            SizedBox(height: 3.0),
            buildHistoryCard(
              context: context,
              status: 'Đã Nhận',
              statusColor: CupertinoColors.activeGreen,
              startPoint: 'Nhà Nghỉ An Khánh, Vũ Bản, Bình Lục, Hà nammmm',
              endPoint:
                  'Đại học Bách khoa Hà Nội, 1 Đại Cồ Việt, Bách Khoa, Hai Bà Trưng, Hà Nội',
            ),
            SizedBox(height: 3.0),
            buildHistoryCard(
              context: context,
              status: 'Chưa Nhận',
              statusColor: CupertinoColors.systemYellow,
              startPoint: 'Nhà Nghỉ An Khánh, Vũ Bản, Bình Lục, Hà nam',
              endPoint:
                  'Đại học Bách khoa Hà Nội, 1 Đại Cồ Việt, Bách Khoa, Hai Bà Trưng, Hà Nội',
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
    required String startPoint,
    required String endPoint,
  }) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 8.0), // To ensure status is not clipped
          padding: EdgeInsets.only(left: 15.0, bottom: 0.0),
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
                      startPoint,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Icon(CupertinoIcons.location_solid,
                      color: CupertinoColors.systemGrey),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      endPoint,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ],
              ),

              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => DetailsPage(
                          startPoint: startPoint,
                          endPoint: endPoint,
                        ),
                      ),
                    );
                  },
                  child: Text('Chi tiết >',
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold)),
                ),
              ),
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
