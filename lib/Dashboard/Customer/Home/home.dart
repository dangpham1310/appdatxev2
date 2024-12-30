import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../PickCar/pickcar.dart';
import '../Profile/noiquy.dart';
import '../Profile/chinh-sach-bao-mat.dart';
import 'News/tintuc.dart';
import 'Ads/quangcao.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onImageTap;

  HomePage({required this.onImageTap});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                imageBanner('assets/images/banner.png'),
                SizedBox(height: 5),
                sectionTitle('Dịch Vụ'),
                SizedBox(height: 5),
                serviceCard(onImageTap),
                SizedBox(height: 16),
                sectionTitle('Tin Tức'),
                SizedBox(height: 16),
                horizontalImageScroll(context),
                SizedBox(height: 16),
                sectionTitle('Quảng Cáo'),
                SizedBox(height: 16),
                horizontalImageScrollKhuyenMai(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageBanner(String assetPath) {
    return Container(
      height: 230,
      width: double.infinity,
      decoration: bannerDecoration(assetPath: assetPath),
    );
  }

  Widget sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget serviceCard(VoidCallback onTap) {
    return Container(
      height: 100,
      decoration: serviceCardDecoration(),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/icon_xeghep.png',
                  width: 50,
                  height: 50,
                ),
              ),
            ),
            Text(
              'Xe Ghép',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget horizontalImageScroll(BuildContext context) {
    return Container(
      height: 150,
      decoration: imageScrollDecoration(),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              imageThumbnailTinTuc1(
                  context, 'assets/images/tintuc1mungkhaitruong.png'),
              SizedBox(width: 10),
              imageThumbnailTinTuc2(context,
                  'assets/images/tintuc2quytrinhgiaiquyetkhieunai.png'),
              SizedBox(width: 10),
              imageThumbnailCSBM(
                  context, 'assets/images/tintuc3chinhsachbaomat.png'),
              SizedBox(width: 10),
              imageThumbnailRule(context, 'assets/images/tintuc4noiquy.png')
            ],
          ),
        ),
      ),
    );
  }

  Widget horizontalImageScrollKhuyenMai(BuildContext context) {
    return Container(
      height: 150,
      decoration: imageScrollDecoration(),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              imageThumbnailLienHeQuangCao(
                  context, 'assets/images/quangcao1lienhequangcao.png'),
              SizedBox(width: 10),
              imageThumbnailGioithieubanbe(
                  context, 'assets/images/quangcao2nggioithieu.png'),
              SizedBox(width: 10),
              imageThumbnail(context, 'assets/images/quangcao3.png'),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageThumbnail(BuildContext context, String assetPath) {
    return GestureDetector(
      onTap: () {
        // Handle image tap
      },
      child: Image.asset(
        assetPath,
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget imageThumbnailRule(BuildContext context, String assetPath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RulesPage()),
        );
      },
      child: Image.asset(
        assetPath,
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget imageThumbnailCSBM(BuildContext context, String assetPath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChinhSachPage()),
        );
      },
      child: Image.asset(
        assetPath,
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      ),
    );
  }

  BoxDecoration bannerDecoration({String? assetPath}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      image: assetPath != null
          ? DecorationImage(
              image: AssetImage(assetPath),
              fit: BoxFit.cover,
            )
          : null,
    );
  }

  BoxDecoration serviceCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    );
  }

  BoxDecoration imageScrollDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    );
  }
}
