import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_reminder/main.dart';

import 'Dashboard/Driver/Receive/receivedv2.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("🔔 Background message: ${message.messageId}");
}

class CloudMessagingService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void onSelectNotification(NotificationResponse response) {
    if (response.payload == "Driver") {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => ListReceive(
            pickUpLocation: "",
            dropOffLocation: "",
            selectedTime: TimeOfDay.now(),
            selectedDate: DateTime.now(),
          ),
        ),
      );
    }
  }

  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'appdatxe-3be95', // id
      'App Đặt Xe',
      description: 'Kênh thông báo mặc định',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> initialize() async {
    // 🔹 Request permission
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // 🔹 Init local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );

    // 🔹 Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    // 🔹 Save token
    String? deviceToken = await firebaseMessaging.getToken();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(">>>>>>>>>>deviceToken: $deviceToken");
    prefs.setString('FCMToken', deviceToken ?? "");

    // 🔹 Initial message (app terminated → opened by notification)
    RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      onSelectNotification(NotificationResponse(
        payload: initialMessage.data['contents'],
        notificationResponseType: NotificationResponseType.selectedNotification,
      ));
    }

    // 🔹 App in background → opened by notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(">>>>>>>>>>data2: ${message.data}");
      onSelectNotification(NotificationResponse(
        payload: message.data['contents'],
        notificationResponseType: NotificationResponseType.selectedNotification,
      ));
    });

    // 🔹 Background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 🔹 Request FCM permission
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    String title = message.notification?.title ?? "";
    String body = message.notification?.body ?? "";

    await createNotificationChannel();

    await flutterLocalNotificationsPlugin.show(
      message.hashCode, // id
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'appdatxe-3be95',
          'App Đặt Xe',
          channelDescription: 'Kênh thông báo mặc định',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: message.data['contents'] ?? "",
    );
  }
}
