import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RulesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Color(0xFF40B59F),
        middle: Text(
          'Nội Quy Ứng Dụng',
          style: TextStyle(color: CupertinoColors.white),
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildSectionTitle('CÁC HÀNH VI VI PHẠM VÀ CHẾ TÀI XỬ PHẠT'),
              _buildSubsectionTitle('1. Định nghĩa:'),
              _buildDefinitionList([
                "“Cty TNHH LINH LONG VN”: Là Công ty Trách nhiệm hữu hạn Linh Long VN sở hữu ứng dụng “Đón và Đến”. Gọi tên thay thế là \"Đón và Đến\".",
                "“Ứng Dụng/Ứng Dụng “Đón và Đến””: Là Ứng Dụng “Đón và Đến” của “Đón và Đến”.",
                "“Người Dùng”: Là cá nhân/đơn vị sử dụng Ứng Dụng.",
                "“Tài Khoản”: Là tài khoản của Người Dùng được tạo lập và sử dụng trên Ứng Dụng.",
                "“Dịch Vụ Vận Tải”: Là việc Người Dùng cung cấp dịch vụ vận chuyển hàng hóa, vật phẩm, con người bằng phương tiện giao thông đường bộ của mình.",
                "“Giao Dịch”: Là thỏa thuận giữa 02 (hai) hay nhiều Người Dùng trong việc thực hiện Dịch Vụ Vận Tải trên Ứng Dụng.",
                "“Dịch Vụ”: Là dịch vụ cung cấp bởi “Đón và Đến” qua Ứng Dụng.",
                "“Bên Nhận Chuyến”: Là bên tiếp nhận và thực hiện Dịch vụ Vận Tải trên thông tin chuyến xe được cung cấp.",
                "“Bên Đẩy Chuyến”: Là bên có thông tin về chuyến xe bao gồm: thông tin khách hàng, điểm đón, điểm đến, hành trình vận chuyển, giá cước, loại xe, các thông tin theo yêu cầu của “Đón và Đến”.",
                "“Vi phạm Lần 2”: Là việc lặp lại hành vi vi phạm của Người Dùng trong thời hạn 30 ngày kể từ thời điểm xác định hoặc bị xử lý về hành vi vi phạm lần đầu tiên."
              ]),
              _buildSubsectionTitle(
                  '2. Quy định về hành vi vi phạm và chế tài xử phạt:'),
              _buildParagraph(
                  '“Đón và Đến” quy định cụ thể các hành vi không được phép đối với Người Dùng khi sử dụng Dịch Vụ của “Đón và Đến” trên Ứng Dụng “Đón và Đến”. Các hành vi vi phạm và chế tài xử phạt có thể được sửa đổi, bổ sung theo từng thời kỳ.'),
              _buildSubsectionTitle('A. Thái độ và hành vi ứng xử'),
              _buildViolationList([
                "Có những phát ngôn, hình ảnh, hành vi (cố ý hay vô ý) có thể gây tổn hại đến hình ảnh, uy tín, thương hiệu của công ty hoặc Người Dùng.",
                "Thiếu tôn trọng, đe dọa hoặc gây rối đối với ứng dụng hoặc Người Dùng.",
                "Sử dụng thông tin trên ứng dụng để làm phiền hoặc quấy rối các bên liên quan."
              ]),
              _buildPenaltyList([
                "Lần 1: Phạt tiền từ 100,000 VND đến 500,000 VND.",
                "Lần 2: Đơn phương chấm dứt hợp đồng, giữ lại tiền cọc để đền bù thiệt hại."
              ]),
              _buildSubsectionTitle('B. Các hành vi gian lận'),
              _buildViolationList([
                "Sử dụng ứng dụng cho mục đích gian lận hoặc vi phạm quy định.",
                "Cung cấp thông tin không trung thực khi đăng ký hoặc sử dụng ứng dụng.",
                "Tự ý chuyển nhượng tài khoản Người Dùng cho bên thứ ba.",
                "Lợi dụng chương trình khuyến mãi hoặc sự kiện của “Đón và Đến” để trục lợi bất chính."
              ]),
              _buildPenaltyList([
                "Lần 1: Cảnh cáo, phạt tiền từ 100,000 VND đến 500,000 VND.",
                "Lần 2: Chấm dứt hợp đồng và giữ lại tiền cọc."
              ]),
              _buildSubsectionTitle('C. Về việc sử dụng ứng dụng'),
              _buildViolationList([
                "Gửi tin nhắn rác hoặc nội dung không liên quan đến giao dịch.",
                "Sử dụng thông tin người dùng hoặc khách hàng để trục lợi.",
                "Nhận chuyến xe nhưng không thực hiện giao dịch hoặc thực hiện sai thỏa thuận."
              ]),
              _buildPenaltyList([
                "Lần 1: Phạt tiền từ 100,000 VND đến 500,000 VND.",
                "Lần 2: Đơn phương chấm dứt hợp đồng và giữ lại tiền cọc."
              ]),
            ],
          ),
        ),
      ),
    );
  }

  // Utility method to create section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.black,
        ),
      ),
    );
  }

  // Utility method to create subsection titles
  Widget _buildSubsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }

  // Utility method to create paragraphs
  Widget _buildParagraph(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 16.0,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }

  // Utility method to create lists of violations or definitions
  Widget _buildViolationList(List<String> violations) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: violations
            .map((violation) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    "- $violation",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: CupertinoColors.systemGrey2,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  // Utility method to create penalty lists
  Widget _buildPenaltyList(List<String> penalties) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: penalties
            .map((penalty) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    "- $penalty",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: CupertinoColors.systemRed,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  // Utility method to create definition lists
  Widget _buildDefinitionList(List<String> definitions) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: definitions
            .map((definition) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    "- $definition",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: CupertinoColors.systemGrey2,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
