import 'package:animate_do/animate_do.dart';
import 'package:evently_c20_online/core/theme/app_colors.dart';
import 'package:evently_c20_online/modules/layout/screens/layout_screen.dart';
import 'package:evently_c20_online/modules/start/screens/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:evently_c20_online/core/app_provider/app_provider.dart';
import 'package:evently_c20_online/modules/auth/screens/login_screen.dart';
import 'package:provider/provider.dart';
class SplashScreen extends StatelessWidget {
  static const String routeName = "splash";
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ZoomIn(
                  duration: Duration(seconds: 2),
                  child: Hero(
                      tag:"logo" ,
                      child: Center(child: Image.asset("assets/logo/app_logo.png")))),
            ),
            FadeInUp(
              delay: Duration(seconds: 2),
              onFinish: (direction) {
                bool isLogin = FirebaseAuth.instance.currentUser != null;
                bool onboardingSeen =
                    Provider.of<AppProvider>(context, listen: false).onboardingSeen;

                if (isLogin) {
                  Navigator.pushReplacementNamed(context, LayoutScreen.routeName);
                } else if (onboardingSeen) {
                  Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                } else {
                  Navigator.pushReplacementNamed(context, StartScreen.routeName);
                }
              },
              child: Center(
                child: Image.asset("assets/logo/route_logo.png", width: 214),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
