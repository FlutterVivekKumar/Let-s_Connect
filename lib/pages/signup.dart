import 'package:chat_application/main.dart';
import 'package:chat_application/widgets/custombutton.dart';
import 'package:chat_application/widgets/customtextinput.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';


class ChatterSignUp extends StatefulWidget {
  @override
  _ChatterSignUpState createState() => _ChatterSignUpState();
}

class _ChatterSignUpState extends State<ChatterSignUp> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  // String username;
  String password= '';
  String name = '';
  bool signingup = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  hintText: 'Name',
                  leading: Icons.text_format,
                  obscure: false,
                  userTyped: (value) {
                    name = value;
                  },
                ),
                SizedBox(
                  height: 0,
                ),
                // CustomTextInput(
                //   hintText: 'Username',
                //   obscure: false,
                //   leading: Icons.supervised_user_circle,
                //   userTyped: (value) {
                //     username = value;
                //   },
                // ),
                SizedBox(
                  height: 0,
                ),
                CustomTextInput(
                  hintText: 'Email',
                  leading: Icons.mail,
                  keyboard: TextInputType.emailAddress,
                  obscure: false,
                  userTyped: (value) {
                    email = value;
                  },
                ),
                SizedBox(
                  height: 0,
                ),
                CustomTextInput(
                  hintText: 'Password',
                  leading: Icons.lock,
                  keyboard: TextInputType.visiblePassword,
                  obscure: true,
                  userTyped: (value) {
                    password = value;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Hero(
                  tag: 'signupbutton',
                  child: CustomButton(
                    onpress: () async {
                      if (name != null && password != null && email != null) {
                        setState(() {
                          signingup = true;
                        });
                        try {
                          final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                          if (newUser != null) {




                            Navigator.pushNamed(context, '/chat', arguments: newUser.user );
                          }
                        } catch (e) {
                          setState(() {
                            signingup = false;
                          });
                          Toast.show(
                               'Signup Failed',
                              );
                        }
                      } else {
                        Toast.show(
                             'Signup Failed',
                            );
                      }
                    },
                    text: 'sign up',
                    accentColor: Colors.white,
                    mainColor: primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child:  Text(
                      'or log in instead',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
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
