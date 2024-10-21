import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class CongratulationPage extends StatefulWidget {
  final String id;

  CongratulationPage(this.id);

  @override
  _CongratulationPageState createState() => _CongratulationPageState();
}

class _CongratulationPageState extends State<CongratulationPage> {
  Map<String, dynamic>? travelData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTravelData(widget.id);
  }

  Future<void> fetchTravelData(String id) async {
    final url = Uri.parse('https://api.dannycode.site/get-history');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id}),
      );

      if (response.statusCode == 200) {
        setState(() {
          travelData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load travel data');
      }
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "Nhận Chuyến Thành Công",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF40B59F),
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
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : travelData == null
                ? Center(child: Text('Error loading data'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildIconSection(),
                        const SizedBox(height: 20),
                        _buildTextSection(),
                        const SizedBox(height: 20),
                        _buildInfoRows(),
                        const SizedBox(height: 20),
                        _buildButtons(),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildIconSection() {
    return Icon(
      CupertinoIcons.check_mark_circled_solid,
      size: 100,
      color: Color(0xFF40B59F),
    );
  }

  Widget _buildTextSection() {
    return Column(
      children: [
        Text(
          "Chúc Mừng!",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF40B59F),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Bạn đã nhận chuyến thành công!",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoRows() {
    return Card(
      elevation: 2,
      color: Color(0xFFE8F5E9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(
              icon: CupertinoIcons.location_solid,
              label: "Điểm đón:",
              value: travelData!['pickUp'],
            ),
            _buildInfoRow(
              icon: CupertinoIcons.location_solid,
              label: "Điểm đến:",
              value: travelData!['pickDrop'],
            ),
            _buildInfoRow(
              icon: CupertinoIcons.time,
              label: "Thời gian:",
              value: travelData!['time'],
            ),
            _buildInfoRow(
              icon: CupertinoIcons.money_dollar_circle,
              label: "Giá cước:",
              value: "${travelData!['price']} VND",
            ),
            _buildInfoRow(
              icon: CupertinoIcons.phone,
              label: "Số điện thoại khách:",
              value: travelData!['phonenumber'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: CupertinoColors.systemGrey),
              color: Color(0xFF40B59F),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        CupertinoButton(
          color: Color(0xFF40B59F),
          child: Text("Gọi khách"),
          onPressed: () {
            _launchCaller(travelData!['phonenumber']);
          },
        ),
        const SizedBox(height: 20),
        CupertinoButton(
          color: Color(0xFF40B59F),
          child: Text("Quay lại trang chính"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _launchCaller(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
