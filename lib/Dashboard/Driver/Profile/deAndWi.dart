import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the services package for clipboard
import 'package:http/http.dart' as http;

class NapRutPage extends StatefulWidget {
  @override
  _NapRutPageState createState() => _NapRutPageState();
}

class _NapRutPageState extends State<NapRutPage> {
  String phoneNumber = "";
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString('phone') ?? '';
    String accessToken = prefs.getString('accessToken') ?? '';
    setState(() {
      phoneNumber = phone;
      accessToken = accessToken;
    });
  }

  final String accountNumber = '4801089296';
// Account number to be copied
  final List<String> amounts = [
    '100,000 VND',
    '200,000 VND',
    '300,000 VND',
    '400,000 VND',
    '500,000 VND',
    '600,000 VND',
    '700,000 VND',
    '800,000 VND',
    '900,000 VND',
    '1,000,000 VND'
  ];
  String selectedAmount = '100,000 VND';
  TextEditingController stkruttienController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController chutaikhoanController = TextEditingController();
  TextEditingController naptienController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    stkruttienController.dispose();
    bankNameController.dispose();
    chutaikhoanController.dispose();
    super.dispose();
  }

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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Nội Dung: $phoneNumber',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: phoneNumber));
                        final snackBar = SnackBar(
                          content: Text('Nội dung đã được sao chép!'),
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
            'Ngân hàng: BIDV',
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
            'Chủ Tài Khoản: VU VAN LOI',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String placeholder) {
    if (placeholder == "Số Tài Khoản") {
      return CupertinoTextField(
        placeholder: placeholder,
        controller: stkruttienController, // Use the controller here
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: CupertinoColors.systemGrey),
        ),
      );
    } else if (placeholder == "Thông Tin Ngân Hàng") {
      return CupertinoTextField(
        placeholder: placeholder,
        controller: bankNameController, // Use the controller here
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: CupertinoColors.systemGrey),
        ),
      );
    }
    return CupertinoTextField(
      placeholder: placeholder,
      controller: chutaikhoanController, // Use the controller here
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
      controller: naptienController, // Use the controller here
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
          if (text == 'Rút tiền') {
            print("Rút Tiền");
            // post to server accessToken, amount, accountNumber, bankName, accountName
            void _withdraw() async {
              final prefs = await SharedPreferences.getInstance();
              String? accessToken = prefs.getString('accessToken');

              if (accessToken != null && accessToken.isNotEmpty) {
                final response = await http.post(
                  Uri.parse('https://api.dannycode.site/api/ruttien'),
                  body: {
                    'accessToken': accessToken,
                    'amount': selectedAmount,
                    'stkruttien':
                        stkruttienController.text, // Use controller's text
                    'bankName':
                        bankNameController.text, // Use controller's text
                    'accountName':
                        chutaikhoanController.text, // Use controller's text
                  },
                );
                if (response.statusCode == 200) {
                  print('Rút tiền thành công');
                  _showSuccessDialog(context);
                } else {
                  _showFailWithDraw(context);
                }
              } else {
                print('Không tìm thấy accessToken');
              }
            }

            _withdraw();
          } else {
            void _deposit() async {
              final prefs = await SharedPreferences.getInstance();
              String? accessToken = prefs.getString('accessToken');

              if (accessToken != null && accessToken.isNotEmpty) {
                final response = await http.post(
                  Uri.parse('https://api.dannycode.site/api/naptien'),
                  body: {
                    'accessToken': accessToken,
                    'amount': naptienController.text,
                  },
                );
                if (response.statusCode == 200) {
                  print('Nạp tiền thành công');
                  _showSuccessDialogNapTien(context);
                } else {
                  print('Nạp tiền thất bại');
                }
              } else {
                print('Không tìm thấy accessToken');
              }
            }

            _deposit();
          }
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

void _showSuccessDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text("Rút Tiền Thành Công"),
        content: Text("Yêu cầu rút tiền của bạn đã được thực hiện thành công."),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
            },
          ),
        ],
      );
    },
  );
}

void _showFailWithDraw(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text("Rút Tiền Thất Bại"),
        content: Text(
            "Yêu cầu rút tiền của bạn thất bại do số dư nhỏ hơn số tiền rút"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
            },
          ),
        ],
      );
    },
  );
}

void _showSuccessDialogNapTien(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text("Nạp Tiền Thành Công"),
        content: Text("Yêu cầu Nạp tiền của bạn đã được thực hiện thành công."),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
            },
          ),
        ],
      );
    },
  );
}
