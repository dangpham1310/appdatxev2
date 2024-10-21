import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../PickCar/pickcar.dart';
import '../Profile/noiquy.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onImageTap;

  HomePage({required this.onImageTap});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // First row: Banner for ads
                FutureBuilder(
                  future: getImageUrl(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return loadingBanner();
                    } else if (snapshot.hasError) {
                      return errorBanner();
                    } else if (snapshot.hasData) {
                      return imageBanner(snapshot.data.toString());
                    } else {
                      return Container();
                    }
                  },
                ),
                SizedBox(height: 5),
                sectionTitle('Dịch Vụ'),
                SizedBox(height: 5),
                serviceCard(onImageTap),
                SizedBox(height: 16),
                sectionTitle('Tin Tức'),
                SizedBox(height: 16),
                horizontalImageScroll(context),
                SizedBox(height: 16),
                sectionTitle('Khuyến Mãi'),
                SizedBox(height: 16),
                horizontalImageScrollKhuyenMai(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widgets for loading and error banners
  Widget loadingBanner() {
    return Container(
      height: 150,
      decoration: bannerDecoration(),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget errorBanner() {
    return Container(
      height: 150,
      decoration: bannerDecoration(),
      child: Center(
        child: Text(
          'Error loading image',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget imageBanner(String imageUrl) {
    return Container(
      height: 150,
      decoration: bannerDecoration(imageUrl: imageUrl),
    );
  }

  // Helper widget to display section titles
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

  // Widget to show the service card
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

  // Horizontal image scroll widget
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
              imageThumbnailRule(
                  context, 'https://s3-hcm1-r1.longvan.net/baigiang/rule.png'),
              SizedBox(width: 10),
              imageThumbnail(context,
                  'https://s3-hcm1-r1.longvan.net/baigiang/banner.png'),
              SizedBox(width: 10),
              imageThumbnail(context,
                  'https://s3-hcm1-r1.longvan.net/baigiang/banner.png'),
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
              imageThumbnail(context,
                  'https://s3-hcm1-r1.longvan.net/baigiang/banner.png'),
              SizedBox(width: 10),
              imageThumbnail(context,
                  'https://s3-hcm1-r1.longvan.net/baigiang/banner.png'),
              SizedBox(width: 10),
              imageThumbnail(context,
                  'https://s3-hcm1-r1.longvan.net/baigiang/banner.png'),
            ],
          ),
        ),
      ),
    );
  }

  // Image thumbnail with navigation
  Widget imageThumbnail(BuildContext context, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(imageUrl: imageUrl)),
        );
      },
      child: Image.network(
        imageUrl,
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget imageThumbnailRule(BuildContext context, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RulesPage()),
        );
      },
      child: Image.network(
        imageUrl,
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      ),
    );
  }

  // Decoration helpers
  BoxDecoration bannerDecoration({String? imageUrl}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      image: imageUrl != null
          ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
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

  // Fetching image URL asynchronously
  Future<String> getImageUrl() async {
    return 'https://s3-hcm1-r1.longvan.net/baigiang/banner.png';
  }
}

// Detail page to show on image tap
class DetailPage extends StatelessWidget {
  final String imageUrl;

  DetailPage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Detail page for $imageUrl',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
