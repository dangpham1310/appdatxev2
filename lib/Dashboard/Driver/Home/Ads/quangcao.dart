import 'package:flutter/material.dart';

Widget imageThumbnailGioithieubanbe(BuildContext context, String assetPath) {
  return GestureDetector(
    onTap: () {
      if (assetPath == 'assets/images/quangcao2nggioithieu.png') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GioiThieuBanBe()),
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

Widget imageThumbnailLienHeQuangCao(BuildContext context, String assetPath) {
  return GestureDetector(
    onTap: () {
      if (assetPath == 'assets/images/quangcao1lienhequangcao.png') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LienHeQuangCao()),
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

class GioiThieuBanBe extends StatelessWidget {
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
                '🌟 Giới thiệu bạn bè - Nhận ngay 8% cho mỗi chuyến đi! 🌟',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Giờ đây, bạn có thể vừa chia sẻ trải nghiệm đi lại tiện lợi, vừa nhận thưởng hấp dẫn từ ứng dụng của chúng tôi! '
                'Chỉ cần giới thiệu bạn bè tham gia và đặt xe, bạn sẽ nhận ngay **8% giá trị mỗi cuốc xe** mà người đó thực hiện!',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '🚀 Cách tham gia rất dễ dàng:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '1. Bạn chỉ cần đặt xe cho bạn bè.\n'
                '2. Khi người được giới thiệu đặt chuyến xe đầu tiên, bạn sẽ tự động nhận **8% giá trị chuyến đi** vào tài khoản của mình.\n'
                '3. Số tiền thưởng tích lũy có thể sử dụng để đặt chuyến tiếp theo hoặc rút về!',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '💸 Càng nhiều bạn bè tham gia, phần thưởng của bạn càng lớn! '
                'Hãy lan tỏa niềm vui di chuyển và nhận ngay phần thưởng hấp dẫn nhé!',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Nhanh tay đặt xe hay giới thiệu ứng dụng cho bạn bè và cùng nhau khám phá các hành trình mới nào!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LienHeQuangCao extends StatelessWidget {
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
                'Treo Banner quảng cáo trên trang chủ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Trong thế giới di động ngày nay, việc tiếp cận khách hàng thông qua quảng cáo trực tuyến không chỉ là một chiến lược kinh doanh mà là một yếu tố quyết định thành công. '
                'Đón Và Đến App không chỉ là ứng dụng đặt phòng xuất sắc, mà còn là nền tảng quảng cáo linh hoạt, giúp doanh nghiệp kết nối hiệu quả với khách hàng mục tiêu.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '🌟 Chiến Lược Đa Dạng:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Với Đón Và Đến, chúng tôi hiểu rằng mỗi doanh nghiệp đều độc đáo và đòi hỏi một chiến lược quảng cáo riêng biệt. '
                'Do đó, chúng tôi cung cấp nhiều lựa chọn quảng cáo, từ quảng cáo trực tiếp trên ứng dụng, quảng cáo mạng xã hội, đến email marketing và quảng cáo trực tuyến. '
                'Đội ngũ chuyên gia của chúng tôi sẽ tư vấn và phát triển chiến lược phù hợp nhất với mục tiêu kinh doanh của bạn.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '📊 Hiệu Suất Đo Lường và Tối Ưu Hóa:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Với sự chú ý đặc biệt đến hiệu suất, Đón Và Đến App không chỉ giúp bạn đưa thông điệp đến đúng đối tượng mục tiêu mà còn cung cấp các công cụ đo lường chi tiết. '
                'Bạn có thể theo dõi sự tương tác, tỷ lệ chuyển đổi và nhiều chỉ số quan trọng khác để đảm bảo mỗi đồng quảng cáo đều mang lại giá trị tối đa.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '✨ Sự Kết Hợp Sáng Tạo và Chiến Lược:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Đón Và Đến không chỉ là nơi đặt phòng, mà còn là sân chơi cho sự sáng tạo. '
                'Chúng tôi kêu gọi doanh nghiệp thể hiện bản sắc của mình thông qua quảng cáo độc đáo. '
                'Đội ngũ sáng tạo của chúng tôi sẵn sàng hỗ trợ bạn xây dựng chiến dịch sáng tạo, nổi bật và gây ấn tượng với khách hàng.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '🤝 Kết Nối Với Khách Hàng Mục Tiêu:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Dưới định hình của chúng tôi, quảng cáo không chỉ là việc truyền đạt thông điệp mà còn là cơ hội để xây dựng mối quan hệ với khách hàng. '
                'Với Đón Và Đến, chúng tôi giúp bạn tạo ra sự kết nối sâu sắc và tăng cường lòng trung thành của khách hàng đối với thương hiệu của bạn.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '📞 Liên hệ: 0941118212',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Hãy để Đón Và Đến App trở thành đối tác tiếp thị của bạn, giúp doanh nghiệp của bạn nổi bật và kết nối mạnh mẽ với khách hàng. '
                'Kết nối ngay hôm nay và khám phá sức mạnh của quảng cáo đa dạng và hiệu quả trên nền tảng của chúng tôi.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
