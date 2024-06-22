import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import the services package for clipboard

class NapRutPage extends StatefulWidget {
  @override
  _NapRutPageState createState() => _NapRutPageState();
}

class _NapRutPageState extends State<NapRutPage> {
  final String accountNumber = '7777799999123'; // Account number to be copied
  final List<String> amounts = [
    '1,000,000 VND',
    '2,000,000 VND',
    '3,000,000 VND',
    '4,000,000 VND',
    '5,000,000 VND',
    '6,000,000 VND',
    '7,000,000 VND',
    '8,000,000 VND',
    '9,000,000 VND',
    '10,000,000 VND'
  ];
  String selectedAmount = '1,000,000 VND';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Color(0xFF40B59F), // Set navigation bar color
        middle: Text(
          'Nạp Rút',
          style: TextStyle(color: CupertinoColors.white),
        ),
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Nạp Tiền',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF40B59F),
                  ),
                ),
                SizedBox(height: 10),
                _buildBankInfo(context),
                SizedBox(height: 20),
                _buildAmountField('Nhập số tiền muốn nạp'),
                SizedBox(height: 20),
                _buildActionButton(
                    'Nạp tiền', CupertinoIcons.add_circled, context),
                SizedBox(height: 40),
                Text(
                  'Rút Tiền',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF40B59F),
                  ),
                ),
                SizedBox(height: 10),
                _buildTextField('Số Tài Khoản'),
                SizedBox(height: 10),
                _buildTextField('Thông Tin Ngân Hàng'),
                SizedBox(height: 10),
                _buildTextField('Chủ Tài Khoản'),
                SizedBox(height: 10),
                _buildAmountDropdown(context),
                SizedBox(height: 20),
                _buildActionButton(
                    'Rút tiền', CupertinoIcons.minus_circled, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBankInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: CupertinoColors.systemGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin ngân hàng Nạp:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Ngân hàng: MBBank',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Số Tài Khoản: $accountNumber',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: accountNumber));
                  final snackBar = SnackBar(
                    content: Text('Số Tài Khoản đã được sao chép!'),
                    backgroundColor: Color(0xFF40B59F),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Icon(
                  CupertinoIcons.doc_on_clipboard,
                  color: Color(0xFF40B59F),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            'Chủ Tài Khoản: Phạm Thiên Đăng',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String placeholder) {
    return CupertinoTextField(
      placeholder: placeholder,
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: CupertinoColors.systemGrey),
      ),
    );
  }

  Widget _buildAmountField(String placeholder) {
    return CupertinoTextField(
      placeholder: placeholder,
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      keyboardType: TextInputType.number,
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: CupertinoColors.systemGrey),
      ),
    );
  }

  Widget _buildAmountDropdown(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showAmountPicker(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: CupertinoColors.systemGrey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedAmount,
              style: TextStyle(fontSize: 16.0, color: CupertinoColors.black),
            ),
            Icon(
              CupertinoIcons.chevron_down,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    );
  }

  void _showAmountPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext modalContext) => Container(
        height: 300,
        color: CupertinoColors.white,
        child: Column(
          children: [
            Container(
              height: 200,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                    initialItem: amounts.indexOf(selectedAmount)),
                itemExtent: 32.0,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    selectedAmount = amounts[index];
                  });
                },
                children: amounts.map((String amount) {
                  return Text(amount);
                }).toList(),
              ),
            ),
            CupertinoButton(
              child:
                  Text('Xác nhận', style: TextStyle(color: Color(0xFF40B59F))),
              onPressed: () {
                setState(() {}); // Ensures the state is updated
                Navigator.of(modalContext).pop(); // Close the modal
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        color: Color(0xFF40B59F),
        padding: EdgeInsets.symmetric(vertical: 14.0),
        onPressed: () {
          // Implement your deposit or withdrawal logic here
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: CupertinoColors.white),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: CupertinoColors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
