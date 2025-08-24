import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';

void showSuccessDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Thành công'),
        content: Text('Đặt xe thành công!'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showSuccessAnimation(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black54,
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (context, animation1, animation2) {
      return Container();
    },
    transitionBuilder: (context, animation1, animation2, child) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation1, curve: Curves.elasticOut),
        ),
        child: FadeTransition(
          opacity: animation1,
          child: _SuccessAnimationWidget(),
        ),
      );
    },
  );
}

class _SuccessAnimationWidget extends StatefulWidget {
  @override
  _SuccessAnimationWidgetState createState() => _SuccessAnimationWidgetState();
}

class _SuccessAnimationWidgetState extends State<_SuccessAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _fadeAnimation;

  List<_Confetti> _confettis = [];
  Timer? _confettiTimer;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _rotateController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _startAnimation();
    _startConfetti();
  }

  void _startAnimation() {
    _scaleController.forward();
    Future.delayed(Duration(milliseconds: 200), () {
      _rotateController.forward();
    });
    Future.delayed(Duration(milliseconds: 400), () {
      _fadeController.forward();
    });
  }

  void _startConfetti() {
    _confettiTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          _confettis.add(_Confetti());
          if (_confettis.length > 20) {
            _confettis.removeAt(0);
          }
        });
      }
    });

    // Dừng confetti sau 3 giây
    Future.delayed(Duration(seconds: 3), () {
      if (_confettiTimer != null) {
        _confettiTimer!.cancel();
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotateController.dispose();
    _fadeController.dispose();
    _confettiTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          // Confetti background
          ..._confettis.map((confetti) => confetti.build()),

          // Main success card
          Container(
            width: 280,
            height: 320,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF40B59F),
                  Color(0xFF2D8B7A),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF40B59F).withOpacity(0.4),
                  spreadRadius: 8,
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated checkmark icon
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: AnimatedBuilder(
                          animation: _rotateAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotateAnimation.value * 2 * 3.14159,
                              child: Icon(
                                CupertinoIcons.check_mark_circled_solid,
                                color: Color(0xFF40B59F),
                                size: 50,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 24),

                // Success text
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Column(
                        children: [
                          Text(
                            'Đặt Xe Thành Công!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Chuyến đi của bạn đã được xác nhận',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                SizedBox(height: 32),

                // Close button
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        width: 120,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.transparent,
                          child: Text(
                            'Hoàn Tất',
                            style: TextStyle(
                              color: Color(0xFF40B59F),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Confetti {
  final double x = Random().nextDouble() * 400;
  final double y = Random().nextDouble() * 600;
  final double size = Random().nextDouble() * 8 + 4;
  final Color color = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.cyan,
  ][Random().nextInt(8)];
  final double speed = Random().nextDouble() * 2 + 1;
  double currentY = 0;

  Widget build() {
    return Positioned(
      left: x,
      top: y + currentY,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: CustomPaint(
          painter: _ConfettiPainter(color: color),
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final Color color;

  _ConfettiPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PickCarGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('vi', 'VN'),
      ],
      home: PickCar(),
    );
  }
}

class PickCar extends StatefulWidget {
  @override
  _PickCarState createState() => _PickCarState();
}

class _PickCarState extends State<PickCar> {
  TextEditingController _bookingController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _customerPhoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submitBooking() async {
    if (_bookingController.text.trim().isEmpty) {
      _showErrorDialog('Vui lòng nhập thông tin đặt xe');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Xử lý giá tiền - nếu để trống thì mặc định là 0
      String priceText = _priceController.text.trim();
      String finalPrice = priceText.isEmpty ? '0' : priceText;

      // Lưu thông tin vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('price', finalPrice);

      await prefs.setString('booking_info', _bookingController.text.trim());
      await prefs.setString(
          'customer_phone', _customerPhoneController.text.trim());

      // Luôn đặt thời gian gửi đi là thời gian hiện tại + 15 phút
      final DateTime sendTime = DateTime.now().add(Duration(minutes: 15));

      String formattedDate = DateFormat('dd/MM/yyyy').format(sendTime);
      // Format time để khớp với yêu cầu của server Python (%H:%M)
      String formattedTime = DateFormat('HH:mm').format(sendTime);

      // Gửi API call đến /api/pickcar
      String phonenumberpick = prefs.getString('phone') ?? '';
      final response = await http.post(
        Uri.parse('https://api.donvaden.net/api/pickcar'), // URL API thực tế
        body: {
          'pickUp': '0',
          'pickDrop': '0',
          'date': formattedDate,
          'time': formattedTime, // Sẽ có dạng HH:mm, ví dụ: 14:05
          'numberofSeat': '4', // Mặc định 4 ghế
          'price': finalPrice,
          'phonenumber': _customerPhoneController.text.trim().isEmpty
              ? 'N/A'
              : _customerPhoneController.text.trim(),
          'phonenumberpick': phonenumberpick, // Số điện thoại từ SharedPreferences
          'note': _bookingController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        if (response.body == 'Data saved successfully') {
          showSuccessAnimation(context);

          // Clear form
          _bookingController.clear();
          _priceController.clear();
          _customerPhoneController.clear();
        } else {
          // Xử lý trường hợp response body không như mong đợi
          _showErrorDialog('Đặt xe thất bại: ${response.body}');
        }
      } else {
        _showErrorDialog('Đặt xe thất bại: HTTP ${response.statusCode}');
      }

      String url2 = 'https://api.donvaden.net/api/sendNotification';

      final response2 = await http.post(
        Uri.parse(url2),
        body: {
          'pickUp': '0',
          'pickDrop': '0',
          "pickphone": phonenumberpick,
        },
      );


      try {
        final response = await http.post(
          Uri.parse('https://api.donvaden.net/api/getLastestHistory'),
          body: {
            'accessToken': prefs.getString('accessToken') ??
                '', // Get the stored access token
            'FCMToken':
                prefs.getString('FCMToken') ?? '', // Get the stored FCM token
          },
        );

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          // Handle the response if needed
          print('Response from server: $responseBody');
        } else {
          print('Failed to send tokens. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error occurred: $e');
      }
    } catch (e) {
      _showErrorDialog('Có lỗi xảy ra: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Lỗi'),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticBackgroundVisibility: false,
        middle: Text(
          'Đặt Xe',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 136, 122),
        // Disable the leading back button in the navigation bar
        automaticallyImplyLeading: false,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Main Form
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form fields - simplified
                    _buildSimpleField(
                      'Thông tin chuyến đi',
                      '"Thời gian", "Số lượng khách", "Điểm đón", "Điểm Đến", "Giá Tiền"',
                      _bookingController,
                      CupertinoIcons.location_solid,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),

                    SizedBox(height: 16),

                    _buildSimpleField(
                      'Giá tiền',
                      'Để trống nếu miễn phí',
                      _priceController,
                      CupertinoIcons.money_dollar,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                      suffix: Text(' nghìn đồng', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ),

                    SizedBox(height: 16),

                    _buildSimpleField(
                      'Số điện thoại khách',
                      'Để trống nếu dùng số của bạn',
                      _customerPhoneController,
                      CupertinoIcons.phone_solid,
                      keyboardType: TextInputType.phone,
                    ),

                    SizedBox(height: 32),

                    // Đặt Xe button
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CupertinoButton(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent,
                        padding: EdgeInsets.zero,
                        child: _isLoading
                            ? CupertinoActivityIndicator(color: Colors.white)
                            : Text(
                                'Xác nhận đặt xe',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                        onPressed: _isLoading ? null : _submitBooking,
                      ),
                    ),

                    SizedBox(height: 20),

                    // Important notes
                    _buildImportantNotes(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleField(String label, String hint,
      TextEditingController controller, IconData icon,
      {TextInputType? keyboardType, int? maxLines, List<TextInputFormatter>? inputFormatters, Widget? suffix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.teal,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        CupertinoTextField(
          controller: controller,
          style: TextStyle(color: Colors.black87, fontSize: 14),
          placeholder: hint,
          placeholderStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          keyboardType: keyboardType,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          suffix: suffix,
          suffixMode: OverlayVisibilityMode.always,
        ),
      ],
    );
  }

  Widget _buildImportantNotes() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.exclamationmark_triangle_fill,
                color: Colors.red.shade600,
                size: 14,
              ),
              SizedBox(width: 6),
              Text(
                'Lưu ý quan trọng',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          _buildNoteItem(
              '• Anh em chỉ đặt cuốc cùng nội dung 15\' 1 lần, nếu muốn đổi lại thông tin đặt xe thì huỷ chuyến đi đã đặt trong phần lịch sử rồi hẳng đặt lại'),
          _buildNoteItem('• Nghiêm cấm tình trạng spam chuyến đi nhiều lần.'),
          _buildNoteItem('• Tất cả mọi thắc mắc liên hệ Ad và ban key sdt'),
          SizedBox(height: 6),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '0941118212',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "• ",
            style: TextStyle(
              fontSize: 11,
              color: Colors.red.shade600,
              height: 1.3,
            ),
          ),
          Expanded(
            child: Text(
              text.startsWith('• ') ? text.substring(2) : text,
              style: TextStyle(
                fontSize: 11,
                color: Colors.red.shade600,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
