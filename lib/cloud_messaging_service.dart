import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CloudMessagingService{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void onSelectNotification(NotificationResponse response) {

    print("Notification clicked: ${response.payload}");

  }

  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'appdatxe-3be95',
      'com.example.push_notification', // Replace with your channel name
      description:
      'Your Channel Description', // Replace with your channel description
      importance: Importance.max,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  void initialize()async {
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
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

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);

    });
    String? deviceToken = await firebaseMessaging.getToken();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(">>>>>>>>>>deviceToken: $deviceToken");
    prefs.setString('FCMToken', deviceToken??"");
    await firebaseMessaging.getInitialMessage().then((RemoteMessage? message){
      onSelectNotification(NotificationResponse(
        payload: message?.data['payload'],
        notificationResponseType: NotificationResponseType.selectedNotification,
      ));
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      showNotification(message);
    });
    Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      showNotification(message);
    }
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );


    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

  }

  void showNotification(RemoteMessage message)async{
    String title = message.notification?.title??"";
    String body = message.notification?.body??"";
    int hashCode = message.notification.hashCode;
    await createNotificationChannel();
    await flutterLocalNotificationsPlugin.show(
      hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'appdatxe-3be95',
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
}