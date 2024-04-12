import 'package:chat_application/widgets/custombutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../main.dart';

class ChatterHome extends StatefulWidget {
  @override
  _ChatterHomeState createState() => _ChatterHomeState();
}

class _ChatterHomeState extends State<ChatterHome>
    with TickerProviderStateMixin {
  late AnimationController mainController;
  late Animation mainAnimation;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      mainController = AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this,
      );
      mainAnimation =
          ColorTween(begin: Colors.deepPurple[900], end: Colors.grey[100])
              .animate(mainController);
      mainController.forward();
      mainController.addListener(() {
        setState(() {});
      });
    }

    // Defer the navigation until after the widget has been fully initialized
    Future.delayed(Duration.zero, () {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print("User is already signed in");
        Navigator.pushNamed(context, '/chat', arguments: user);
      } else {
        print("User is not signed in");
        // Navigate to the sign-in screen
      }
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'heroicon',
                  child: Image.asset('assets/images/logo.jpg', width: 120,height: mainController.value * 120,),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Hero(
                  tag: 'HeroTitle',
                  child: Text(
                    '''Let's Connect''',
                    style: TextStyle(
                        color: Colors.deepPurple[900],
                        fontFamily: 'Poppins',
                        fontSize: 26,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TyperAnimatedTextKit(
                  isRepeatingAnimation: false,
                  speed:Duration(milliseconds: 60),
                  text:["World's most private chatting app".toUpperCase()],
                  textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.deepPurple),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                Hero(
                  tag: 'loginbutton',
                  child: CustomButton(
                    text: 'Login',
                    accentColor: Colors.deepPurple,
                    onpress: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    }, mainColor: Colors.blue.withOpacity(.8),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Hero(
                  tag: 'signupbutton',
                  child: CustomButton(
                    text: 'Signup',
                    accentColor: Colors.white,
                    mainColor: primaryColor,
                    onpress: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                  ),
                ),
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
