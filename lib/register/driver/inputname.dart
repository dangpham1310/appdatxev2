import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'input_giayto.dart';
import './password_input_field/password_input_field.dart';

const double _kItemExtent = 32.0;
const List<String> _vehicleTypes = ['Xe 4 Chỗ', 'Xe 7 Chỗ'];

class DriverInput extends StatefulWidget {
  const DriverInput({Key? key}) : super(key: key);
  @override
  _DriverInputState createState() => _DriverInputState();
}

class _DriverInputState extends State<DriverInput> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _referencePhoneController = TextEditingController();
  final _brandCar = TextEditingController();
  int _selectedVehicleType = 0;

  void _validateInputs() async {
    String errorMessage = '';
    if (_nameController.text.isEmpty) {
      errorMessage = 'Vui lòng điền đầy đủ thông tin';
    } else if (_passwordController.text.isEmpty) {
      errorMessage = 'Vui lòng nhập mật khẩu';
    } else if (_confirmPasswordController.text.isEmpty) {
      errorMessage = 'Vui lòng xác nhận mật khẩu';
    } else if (_passwordController.text != _confirmPasswordController.text) {
      errorMessage = 'Mật khẩu và xác nhận mật khẩu không khớp';
    } else if (_addressController.text.isEmpty) {
      errorMessage = 'Vui lòng nhập địa chỉ';
    } else if (_brandCar.text.isEmpty) {
      errorMessage = 'Vui lòng nhập hãng xe';
    }

    if (errorMessage.isNotEmpty) {
      _showErrorDialog(errorMessage);
    } else {
      // Save data to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _nameController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setString('address', _addressController.text);
      await prefs.setString('referencePhone', _referencePhoneController.text);
      await prefs.setInt('vehicleType', _selectedVehicleType);
      await prefs.setString('brandCar', _brandCar.text);

      // Change to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DriverGiayTo(),
        ),
      );
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
        child: Stack(
          children: [

            Column(
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
                            style: TextStyle(color: CupertinoColors.black),
                            controller: _nameController,
                            placeholder: 'Họ Và Tên',
                            keyboardType: TextInputType.text,
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "Nhập Mật Khẩu",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.blueGrey[600]),
                          ),
                          CupertinoTextField(
                            style: TextStyle(color: CupertinoColors.black),
                            controller: _passwordController,
                            placeholder: 'Nhập 6 Số',
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "Xác Nhận Mật Khẩu",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.blueGrey[600]),
                          ),
                          SizedBox(height: 10.0),
                          CupertinoTextField(
                            style: TextStyle(color: CupertinoColors.black),
                            controller: _confirmPasswordController,
                            placeholder: 'Nhập 6 Số',
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Divider(),
                          SizedBox(height: 20.0),
                          Center(
                            child: CupertinoTextField(
                              style: TextStyle(color: CupertinoColors.black),
                              controller:
                              _addressController, // Use different controller for address
                              placeholder: 'Địa Chỉ',
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Center(
                            child: CupertinoTextField(
                              style: TextStyle(color: CupertinoColors.black),
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
                          Row(
                            children: [
                              Text(
                                'Loại xe đăng kí:',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _selectedVehicleType == 1
                                          ? Colors.grey
                                          : Colors.transparent,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: EdgeInsets.all(6.0),
                                  child: CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () => _showDialog(
                                      CupertinoPicker(
                                        magnification: 1.22,
                                        squeeze: 1.2,
                                        useMagnifier: true,
                                        itemExtent: _kItemExtent,
                                        scrollController:
                                        FixedExtentScrollController(
                                          initialItem: _selectedVehicleType,
                                        ),
                                        onSelectedItemChanged: (int selectedItem) {
                                          setState(() {
                                            _selectedVehicleType = selectedItem;
                                          });
                                        },
                                        children: List<Widget>.generate(
                                          _vehicleTypes.length,
                                              (int index) {
                                            return Center(
                                                child: Text(_vehicleTypes[index]));
                                          },
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      _vehicleTypes[_selectedVehicleType],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Center(
                            child: CupertinoTextField(
                              style: TextStyle(color: CupertinoColors.black),
                              controller:
                              _brandCar, // Use different controller for address
                              placeholder: 'Hãng Xe',
                              keyboardType: TextInputType.text,
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

                          SizedBox(height: 10.0), // Add some space
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                'Bằng cách bấm Tiếp Theo, tôi đồng ý với điều khoản và điều kiện của ứng dụng',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black54,
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
            Positioned(
              top: 20, // Vị trí từ trên cùng
              left: 20, // Cách bên trái
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        )

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
