import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChinhSachPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Color(0xFF40B59F),
        middle: Text(
          'Chính Sách Bảo Mật',
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
              _buildSectionTitle('CHÍNH SÁCH BẢO MẬT THÔNG TIN'),
              _buildSubsectionTitle('ĐIỀU 1. ĐỐI TƯỢNG VÀ PHẠM VI ÁP DỤNG'),
              _buildDefinitionList([
                '1. Chính Sách Bảo Mật Thông Tin này (“Chính Sách Bảo Mật) được áp dụng cho bất kỳ tổ chức, cá nhân nào khi truy cập, đăng ký, sử dụng Dịch Vụ của Công ty TNHH LINH LONG VN (sau đây gọi là ““Đón và Đến””).',
                '2. Chính Sách Bảo Mật này được công bố tại ứng dụng “Đón và Đến” hoặc website Dantay.vn. Chính Sách Bảo Mật này có thể được sửa đổi, bổ sung bởi “Đón và Đến” tại từng thời điểm, “Đón và Đến” khuyến khích Người Dùng đọc kỹ Chính Sách Bảo Mật này và thường xuyên truy cập để cập nhật những sửa đổi, bổ sung'
              ]),
              _buildSubsectionTitle('ĐIỀU 2. GIẢI THÍCH TỪ NGỮ'),
              _buildParagraph(
                  '1. “Người Dùng”: Là cá nhân/đơn vị sử dụng Ứng Dụng'),
              _buildParagraph(
                  '2. “Dịch Vụ”: Là dịch vụ cung cấp bởi “Đón và Đến” qua ứng dụng “Đón và Đến”.'),
              _buildParagraph(
                  '3. “Dữ Liệu Người Dùng”: Là thông tin dưới dạng ký hiệu, chữ viết, chữ số, hình ảnh, âm thanh hoặc dạng tương tự trên môi trường điện tử gắn liền với một con người/tổ chức cụ thể hoặc giúp xác định một con người/tổ chức cụ thể.'),
              _buildParagraph(
                  '4. “Bên Thứ Ba”: Là tổ chức, cá nhân khác ngoài “Đón và Đến” và Người Dùng đã được giải thích theo Chính Sách Bảo Mật này.'),
              _buildParagraph(
                  'Để làm rõ, những từ ngữ chưa được giải thích tại Điều này sẽ được hiểu và áp dụng theo quy định pháp luật Việt Nam.'),
              _buildSubsectionTitle(
                  'ĐIỀU 3. PHẠM VI THU THẬP VÀ MỤC ĐÍCH SỬ DỤNG THÔNG TIN'),
              _buildParagraph(
                  '1. Để “Đón và Đến” có thể cung cấp Dịch Vụ cho Người Dùng và/hoặc xử lý các yêu cầu của Người Dùng, “Đón và Đến” có thể cần phải và/hoặc được yêu cầu phải thu thập Dữ Liệu Người Dùng (tùy từng thời điểm mà “Đón và Đến” sẽ sử dụng/yêu cầu một số thông tin), bao gồm:'),
              _buildParagraph(
                  '(i) Họ, chữ đệm và tên khai sinh, tên gọi khác (nếu có);'),
              _buildParagraph('(ii) Ngày, tháng, năm sinh;'),
              _buildParagraph('(iii) Giới tính;'),
              _buildParagraph(
                  '(iv) Nơi sinh, nơi đăng ký khai sinh, nơi thường trú, nơi tạm trú, nơi ở hiện tại, quê quán, địa chỉ liên hệ;'),
              _buildParagraph('(v) Hình ảnh cá nhân;'),
              _buildParagraph(
                  '(vi) Số điện thoại, số định danh cá nhân, số giấy phép lái xe, số biển số xe;'),
              _buildParagraph('(vii) Thông tin về tài khoản số;'),
              _buildParagraph('(viii) Tình trạng sức khỏe;'),
              _buildParagraph('(ix) Giấy tờ pháp lý của tổ chức;'),
              _buildParagraph(
                  '(x) Dữ liệu tiếp thị: Các mối quan tâm đối với quảng cáo,...'),
              _buildParagraph(
                  '2. “Đón và Đến” có thể xử lý Dữ Liệu Người Dùng cho một hoặc nhiều mục đích sau đây:'),
              _buildParagraph('(i) Cung cấp Dịch Vụ của “Đón và Đến”;'),
              _buildParagraph(
                  '(ii) Điều chỉnh, cập nhật, bảo mật và cải tiến chất lượng Dịch Vụ mà “Đón và Đến” đang cung cấp cho Người Dùng;'),
              _buildParagraph(
                  '(iii) Xác minh danh tính và đảm bảo tính bảo mật thông tin cá nhân của Người Dùng;'),
              _buildParagraph(
                  '(iv) Đáp ứng nhu cầu cần hỗ trợ của Người Dùng;'),
              _buildParagraph(
                  '(v) Thông báo cho Người Dùng về những thay đổi đối với các chính sách, Dịch Vụ mà “Đón và Đến” đang cung cấp;'),
              _buildParagraph(
                  '(vi) Đo lường, phân tích dữ liệu nội bộ và xử lý khác để cải thiện, nâng cao chất lượng Dịch Vụ của “Đón và Đến” hoặc thực hiện các hoạt động truyền thông tiếp thị;'),
              _buildParagraph(
                  '(vii) Ngăn ngừa các hoạt động phá hủy tài khoản của Người Dùng hoặc các hoạt động giả mạo Người Dùng;'),
              _buildParagraph(
                  '(viii) Liên lạc và giải quyết với Người Dùng trong những trường hợp đặc biệt;'),
              _buildParagraph(
                  '(ix) Trong trường hợp có yêu cầu của pháp luật: “Đón và Đến” có trách nhiệm hợp tác cung cấp Dữ Liệu Người Dùng khi có yêu cầu từ Cơ quan tư pháp bao gồm: Viện Kiểm sát, Tòa án, Cơ quan Công an điều tra liên quan đến hành vi vi phạm pháp luật của Người Dùng;'),
              _buildParagraph(
                  '(x) Các mục đích khác trong phạm vi cung cấp Dịch Vụ của “Đón và Đến”.'),
              _buildParagraph(
                  '“Đón và Đến” sẽ yêu cầu sự cho phép của Người Dùng trước khi sử dụng Dữ Liệu Người Dùng theo bất kỳ mục đích nào khác ngoài các mục đích đã được quy định trên vào thời điểm thu thập Dữ Liệu Người Dùng hoặc trước khi bắt đầu xử lý hoặc theo yêu cầu khác hoặc theo quy định pháp luật.'),
              // Điều 4
              _buildSubsectionTitle(
                  'ĐIỀU 4. NHỮNG NGƯỜI HOẶC TỔ CHỨC CÓ THỂ ĐƯỢC TIẾP CẬN THÔNG TIN'),
              _buildParagraph(
                  'Đối tượng được tiếp cận với Dữ Liệu Người Dùng thuộc một trong những trường hợp sau:'),
              _buildParagraph('1. Công ty TNHH LINH LONG VN.'),
              _buildParagraph(
                  '2. Các đối tác có ký hợp đồng thực hiện một phần dịch vụ do Công ty TNHH LINH LONG VN cung cấp. Các đối tác này sẽ được nhận những thông tin theo thỏa thuận hợp đồng (có thể một phần hoặc toàn bộ thông tin tùy theo nội dung hợp đồng) để tiến hành hỗ trợ Người Dùng sử dụng Dịch Vụ.'),
              _buildParagraph(
                  '3. Cơ quan Nhà nước có thẩm quyền phù hợp với quy định pháp luật.'),

// Điều 5
              _buildSubsectionTitle('ĐIỀU 5. THỜI GIAN LƯU TRỮ THÔNG TIN'),
              _buildParagraph(
                  'Dữ Liệu Người Dùng sẽ được lưu trữ cho đến khi có yêu cầu hủy hỗ hoặc tự Người Dùng đăng nhập và thực hiện hủy bỏ. Các trường hợp còn lại sẽ được bảo mật trên máy chủ của “Đón và Đến” trong khoảng thời gian cần thiết để thực hiện các mục đích trong Chính Sách Bảo Mật này, trừ khi pháp luật yêu cầu hoặc cho phép một khoảng thời gian lưu trữ lâu hơn hoặc lưu trữ có thời hạn xác định.'),
              _buildParagraph(
                  'Trường hợp Dữ Liệu Người Dùng không còn phù hợp với mục đích hoặc “Đón và Đến” không còn hoạt động kinh doanh hoặc tính pháp lý để lưu trữ Dữ Liệu Người Dùng, “Đón và Đến” sẽ thực hiện các bước để xóa/ẩn danh/ngăn chặn việc truy cập hoặc sử dụng Dữ Liệu Người Dùng cho bất kỳ mục đích nào khác ngoài việc tuân thủ theo Chính Sách Bảo Mật này và theo quy định pháp luật hiện hành.'),

// Điều 6
              _buildSubsectionTitle(
                  'ĐIỀU 6. ĐƠN VỊ THU THẬP VÀ QUẢN LÝ DỮ LIỆU NGƯỜI DÙNG'),
              _buildParagraph(
                  'Trường hợp Người Dùng có bất kỳ câu hỏi nào liên quan đến Chính Sách Bảo Mật này hoặc các vấn đề liên quan đến quyền của chủ thể dữ liệu hoặc xử lý Dữ Liệu Người Dùng, Người Dùng có thể sử dụng các hình thức liên hệ sau:'),
              _buildParagraph('Tên đơn vị: Công ty TNHH LINH LONG VN'),
              _buildParagraph('Văn phòng: 37/CL13 Đô Thị Dệt May Nam Định'),
              _buildParagraph('Số điện thoại: 0941118212'),
              _buildParagraph('Email: vuvanloind1210@gmail.com'),

// Điều 7
              _buildSubsectionTitle(
                  'ĐIỀU 7. PHƯƠNG TIỆN VÀ CÔNG CỤ ĐỂ NGƯỜI DÙNG TIẾP CẬN VÀ CHỈNH SỬA DỮ LIỆU NGƯỜI DÙNG'),
              _buildParagraph(
                  '1. Người Dùng có quyền tự kiểm tra, cập nhật, điều chỉnh hoặc hủy bỏ Dữ Liệu Người Dùng của mình bằng cách đăng nhập vào tài khoản và chỉnh sửa thông tin cá nhân hoặc yêu cầu “Đón và Đến” thực hiện việc này.'),
              _buildParagraph(
                  '2. Người Dùng có quyền gửi khiếu nại về việc lộ thông tin cá nhân cho Bên Thứ Ba đến “Đón và Đến”. Khi tiếp nhận những phản hồi này, “Đón và Đến” sẽ xác nhận lại thông tin, có trách nhiệm trả lời lý do và hướng dẫn Người Dùng khôi phục và bảo mật lại thông tin.'),

// Điều 8
              _buildSubsectionTitle('ĐIỀU 8. QUYỀN VÀ NGHĨA VỤ CỦA NGƯỜI DÙNG'),
              _buildParagraph(
                  '1. Bằng việc sử dụng Dịch Vụ của “Đón và Đến”, Người Dùng xác nhận, chấp thuận và đồng ý, cho phép “Đón và Đến” thu thập, xử lý, sử dụng, tiết lộ và lưu trữ Dữ Liệu Người Dùng theo quy định tại Chính Sách Bảo Mật này.'),
              _buildParagraph(
                  '2. Người Dùng có quyền xem, chỉnh sửa Dữ Liệu Người Dùng của mình.'),
              _buildParagraph(
                  '3. Người Dùng có quyền tự bảo vệ theo quy định của Bộ luật Dân sự 2015, luật khác có liên quan hoặc yêu cầu cơ quan, tổ chức có thẩm quyền thực hiện các phương thức bảo vệ quyền dân sự theo quy định tại Điều 11 Bộ luật Dân sự 2015.'),
              _buildParagraph(
                  '4. Người Dùng có nghĩa vụ cung cấp đầy đủ, trung thực, chính xác Dữ Liệu Người Dùng, các thông tin khác khi sử dụng Dịch Vụ của “Đón và Đến”.'),
              _buildParagraph(
                  '5. Phối hợp với “Đón và Đến”, Cơ quan Nhà nước có thẩm quyền hoặc Bên Thứ Ba trong trường hợp phát sinh các vấn đề ảnh hưởng đến tính bảo mật Dữ Liệu Người Dùng.'),

// Điều 9
              _buildSubsectionTitle(
                  'ĐIỀU 9. CAM KẾT BẢO MẬT THÔNG TIN NGƯỜI DÙNG'),
              _buildParagraph(
                  '1. Dữ Liệu Người Dùng được “Đón và Đến” cam kết bảo mật tối đa theo Chính Sách Bảo Mật này. Tuy nhiên, một số hậu quả, thiệt hại không mong muốn có thể xảy ra, bao gồm nhưng không giới hạn ở:'),
              _buildParagraph(
                  '(i) Lỗi phần cứng, phần mềm trong quá trình xử lý dữ liệu làm mất dữ liệu của Người Dùng.'),
              _buildParagraph(
                  '(ii) Lỗ hổng bảo mật nằm ngoài khả năng kiểm soát của “Đón và Đến”.'),
              _buildParagraph(
                  '(iii) Người Dùng tự làm lộ Dữ Liệu Người Dùng do bất cẩn hoặc bị lừa đảo, truy cập website/ tải các ứng dụng có chứa phần mềm độc hại,...'),
              _buildParagraph(
                  '2. Trong trường hợp máy chủ lưu trữ Dữ Liệu Người Dùng bị tấn công dẫn đến mất mát Dữ Liệu Người Dùng, “Đón và Đến” sẽ có trách nhiệm thông báo vụ việc cho Cơ quan chức năng điều tra xử lý kịp thời và thông báo cho Người Dùng được biết.'),
              _buildParagraph(
                  '3. “Đón và Đến” không sử dụng, chuyển giao, cung cấp hay chia sẻ cho Bên Thứ Ba nào về Dữ Liệu Người Dùng khi không có sự đồng ý của Người Dùng, trừ trường hợp pháp luật có quy định khác.'),
              _buildParagraph(
                  '4. “Đón và Đến” yêu cầu Người Dùng khi sử dụng Dịch Vụ của “Đón và Đến” phải cung cấp đầy đủ thông tin nêu tại Điều 3 và chịu trách nhiệm về tính pháp lý của những thông tin cung cấp. “Đón và Đến” không chịu trách nhiệm và không giải quyết mọi khiếu nại liên quan đến quyền lợi của Người Dùng nếu xét thấy tất cả các thông tin của Người Dùng đó cung cấp ban đầu là không chính xác.'),

// Điều 10
              _buildSubsectionTitle('ĐIỀU 10. ĐIỀU KHOẢN CHUNG'),
              _buildParagraph(
                  '1. Chính Sách Bảo Mật này có hiệu lực từ ngày 01 tháng 07 năm 2024. Dữ Liệu Người Dùng đã được thu thập, xử lý, sử dụng, tiết lộ và lưu trữ trước đó sẽ tiếp tục được thu thập, xử lý, sử dụng, tiết lộ và lưu trữ theo quy định của Chính Sách Bảo Mật này và quy định pháp luật hiện hành.'),
              _buildParagraph(
                  '2. Người Dùng đồng ý và hiểu rằng, Chính Sách Bảo Mật này có thể được sửa đổi, bổ sung theo từng thời kỳ bằng cách công bố trên ứng dụng “Đón và Đến”. Việc tiếp tục truy cập, đăng ký, sử dụng ứng dụng “Đón và Đến” sau khi có các sửa đổi, cập nhật hoặc điều chỉnh Chính Sách Bảo Mật này, Người Dùng đồng ý chấp nhận các sửa đổi, bổ sung từ “Đón và Đến”.'),
              _buildParagraph(
                  '3. Chính Sách Bảo Mật này không áp dụng đối với các trang thông tin điện tử, website, ứng dụng liên kết của đối tác, nhà quảng cáo, nhà tài trợ hoặc các Bên Thứ Ba khác. “Đón và Đến” không kiểm soát nội dung và không chịu trách nhiệm pháp lý đối với các hoạt động của Bên Thứ Ba có liên kết tới ứng dụng “Đón và Đến”.'),
              _buildParagraph(
                  '4. Người Dùng đã biết rõ và đồng ý rằng, Chính Sách Bảo Mật này chính là Thông báo xử lý dữ liệu cá nhân quy định tại Điều 13 Nghị định 13/2023/NĐ-CP ngày 17/4/2023. Vì vậy, “Đón và Đến” không cần thực hiện thêm bất kỳ biện pháp nào khác nhằm mục đích thông báo việc xử lý Dữ Liệu Người Dùng.'),
              _buildParagraph(
                  '5. Người dùng đã đọc và đồng ý thực hiện nghiêm túc các quy định tại Chính Sách Bảo Mật.'),
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
