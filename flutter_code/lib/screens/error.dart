import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hello_world/screens/chat2.dart';
import 'package:hello_world/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import '../utils/global_vars.dart';

import 'login.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});


  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  bool loading = false;

  @override
  void initState(){

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;



    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            margin: MediaQuery.of(context).padding,
            color: pale_colors.light_blue,
            child: Column(
              children: [
                Image.asset("assets/better_logo.png", width: size.width *0.6,),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    width: size.width * 0.75,
                    height: size.height * 0.6,
                    child: loading ?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Checking internet connection...",
                          style: TextStyle(
                            color: colors.brown,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          width: size.width * 0.2,
                          height: size.height * 0.2,
                          child: RiveAnimation.asset(
                            'assets/animations/loading.riv',
                            // no backgroundColor
                          ),
                        ),
                      ],
                    ) :
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset("assets/signal.png", width: size.width *0.7,),
                        Text(
                          "There has been an error trying to retrieve your session data. Please check your internet connection or try again later.",
                          style: TextStyle(
                            color: colors.brown,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                                onPressed: () async {
                                bool result = await InternetConnectionChecker().hasConnection;

                                if(result == true) {
                                  try{
                                    GlobalVars.score_state = 0;
                                    if(GetStorage().read('keep')){
                                      final doc = FirebaseFirestore.instance.collection('user-coins').doc(GetStorage().read('email'));
                                      await doc.get().then((value) {
                                        GlobalVars.score_state = value['coins'];
                                      });
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Chat2Page()),
                                      );
                                    }
                                    else{
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PolicyPage()),
                                      );
                                    }

                                  }
                                  catch(e){
                                    print(e);
                                    setState(() {
                                      loading = true;
                                    });
                                    await Future.delayed(Duration(seconds: 3));
                                    setState(() {
                                      loading = false;
                                    });
                                    GlobalVars.session_error = true;
                                  }
                                }
                                else{
                                  setState(() {
                                    loading = true;
                                  });
                                  await Future.delayed(Duration(seconds: 3));
                                  setState(() {
                                    loading = false;
                                  });
                                  GlobalVars.session_error = true;
                                }
                                },
                                child: Text("Try again", style: TextStyle(color: pale_colors.dark_pink, fontSize: 20, fontWeight: FontWeight.bold),)))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }




}
