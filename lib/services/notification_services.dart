import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:to_do_app_v2/ui/pages/notification_screen.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import '../models/task.dart';

class NotifyHelper {
  //Instances
  static final flutterNotificationService = FlutterLocalNotificationsPlugin();
  String selectedNotificationPayload = '';
  static final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  //Methods

  //Initialze
  static intializeTimeZone() async {
    String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    _configureSelectNotificationSubject();
    await _configureLocalTimeZone();
  }

  static Future<void> intialize() async {
    await _configureLocalTimeZone();
    _configureSelectNotificationSubject();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('mipmap/ic_launcher');
    const DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: darwinInitializationSettings);

    await flutterNotificationService.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  //Notification Details
  static Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('id', 'tasks',
            channelDescription: 'reminder for your tasks',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true);
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    return const NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload == null) {
      debugPrint('notification payload: $payload');
      return;
    }
    debugPrint('notification payload: $payload');
    selectNotificationSubject.add(payload!);

    Get.to(NotificationScreen(payload: payload));
  }

  //Show Notification
  static Future<void> showNotification({
    required String title,
    required String body,
    required String? payload,
  }) async {
    var details = await _notificationDetails();

    await flutterNotificationService.show(1, title, body, details,
        payload: payload);
  }

  //Scheduling Notification
  static Future<void> showScheduleNotification(
      {required Task task, required int minutes, required int hour}) async {
    print('showScheduleNotification Method called ${task.id}');
    var details = await _notificationDetails();
    var time = tz.TZDateTime.now(tz.local);
    await flutterNotificationService.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      _nextInstanceOfTenAM(
          hour, minutes, task.remind!, task.repeat!, task.date!),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}|${task.startTime}|',
    );
    print('showScheduleNotification Method ended ${task.id}');
  }

  static tz.TZDateTime _nextInstanceOfTenAM(
      int hour, int minutes, int reminder, String repeat, String date) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    DateTime formattedDate = DateFormat.yMd().parse(date);

    final tz.TZDateTime fd = tz.TZDateTime.from(formattedDate, tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, fd.year, fd.month, fd.day, hour, minutes);

    scheduledDate = afterRemind(reminder, scheduledDate);

    if (scheduledDate.isBefore(now)) {
      if (repeat == 'Daily') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
            (formattedDate.day) + 1, hour, minutes);
      }
      if (repeat == 'Weekly') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
            (formattedDate.day) + 7, hour, minutes);
      }
      if (repeat == 'Monthly') {
        scheduledDate = tz.TZDateTime(tz.local, now.year,
            (formattedDate.month) + 1, formattedDate.day, hour, minutes);
      }
      scheduledDate = afterRemind(reminder, scheduledDate);
    }

    print('Date : $scheduledDate');
    return scheduledDate;
  }

  static tz.TZDateTime afterRemind(int reminder, tz.TZDateTime scheduledDate) {
    switch (reminder) {
      case 10:
        scheduledDate = scheduledDate.subtract(Duration(minutes: reminder));
        break;
      case 15:
        scheduledDate = scheduledDate.subtract(Duration(minutes: reminder));
        break;
      case 20:
        scheduledDate = scheduledDate.subtract(Duration(minutes: reminder));
        break;
      default:
        scheduledDate = scheduledDate.subtract(const Duration(minutes: 5));
    }
    return scheduledDate;
  }

  static Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  static _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      debugPrint('My payload is ' + payload);
      await Get.to(() => NotificationScreen(
            payload: payload,
          ));
    });
  }

  static cancelNotififcationWithID(int id) async {
    await flutterNotificationService.cancel(id);
  }

  static cancelAllNotififcation() async {
    await flutterNotificationService.cancelAll();
  }
}
