import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'done.dart';

class DriverGiayTo extends StatefulWidget {
  const DriverGiayTo({Key? key}) : super(key: key);

  @override
  _DriverGiayToState createState() => _DriverGiayToState();
}

class _DriverGiayToState extends State<DriverGiayTo> {
  List<XFile?> _images =
      List<XFile?>.filled(6, null); // Separate list to track images
  final _licensePlateController = TextEditingController();
  final _addressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images[index] = image;
      });
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
                    SizedBox(height: 20.0),
                    Center(
                      child: CupertinoButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DriverDone(),
                            ),
                          );
                        },
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
