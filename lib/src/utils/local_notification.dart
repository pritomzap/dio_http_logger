import 'package:dio_http_logger/dio_logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification{

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  LocalNotification._privateConstructor();
  // Singleton instance of the logger
  static final LocalNotification _instance = LocalNotification._privateConstructor();
  static LocalNotification get instance => _instance;
  bool _isInitialized = false;
  int _id = -1;

  Future init() async{

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (a,s,d,f){
          //DioNetworkLogger.instance.startNetworkLoggerScreen();
        }
    );
    final LinuxInitializationSettings initializationSettingsLinux =
    const LinuxInitializationSettings(
        defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (a){
        DioNetworkLogger.instance.startNetworkLoggerScreen();
    });
    _isInitialized = true;
  }

  Future showSimpleNotification(String title,String body,String payload)async{
    if(!_isInitialized) {
      return;
    }
    _id++;
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.min,
        priority: Priority.min,
        playSound: false, // Disable sound
        enableVibration: false,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    try {
      await flutterLocalNotificationsPlugin.show(
          _id, title, body, notificationDetails,
          payload: payload,
      );
    } on Exception catch (e) {
      _id = 0;
      await flutterLocalNotificationsPlugin.show(
        _id, title, body, notificationDetails,
        payload: payload,
      );
    }
  }

}