import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/provider/adProvider.dart';
import 'package:hello_world/provider/answer_provider.dart';
import 'package:hello_world/onboarding.dart';
import 'package:hello_world/onboarding2.dart';
import 'package:hello_world/screens/policy.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hello_world/utils/colors.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AnswerProvider()),
          ChangeNotifierProvider(create: (_) => AdProvider()),

        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'dreamXplainer',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              scrollbarTheme: ScrollbarThemeData(
                thumbColor: MaterialStateProperty.all(pale_colors.blue),
                trackColor: MaterialStateProperty.all(pale_colors.blue),
              ),
              //set pale_colors.blue as primarySwatch color
              primaryColor: pale_colors.blue,
            ),
            home: AnimatedSplashScreen(
                duration: 1500,
                splash: Image.asset('assets/icon.png',),
                splashIconSize: 224,
                nextScreen: PolicyPage() ,
                splashTransition: SplashTransition.scaleTransition,
                backgroundColor: pale_colors.blue))//const MyHomePage(title: 'Flutter Demo Home Page'),
            );
  }
}
