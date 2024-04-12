
import 'package:chat_application/pages/chatterScreen.dart';
import 'package:chat_application/pages/login.dart';
import 'package:chat_application/pages/signup.dart';
import 'package:chat_application/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'pages/splash.dart';
final primaryColor = '#8804e5'.toColor();
@pragma('vm:entry-point')
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
print('Message Revieved');
setupFlutterNotifications();

showFlutterNotification(message);
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.requestPermission();
  setupFlutterNotifications();
  // await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  FirebaseMessaging.onMessage.listen((event) {
   print('Message Recived');
  });

  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  runApp(ChatterApp());
}

class ChatterApp extends StatelessWidget {
  const ChatterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatter',

      theme: ThemeData(
        primaryColor: primaryColor,
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
      ),
      // home: ChatterHome(),
      initialRoute: '/',
      routes: {
        '/': (context) => ChatterHome(),
        '/login': (context) => ChatterLogin(),
        '/signup': (context) => ChatterSignUp(),
        '/chat': (context) => const ChatterScreen(),
        // '/chats':(context)=>ChatterScreen()
      },
    );
  }
}
extension ColorExtension on String {
  Color toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}