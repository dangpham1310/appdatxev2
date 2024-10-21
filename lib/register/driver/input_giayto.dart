import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './done.dart';

class DriverGiayTo extends StatefulWidget {
  const DriverGiayTo({Key? key}) : super(key: key);

  @override
  _DriverGiayToState createState() => _DriverGiayToState();
}

class _DriverGiayToState extends State<DriverGiayTo> {
  List<XFile?> _images = List<XFile?>.filled(6, null);
  final _licensePlateController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  String phone = '';
  String name = '';
  String password = '';
  String role = 'driver';
  String referencePhone = '';
  String vehicleType = '';
  int vehicleSeat = 0;
  String numberPlate = '';
  String address = '';
  String brandCar = '';

  String _licensePlateError = '';
  String _imageError = '';

  @override
  void initState() {
    super.initState();
    _loadPhone();
  }

  Future<void> _pickImage(int index) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _images[index] = image;
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _loadPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = prefs.getString('phone') ?? '';
      name = prefs.getString('name') ?? '';
      password = prefs.getString('password') ?? '';
      referencePhone = prefs.getString('referencePhone') ?? '';
      address = prefs.getString('address') ?? '';
      vehicleSeat = prefs.getInt('vehicleType') ?? 0;
      brandCar = prefs.getString('brandCar') ?? '';
    });
  }

  Future<void> _sendDataToServer() async {
    var uri = Uri.parse(
        'https://api.dannycode.site/API/authentication/create_driver');
    var request = http.MultipartRequest('POST', uri)
      ..fields['phone'] = phone
      ..fields['name'] = name
      ..fields['password'] = password
      ..fields['reference'] = referencePhone
      ..fields['vehicleType'] = brandCar
      ..fields['address'] = address
      ..fields['vehicleSeat'] = vehicleSeat.toString()
      ..fields['numberPlate'] = _licensePlateController.text;

    for (int i = 0; i < _images.length; i++) {
      if (_images[i] != null) {
        request.files.add(await http.MultipartFile.fromPath(
          _getFieldNameForImage(i),
          _images[i]!.path,
        ));
      }
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Uploaded!');
    } else {
      print('Upload failed: ${response.statusCode}');
    }
  }

  String _getFieldNameForImage(int index) {
    switch (index) {
      case 0:
        return 'driverLicenseFront';
      case 1:
        return 'driverLicenseBack';
      case 2:
        return 'carFront';
      case 3:
        return 'carBack';
      case 4:
        return 'nationalCardFront';
      case 5:
        return 'nationalCardBack';
      default:
        return 'image$index';
    }
  }

  void _validateAndSubmit() {
    bool isValid = true;

    // Validate license plate
    if (_licensePlateController.text.isEmpty) {
      setState(() {
        _licensePlateError = 'Biển số xe không được để trống';
      });
      isValid = false;
    } else {
      setState(() {
        _licensePlateError = '';
      });
    }

    // Validate images
    if (_images.any((image) => image == null)) {
      setState(() {
        _imageError = 'Bạn phải chọn đầy đủ các hình ảnh';
      });
      isValid = false;
    } else {
      setState(() {
        _imageError = '';
      });
    }

    if (isValid) {
      _sendDataToServer();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DriverDone(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
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
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Biển số xe",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueGrey[300]),
                    ),
                    Center(
                      child: CupertinoTextField(
                        controller: _licensePlateController,
                        placeholder: '18A12345',
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    if (_licensePlateError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _licensePlateError,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(height: 10.0),
                    Text(
                      "Hình ảnh bằng lái xe (Mặt trước & mặt sau)",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueGrey[300]),
                    ),
                    SizedBox(height: 10.0),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _pickImage(index),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: _images[index] == null
                                    ? const Center(
                                        child: Icon(
                                          Icons.add,
                                          size: 50.0,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.file(
                                          File(_images[index]!.path),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                              ),
                              if (_images[index] != null)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _images[index] = null;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "Hình ảnh xe (Mặt trước & bên hông)",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueGrey[300]),
                    ),
                    SizedBox(height: 10.0),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _pickImage(index + 2),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: _images[index + 2] == null
                                    ? const Center(
                                        child: Icon(
                                          Icons.add,
                                          size: 50.0,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.file(
                                          File(_images[index + 2]!.path),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                              ),
                              if (_images[index + 2] != null)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _images[index + 2] = null;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    Text(
                      "Căn Cước Công Dân (Mặt trước & Mặt sau)",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueGrey[300]),
                    ),
                    SizedBox(height: 10.0),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _pickImage(index + 4),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: _images[index + 4] == null
                                    ? const Center(
                                        child: Icon(
                                          Icons.add,
                                          size: 50.0,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.file(
                                          File(_images[index + 4]!.path),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                              ),
                              if (_images[index + 4] != null)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _images[index + 4] = null;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    if (_imageError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _imageError,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(height: 20.0),
                    Center(
                      child: CupertinoButton(
                        onPressed: _validateAndSubmit,
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
                    SizedBox(height: 20.0),
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
