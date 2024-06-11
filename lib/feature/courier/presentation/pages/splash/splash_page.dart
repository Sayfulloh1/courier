import 'dart:async';

import 'package:courier_app/feature/courier/presentation/pages/main/main_pages.dart';
import 'package:courier_app/feature/courier/presentation/resources/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/enter_account_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  checkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      goMyPages();
    } else {
      goEnterAccPages();
    }
  }

  goMyPages() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyPages()),
    );
  }

  goEnterAccPages() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const EnterAccountPage()),
    );
  }

  @override
  void initState() {
    Timer(
      const Duration(seconds: 1),
      () {
        checkStatus();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // backgroundColor: Color(0xff589cfc),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              SplashBodyWidget(),
            /*  SplashButtonWidget(),*/
            ],
          ),
        ),
      ),
    );
  }
}



class SplashBodyWidget extends StatelessWidget {
  const SplashBodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .5,
      child: Column(
        children: [
          Center(
            child: Image.asset(ImageAssets.splashImage),
          ),
          /* RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              text: 'Добро пожаловать\n',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
                fontSize: 28,
              ),
              children: [
                TextSpan(
                  text: ' на курьерное \n',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                  ),
                ),
                TextSpan(
                  text: ' приложение',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                  ),
                ),
                TextSpan(
                  text: ' Voltify ',
                  style: TextStyle(
                    color: Color(0xff0058CB),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }
}
