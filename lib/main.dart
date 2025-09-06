import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:water_reminder/cloud_messaging_service.dart';
import 'package:water_reminder/firebase_options.dart';
import 'package:water_reminder/register/welcome.dart';

import 'register/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final CloudMessagingService cloudMessagingService = CloudMessagingService();
  cloudMessagingService.initialize();

  // await initializePushNotifications();
  initializeDateFormatting('vi', null);

  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.activeBlue,
        barBackgroundColor: CupertinoColors.white, // Thanh bar nền trắng
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(color: CupertinoColors.black), // Chữ màu đen
        ),
      ),
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: <Locale>[
        Locale('vi', 'VN'), // Hỗ trợ Tiếng Việt
      ],
      home: Welcome(), // Chuyển sang MaterialApp trong MyApp
    );
  }
}

void requestNotificationPermission() async {
  await Permission.notification.request();
}

// Create a notification channel
Future<void> createNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'appdatxe-da791',
    'com.example.push_notification', // Replace with your channel name
    description:
        'Your Channel Description', // Replace with your channel description
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}
