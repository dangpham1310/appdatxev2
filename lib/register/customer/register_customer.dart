import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../driver/password_input_field/password_input_field.dart';

const double _kItemExtent = 32.0;
const List<String> _vehicleTypes = ['Xe 4 Chỗ', 'Xe 7 Chỗ'];

class CustomerInput extends StatefulWidget {
  const CustomerInput({Key? key}) : super(key: key);
  @override
  _CustomerInputState createState() => _CustomerInputState();
}

class _CustomerInputState extends State<CustomerInput> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _referencePhoneController = TextEditingController();
  int _selectedVehicleType = 0;

  void _validateInputs() {
    String errorMessage = '';
    if (_nameController.text.isEmpty) {
      errorMessage = 'Vui lòng điền đầy đủ thông tin';
    } else if (_passwordController.text.isEmpty) {
      errorMessage = 'Vui lòng nhập mật khẩu';
    } else if (_confirmPasswordController.text.isEmpty) {
      errorMessage = 'Vui lòng xác nhận mật khẩu';
    } else if (_passwordController.text != _confirmPasswordController.text) {
      errorMessage = 'Mật khẩu và xác nhận mật khẩu không khớp';
    }

    if (errorMessage.isNotEmpty) {
      _showErrorDialog(errorMessage);
    } else {
      // Change to the next screen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DriverGiayTo(),
      //   ),
      // );
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Lỗi'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Transform.scale(
                    scale: 1,
                    child: Image.asset(
                      'assets/images/Group 11.png',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 0.0),
                      Text(
                        'Nhập thông tin cá nhân',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      CupertinoTextField(
                        controller: _nameController,
                        placeholder: 'Họ Và Tên',
                        keyboardType: TextInputType.text,
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Nhập Mật Khẩu",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.blueGrey[600]),
                      ),
                      SizedBox(height: 10.0), // SizedBox to add spacing
                      PasswordInputField(
                        controller: _passwordController,
                        placeholder: 'Mật Khẩu (Điền 6 số)',
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Xác Nhận Mật Khẩu",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.blueGrey[600]),
                      ),
                      SizedBox(height: 10.0),
                      PasswordInputField(
                        controller: _confirmPasswordController,
                        placeholder: 'Xác Nhận Mật Khẩu',
                      ),
                      SizedBox(height: 20.0),
                      Center(
                        child: CupertinoTextField(
                          controller:
                              _referencePhoneController, // Use different controller for address
                          placeholder: 'Số Điện Thoại Người Giới Thiệu',
                          keyboardType: TextInputType.number,
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Center(
                        child: CupertinoButton(
                          onPressed: _validateInputs,
                          color: Color(0xFF40B59F),
                          child: Text(
                            'Tiếp Theo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
