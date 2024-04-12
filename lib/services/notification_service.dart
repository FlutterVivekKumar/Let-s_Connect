/*Notification Data API */
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';

late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
bool isFlutterLocalNotificationsInitialized = false;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // navigatorKey.currentState!.push(MaterialPageRoute(builder: (context)=>MyHomePage()));
  // ignore: avoid_print
  log('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    log('notification action tapped with input: ${notificationResponse.input}');
  }
}

Future<void> setupFlutterNotifications() async {
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title

    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.high,
  );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('ic_stat_notifications_active');
    var initializationSettingsIOS = const DarwinInitializationSettings(requestSoundPermission: false,
      requestBadgePermission: false,

      requestAlertPermission: false, );
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground);



  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );

  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) async {
  String? imageUrl = _getImageUrl(message.notification!);

  String? pictureUrl = imageUrl != null
      ? await _downloadAndSavePicture(imageUrl, 'random.png')
      : '';

  flutterLocalNotificationsPlugin.show(
      121, '', '', _buildDetails(message, pictureUrl, imageUrl != null));
}

String? _getImageUrl(RemoteNotification notification) {
  if (Platform.isIOS && notification.apple != null) {
    return notification.apple?.imageUrl;
  }
  if (Platform.isAndroid && notification.android != null) {
    return notification.android?.imageUrl;
  }
  return null;
}

Future<String?> _downloadAndSavePicture(String? url, String fileName) async {
  if (url == null) return null;
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final response = await get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

NotificationDetails _buildDetails(
    RemoteMessage message, String? picturePath, bool showBigPicture) {
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    '_channel.id',
    '_channel.name',
    channelDescription: ' _channel.description',
    styleInformation:
    _buildBigPictureStyleInformation(message, picturePath, showBigPicture),
    importance: Importance.max,
    icon: "ic_stat_notifications_active",
  );

  // final IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(
  //   attachments: [if (picturePath != null) IOSNotificationAttachment(picturePath)],
  // );

  final NotificationDetails details = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    // iOS: iOSPlatformChannelSpecifics,
  );

  return details;
}

BigPictureStyleInformation? _buildBigPictureStyleInformation(
    RemoteMessage message,
    String? picturePath,
    bool showBigPicture,
    ) {
  if (picturePath == null) return null;
  final FilePathAndroidBitmap filePath = FilePathAndroidBitmap(picturePath);
  return BigPictureStyleInformation(
    showBigPicture ? filePath : const FilePathAndroidBitmap("empty"),
    largeIcon: filePath,
    contentTitle: message.notification!.title,
    htmlFormatContentTitle: true,
    summaryText: message.notification!.body,
    htmlFormatSummaryText: true,
  );
}