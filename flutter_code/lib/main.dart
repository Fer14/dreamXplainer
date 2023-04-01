import 'package:flutter/material.dart';
import 'package:hello_world/provider/answer_provider.dart';
import 'package:hello_world/screens/chat.dart';
import 'package:hello_world/onboarding.dart';
import 'package:hello_world/onboarding2.dart';
import 'package:hello_world/screens/name.dart';
import 'package:hello_world/screens/policy.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

void main() {
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
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
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
              primarySwatch: Colors.red,
            ),
            home:
                const PolicyPage() //const MyHomePage(title: 'Flutter Demo Home Page'),
            ));
  }
}
