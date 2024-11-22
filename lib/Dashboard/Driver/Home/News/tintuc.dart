import 'package:flutter/material.dart';

Widget imageThumbnailTinTuc1(BuildContext context, String assetPath) {
  return GestureDetector(
    onTap: () {
      if (assetPath == 'assets/images/tintuc1mungkhaitruong.png') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TinTuc1Page()),
        );
      }
    },
    child: Image.asset(
      assetPath,
      width: 150,
      height: 150,
      fit: BoxFit.cover,
    ),
  );
}

Widget imageThumbnailTinTuc2(BuildContext context, String assetPath) {
  return GestureDetector(
    onTap: () {
      if (assetPath == 'assets/images/tintuc2quytrinhgiaiquyetkhieunai.png') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TinTuc2Page()),
        );
      }
    },
    child: Image.asset(
      assetPath,
      width: 150,
      height: 150,
      fit: BoxFit.cover,
    ),
  );
}

class TinTuc1Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🎉 Khai trương ứng dụng Đón Và Đến - Nhận ngay ưu đãi 10% 🎉',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Chúng tôi vui mừng giới thiệu ứng dụng đặt xe Đón Và Đến – giải pháp di chuyển tiện lợi và an toàn cho mọi hành trình của bạn! '
                'Để chào mừng sự ra mắt này, Đón Và Đến mang đến chương trình khuyến mại đặc biệt: Giảm ngay 10% giá trị mỗi cuốc xe khi bạn đặt chuyến qua ứng dụng!',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '🚗 Cách nhận ưu đãi:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '1. Tải ngay ứng dụng Đón Và Đến từ App Store hoặc Google Play.\n'
                '2. Đặt xe và trải nghiệm dịch vụ với ưu đãi 10% được áp dụng tự động.\n'
                '3. Thoải mái di chuyển, an tâm tận hưởng dịch vụ với mức giá siêu hấp dẫn!',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '📱 Nhanh tay tải app Đón Và Đến để không bỏ lỡ ưu đãi và bắt đầu hành trình thuận tiện, dễ dàng cùng chúng tôi ngay hôm nay!',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Đón Và Đến - Cùng bạn đi bất cứ đâu!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class TinTuc2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🎉 Khai trương ứng dụng Đón Và Đến - Nhận ngay ưu đãi 10% 🎉',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Chúng tôi vui mừng giới thiệu ứng dụng đặt xe Đón Và Đến – giải pháp di chuyển tiện lợi và an toàn cho mọi hành trình của bạn! '
                'Để chào mừng sự ra mắt này, Đón Và Đến mang đến chương trình khuyến mại đặc biệt: Giảm ngay 10% giá trị mỗi cuốc xe khi bạn đặt chuyến qua ứng dụng!',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '🚗 Cách nhận ưu đãi:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '1. Tải ngay ứng dụng Đón Và Đến từ App Store hoặc Google Play.\n'
                '2. Đặt xe và trải nghiệm dịch vụ với ưu đãi 10% được áp dụng tự động.\n'
                '3. Thoải mái di chuyển, an tâm tận hưởng dịch vụ với mức giá siêu hấp dẫn!',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '📱 Nhanh tay tải app Đón Và Đến để không bỏ lỡ ưu đãi và bắt đầu hành trình thuận tiện, dễ dàng cùng chúng tôi ngay hôm nay!',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Đón Và Đến - Cùng bạn đi bất cứ đâu!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
