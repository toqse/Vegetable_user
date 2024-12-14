import 'dart:async';
import 'package:ecom_app2/view/home.dart';
import 'package:ecom_app2/view/login_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  // Function to navigate to the appropriate screen
  Future<void> navigateToNextScreen() async {
    // Wait for a few seconds to display the splash screen
    await Future.delayed(Duration(seconds: 2));

    // Check login status using SharedPreferences
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isLoggedIn = preferences.getBool('isLoggedIn') ?? false;

    // Navigate to Home if logged in, otherwise navigate to Phone (Login page)
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Phone()),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/easy.png',
                          width: 310.0,
                          height: 110.0,
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
