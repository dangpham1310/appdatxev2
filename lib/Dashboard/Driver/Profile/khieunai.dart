import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisputeResolutionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Color(0xFF40B59F),
        middle: Text(
          'Khiếu Nại',
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
              _buildSectionTitle('Nguyên tắc giải quyết'),
              _buildParagraph(
                  'Khi phát sinh tranh chấp, “Đón và Đến” đề cao giải pháp trên cơ sở thương lượng, hòa giải giữa Người Dùng và “Đón và Đến”.'),
              _buildSectionTitle('Quy trình giải quyết của “Đón và Đến”'),
              _buildStepSection('Bước 1: Khiếu nại Dịch Vụ của “Đón và Đến”', [
                'Người Dùng có thể gửi khiếu nại trực tiếp trên Ứng dụng “Đón và Đến”.',
                'Thời hiệu khiếu nại là 03 tháng kể từ ngày sử dụng Dịch Vụ hoặc phát sinh sự việc.'
              ]),
              _buildStepSection('Bước 2: Tiếp nhận, xử lý khiếu nại', [
                'Tiếp nhận yêu cầu giải quyết khiếu nại.',
                'Kiểm tra thông tin để quyết định tiếp nhận hoặc từ chối.',
                'Thông báo cho Người Dùng trong vòng 10 ngày làm việc.'
              ]),
              _buildStepSection('Bước 3: Xử lý khiếu nại', [
                'Thu thập thông tin, hình ảnh từ Người Dùng.',
                'Đưa ra phương án giải quyết và hướng khắc phục.'
              ]),
              _buildStepSection('Bước 4: Hoàn tất khiếu nại', [
                'Xác nhận kết quả và đóng khiếu nại.',
                'Nếu không giải quyết được, vụ việc có thể được chuyển tới cơ quan có thẩm quyền.'
              ]),
              _buildSectionTitle('Phân định trách nhiệm giải quyết khiếu nại'),
              _buildStepSection('', [
                '“Đón và Đến” chịu trách nhiệm giải quyết khiếu nại liên quan đến chất lượng Dịch Vụ cung cấp.',
                'Các tranh chấp giữa Người Dùng trong quá trình Giao Dịch không thuộc trách nhiệm của “Đón và Đến”.'
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

  // Utility method to create step sections
  Widget _buildStepSection(String title, List<String> steps) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ...steps.map((step) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '- $step',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: CupertinoColors.systemGrey2,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
