import 'package:flutter/material.dart';
import '../../Profile/khieunai.dart';

Widget imageThumbnailTinTuc1(BuildContext context, String assetPath) {
  return GestureDetector(
    onTap: () {
      if (assetPath == 'assets/images/hdsd.jpg') {
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
          MaterialPageRoute(builder: (context) => DisputeResolutionPage()),
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
      appBar: AppBar(
        title: Text(
          'Hướng Dẫn Đặt Xe',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hướng dẫn đặt xe:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildStep('1. Nhập địa điểm Đón và Đến',
                  'Tại giao diện chính, nhập địa điểm Đón và Đến cụ thể vào các ô tương ứng.\n\nỨng dụng sẽ gợi ý các địa điểm có sẵn, hãy chọn điểm phù hợp mà ứng dụng đưa ra.'),
              _buildStep('2. Chọn ngày giờ khởi hành',
                  'Chọn ngày giờ bạn cần đi. Bạn có thể tùy chỉnh theo nhu cầu cá nhân. Hãy lên kế hoạch cụ thể cho chuyến đi của bạn.'),

              Image.asset(
                'assets/images/hinh1.jpg',
              ),

              SizedBox(height: 16),
              _buildStep('3. Chọn số ghế và giá',
                  'Chọn số ghế muốn đặt.\n\nỨng dụng sẽ hiển thị giá ước lượng (ví dụ: 534 nghìn VND). Bạn chỉ cần nhập 550.\n\nLưu ý: Giá bạn trả nên cao hơn giá ước lượng, làm tròn số tiền hoặc thêm một khoản nhỏ sẽ giúp lái xe tăng thêm thu nhập.'),
              _buildStep('4. Nhập số điện thoại',
                  'Nhập số điện thoại của người đi để lái xe có thể liên hệ. Để trống nếu chính bạn là người đi.\n\nNếu đặt hộ (bắn cuốc), số điện thoại này sẽ là phương thức để lái xe liên lạc trực tiếp với người được đặt.'),
              _buildStep('5. Thêm ghi chú nếu cần thiết',
                  'Có thể thêm ghi chú về hành lý đặc biệt như: mang theo mèo, balo to,...\n\nCuối cùng là Đặt Xe và Xác nhận.'),
              Image.asset(
                'assets/images/hinh2.jpg',
              ),
              _buildStep('6. Xem lại và quản lý chuyến đi',
                  'Sau khi đặt, bạn có thể vào phần Lịch sử để kiểm tra thông tin chi tiết chuyến đi, lái xe đón, biển số xe,...\n\nTrong mục này, bạn có thể:\n- Hủy chuyến.\n- Gọi điện cho lái xe.\n- Báo cáo vấn đề cho nhà phát triển nếu cần thiết.'),
              SizedBox(height: 16),
              Image.asset(
                'assets/images/hinh3.jpg',
              ),
              Text(
                'Hãy đọc kỹ hướng dẫn sử dụng để thao tác dễ dàng trên ứng dụng.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildStep(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}