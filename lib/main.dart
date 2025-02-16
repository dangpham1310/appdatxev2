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

// Top-level function to handle background messages
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   print('Handling a background message: ${message.messageId}');
// }

class NotificationController {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotifications() async {
    // Initialize Firebase


    // Initialize Firebase Messaging
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request notification permissions
    await messaging.requestPermission();

    // Set up the background message handler
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'appdatxe-da791',
              'com.example.push_notification', // Replace with your channel name
              channelDescription: 'Your Channel Description',
              importance: Importance.max,
              priority: Priority.high,
              showWhen: true,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(),
          ),
        );
      }
    });
  }

  static void onSelectNotification(NotificationResponse response) {
    // Handle notification tapped logic here
    print("Notification clicked: ${response.payload}");
    // Navigate to specific screen or perform any action based on payload
  }

  // Request Firebase Token
  static Future<String> requestFirebaseToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    
    String? token = await messaging.getToken();
    print('FCM Token: $token');
    if (token != null) {
      print('FCM Token: $token');
      return token;
    }
    return '';
  }
}
Future<void>initializePushNotifications()async{
  await createNotificationChannel();
  await NotificationController.initializeNotifications();

  final token = await NotificationController.requestFirebaseToken();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('FCMToken', token);
  print("FCMToken ");
  print(token);

   // Initialize date formatting for Vietnamese

  // Handle notification when app is terminated
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    NotificationController.onSelectNotification(NotificationResponse(
      payload: initialMessage.data['payload'],
      notificationResponseType: NotificationResponseType.selectedNotification,
    ));
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final CloudMessagingService cloudMessagingService = CloudMessagingService();
  cloudMessagingService.initialize();

  // await initializePushNotifications();
  initializeDateFormatting(
      'vi', null);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
    theme: CupertinoThemeData(

      brightness: Brightness.light, // Chỉ dùng chế độ sáng
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
