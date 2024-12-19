import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteAccountPage extends StatefulWidget {
  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Xóa Tài Khoản',
            style: TextStyle(color: CupertinoColors.white)),
        backgroundColor: Color(0xFF40B59F),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(CupertinoIcons.back, color: Colors.white),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!_isSubmitted) ...[
                Text(
                  'Vui lòng nhập lý do bạn muốn xóa tài khoản:',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                CupertinoTextField(
                  style: TextStyle(color: CupertinoColors.black),
                  controller: _reasonController,
                  placeholder: 'Lý do...',
                  maxLines: 3,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemGrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: 16),
                CupertinoButton(
                  onPressed: _submitReason,
                  color: CupertinoColors.activeBlue,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.arrow_right_circle_fill),
                      SizedBox(width: 8),
                      Text('Gửi'),
                    ],
                  ),
                ),
              ] else ...[
                Icon(CupertinoIcons.check_mark_circled,
                    size: 100, color: CupertinoColors.systemGreen),
                SizedBox(height: 16),
                Text(
                  'Cảm ơn bạn! Yêu cầu của bạn đã được ghi nhận.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Tài khoản sẽ được xóa trong 2-3 ngày.',
                  style: TextStyle(
                      fontSize: 16, color: CupertinoColors.systemGrey),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _submitReason() {
    if (_reasonController.text.isNotEmpty) {
      setState(() {
        _isSubmitted = true;
      });

      // Simulate sending the reason to the server
      Future.delayed(Duration(seconds: 2), () {
        // You can add your server logic here, e.g., API call
        print('Lý do xóa tài khoản: ${_reasonController.text}');
      });
    } else {
      // Display an alert if the reason is empty
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Lỗi'),
          content: Text('Vui lòng nhập lý do trước khi gửi.'),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }
}
