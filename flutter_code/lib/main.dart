
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hello_world/provider/answer_provider.dart';
import 'package:hello_world/screens/chat2.dart';
import 'package:hello_world/screens/error.dart';
import 'package:hello_world/screens/login.dart';
import 'package:flutter/services.dart';
import 'package:hello_world/utils/colors.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hello_world/utils/global_vars.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();


  bool result = await InternetConnectionChecker().hasConnection;
  if(result == true) {
    if (GetStorage().read('email') != null &&
        GetStorage().read('keep') != false &&
        GetStorage().read('keep') != null) {
      GlobalVars.session = true;
      GlobalVars.email = GetStorage().read('email');
      final doc = FirebaseFirestore.instance.collection('user-coins').doc(GetStorage().read('email'));
      doc.get().then((value) {
        GlobalVars.score_state = value['coins'];
      });
    } else {
      GlobalVars.session = false;
    }
  } else {
    GlobalVars.session_error = true;
  }


  runApp(MyApp());
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
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if(!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              currentFocus.focusedChild!.unfocus();
            }
          },
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
                fontFamily: 'Nunito'
              ),
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            supportedLocales: [
              Locale('en'),
              Locale('es')  //Spanish
            ],
              home: AnimatedSplashScreen(
                  duration: 1500,
                  splash: Image.asset('assets/icon.png',),
                  splashIconSize: 224,
                  nextScreen: GlobalVars.session_error ? ErrorPage() : GlobalVars.session ? Chat2Page() : PolicyPage(),
                  splashTransition: SplashTransition.scaleTransition,
                  backgroundColor: pale_colors.blue)),
        )//const MyHomePage(title: 'Flutter Demo Home Page'),
            );
  }
}
