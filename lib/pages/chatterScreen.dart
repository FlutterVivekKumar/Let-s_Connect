import 'dart:convert';

import 'package:chat_application/main.dart';
import 'package:chat_application/services/keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';

final _firestore = FirebaseFirestore.instance;
String username = 'User';
String email = 'user@example.com';
String messageText = '';

class ChatterScreen extends StatefulWidget {
  const ChatterScreen({super.key});

  @override
  _ChatterScreenState createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatterScreen> {
  final chatMsgTextController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  @override
  void initState() {
    // loggedInUser = ModalRoute.of(context)!.settings.arguments as User;
    // super.initState();

    // getMessages();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access context and retrieve arguments
    loggedInUser = ModalRoute.of(context)!.settings.arguments as User;
    email = loggedInUser.email!;
    username = loggedInUser.displayName ?? 'User';
  }

  void getCurrentUser() async {}

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: primaryColor),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size(25, 10),
          child: Container(
            decoration: const BoxDecoration(
                // color: Colors.blue,

                // borderRadius: BorderRadius.circular(20)
                ),
            constraints: const BoxConstraints.expand(height: 1),
            child: LinearProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: primaryColor,
            ),
          ),
        ),
        backgroundColor: Colors.white10,
        // leading: Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: CircleAvatar(backgroundImage: NetworkImage('https://cdn.clipart.email/93ce84c4f719bd9a234fb92ab331bec4_frisco-specialty-clinic-vail-health_480-480.png'),),
        // ),
        title: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  <Widget>[
                Text(
                  '''Let's Connect''',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: primaryColor),
                ),

              ],
            ),
          ],
        ),
        actions: <Widget>[
          GestureDetector(
            child: const Icon(Icons.more_vert),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              accountName: const SizedBox(),
              accountEmail: Text(email),
              currentAccountPicture:  CircleAvatar(
                backgroundColor: primaryColor,
                backgroundImage: const NetworkImage(
                    "https://media.istockphoto.com/id/1332100919/vector/man-icon-black-icon-person-symbol.jpg?s=612x612&w=0&k=20&c=AVVJkvxQQCuBhawHrUhDRTCeNQ3Jgt0K1tXjJsFy1eg="),
              ),
              onDetailsPressed: () {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Logout"),
              subtitle: const Text("Sign out of this account"),
              onTap: () async {
                await _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/', (val) => false);
              },
            ),
          ],
        ),
      ),
      body: loggedInUser == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ChatStream(
                  loggedInUser: loggedInUser,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: kMessageContainerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Material(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 2, bottom: 2),
                            child: TextField(
                              onChanged: (value) {
                                messageText = value;
                              },
                              controller: chatMsgTextController,
                              decoration: kMessageTextFieldDecoration,
                            ),
                          ),
                        ),
                      ),
                      MaterialButton(
                          shape: const CircleBorder(),
                          color: primaryColor,
                          onPressed: () {
                            chatMsgTextController.clear();
                            _firestore.collection('messages').add({
                              'sender': username,
                              'text': messageText,
                              'timestamp':
                                  DateTime.now().millisecondsSinceEpoch,
                              'senderemail': email
                            });
                            sendNotification(
                                sender: email, message: messageText);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Icon(
                              Icons.send,
                              size: 22,
                              color: Colors.white,
                            ),
                          )
                          // Text(
                          //   'Send',
                          //   style: kSendButtonTextStyle,
                          // ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class ChatStream extends StatelessWidget {
  const ChatStream({super.key, required this.loggedInUser});

  final User loggedInUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs.reversed;
          List<MessageBubble> messageWidgets = [];
          for (var message in messages) {
            final msgText = message.data()['text'];
            final msgSender = message.data()['senderemail'];
            // final msgSenderEmail = message.data['senderemail'];
            final currentUser = loggedInUser.email;

            // print('MSG'+msgSender + '  CURR'+currentUser);
            final msgBubble = MessageBubble(
                msgText: msgText,
                msgSender: msgSender,
                user: currentUser == msgSender);
            messageWidgets.add(msgBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              children: messageWidgets,
            ),
          );
        } else {
          return  Center(
            child:
                CircularProgressIndicator(backgroundColor: primaryColor),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final bool user;

  MessageBubble(
      {super.key,
      required this.msgText,
      required this.msgSender,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment:
            user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              msgSender.split('@')[0].replaceAll(new RegExp(r"[0-9]+"), ""),
              style: const TextStyle(
                  fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(50),
              topLeft:
                  user ? const Radius.circular(50) : const Radius.circular(0),
              bottomRight: const Radius.circular(50),
              topRight:
                  user ? const Radius.circular(0) : const Radius.circular(50),
            ),
            color: user != true ? primaryColor : Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                msgText,
                style:  TextStyle(
                  color:  user != true ? Colors.white : Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
Future<void> sendNotification(
    {required String sender, required String message}) async {
  try {
    print({
      'Authorization': 'Bearer $serverKey',
    });
    print({
      "notification": {"title": "$sender", "body": "$message"},
      "to": "/topics/chat"
    });
    const url = 'https://fcm.googleapis.com/fcm/send';

    final response = await Dio().post(url,
        options: Options(headers: {
          'Authorization': 'Bearer $serverKey',

        }),
        data: {
          "notification": {"title": "$sender", "body": "$message"},
          "to": "/topics/chat"
        });

    if (response.statusCode == 200) {
      print(response.data);
      // final map = jsonDecode(response.data);
      // if (map is Map<String, dynamic>) {
      //   if (map.containsKey('failure')) {
      //     if (map['results'] is List) {
      //       for (var result in map['results']) {
      //         if (result.containsKey('error') &&
      //             result['error'] == 'invalidRegistration') {
      //           Fluttertoast.showToast(msg: 'Invalid Registration Token');
      //         }
      //       }
      //     }
      //   }
      // }
    }
  } catch (e) {
    print(e.toString());
  }
}

