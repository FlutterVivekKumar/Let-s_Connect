import 'dart:developer';

import 'package:chat_application/main.dart';
import 'package:chat_application/widgets/custombutton.dart';
import 'package:chat_application/widgets/customtextinput.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';


class ChatterLogin extends StatefulWidget {
  @override
  _ChatterLoginState createState() => _ChatterLoginState();
}

class _ChatterLoginState extends State<ChatterLogin> {
  String email= '';
  String password= '';
  bool loggingin = false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          // margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.2),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'heroicon',
                  child: Image.asset('assets/images/logo.jpg', width: 120,height: 120,),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Hero(
                  tag: 'HeroTitle',
                  child: Text(
                    '''Let's Connect''',
                    style: TextStyle(
                        color: primaryColor,
                        fontFamily: 'Poppins',
                        fontSize: 26,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                // Text(
                //   "World's most private chatting app".toUpperCase(),
                //   style: TextStyle(
                //       fontFamily: 'Poppins',
                //       fontSize: 12,
                //       color: primaryColor),
                // ),
                CustomTextInput(
                  hintText: 'Email',
                  leading: Icons.mail,
                  obscure: false,
                  keyboard: TextInputType.emailAddress,
                  userTyped: (val) {
                    email = val;
                  },
                ),
                const SizedBox(
                  height: 0,
                ),
                CustomTextInput(
                  hintText: 'Password',
                  leading: Icons.lock,
                  obscure: true,
                  userTyped: (val) {
                    password = val;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Hero(
                  tag: 'loginbutton',
                  child: CustomButton(
                    text: 'login',
                    accentColor: Colors.white,
                    mainColor: primaryColor,
                    onpress: () async {
                      if (password != null && email != null) {
                        setState(() {
                          loggingin = true;
                        });
                        try {
                          final loggedUser =
                          await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (loggedUser != null) {

                            setState(() {
                              loggingin = false;
                            });
                            Navigator.pushNamed(context, '/chat', arguments: loggedUser.user);
                          }
                        } catch (e) {
                          setState(() {
                            loggingin = false;
                          });
                     log(e.toString());
                        }
                      } else {
                        Toast.show(
                             'Uh oh!\n' +

                            'Please enter the email and password.',
);
                      }
                      // Navigator.pushReplacementNamed(context, '/chat');
                    },
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: Text(
                      'or create an account',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: primaryColor),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
