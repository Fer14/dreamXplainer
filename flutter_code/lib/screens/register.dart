import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hello_world/provider/answer_provider.dart';
import 'package:hello_world/screens/chat2.dart';
import 'package:hello_world/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import '../ads/ad_mob_service.dart';
import '../utils/appbar.dart';
import '../utils/policy_text.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  InterstitialAd? _interstitialAd;

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmpassController = TextEditingController();

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
    final answerProvider = Provider.of<AnswerProvider>(context);


    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            margin: MediaQuery.of(context).padding,
            color: pale_colors.blue,
            child: Column(
              children: <Widget>[
                Container(
                  height: size.height * 0.15,
                  child: Center(
                    child:Image.asset("assets/better_logo.png", width: size.width *0.6, fit: BoxFit.cover,)
                    ,)
                  ,),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(100),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 35, 20, 20),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: size.height * 0.2,
                              child: Image.asset(
                                'assets/login_pink.png',)
                            ),
                            SizedBox(height: size.height * 0.05,),
                            //_nameTextField(size),
                            _userTextField(size),
                            _passwordTextField(size),
                            _confirmpasswordTextField(size),
                            _botonRegister(size),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  Widget _botonRegister(Size size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.05),
        child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: pale_colors.dark_pink,
                shadowColor: pale_colors.pink,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)), // background
              ),
              onPressed: () async {register(emailController.text, passController.text, confirmpassController.text);},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15.0),
                child: const Text("\t Register \t",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              )),
        );
  }



Widget _userTextField(Size size) {
  return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.13),
          color: Colors.white,
          height: size.height * 0.1,
          child: TextField(
            style: const TextStyle(color: colors.brown),
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: pale_colors.blue,width: 2.0)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: pale_colors.blue,width: 2.0)),
              labelText: "E-mail",
              //hintStyle: TextStyle(color: Colores.fondoClaro),
              labelStyle: TextStyle(color: colors.brown),
            ),
            controller: emailController,
            onChanged: (value) {},
          ),
        );
      });
}

  Widget _passwordTextField(Size size) {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.13),
            height: size.height * 0.1,
            color: Colors.white,
            child: TextField(
              style: const TextStyle(color: colors.brown),
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                //prefix: Icon(Icons.lock),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: pale_colors.blue,width: 2.0)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: pale_colors.blue,width: 2.0)),
                labelText: "Password",
                //hintStyle: TextStyle(color: Colores.fondoClaro),
                labelStyle: TextStyle(color: colors.brown),
                // iconColor: Colors.red,
              ),
              controller: passController,
              onChanged: (value) {},
            ),
          );
        });
  }

  Widget _confirmpasswordTextField(Size size) {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.13),
            height: size.height * 0.1,
            color: Colors.white,
            child: TextField(
              style: const TextStyle(color: colors.brown),
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                //prefix: Icon(Icons.lock),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: pale_colors.blue,width: 2.0)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: pale_colors.blue,width: 2.0)),
                labelText: "Confirm password",
                //hintStyle: TextStyle(color: Colores.fondoClaro),
                labelStyle: TextStyle(color: colors.brown),
                // iconColor: Colors.red,
              ),
              controller: confirmpassController,
              onChanged: (value) {},
            ),
          );
        });
  }


  Future<void> register(email, pass1, pass2 ) async {
    if (email.isEmpty || pass1.isEmpty || pass2.isEmpty) {
    } else {
      if (pass1 != pass2) {
        _showErroDialog('The passwords do not match', 'assets/difference.png');
      } else {
        try {
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass1);
          final doc = FirebaseFirestore.instance.collection('user-coins');
          doc.doc(email).set({
            'coins': 3,
          });
          // send email verification
          await FirebaseAuth.instance.currentUser?.sendEmailVerification();
          _showSuccesDialog();


        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            _showErroDialog('The password provided is too weak.', 'assets/pass.png');
          } else if (e.code == 'email-already-in-use') {
            _showErroDialog('An account already exists for that email.', 'assets/user.png');
          }
        } catch (e) {
          print(e);
        }
      }

    }
  }

  void _showErroDialog(text, image) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.white,
            title: Text('ERROR!', style: TextStyle(color: colors.brown, fontWeight: FontWeight.bold, fontSize: 25)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(image, width: 200,),
                Text(text,style: TextStyle(color: colors.brown, fontSize: 20)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Accept', style: TextStyle(color: pale_colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
              )
            ],
          );
        });
  }


  void _showSuccesDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.white,
            title: Text('REGISTERED!', style: TextStyle(color: colors.brown, fontWeight: FontWeight.bold, fontSize: 25)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/email.png", width: 200,),
                Text('Check you inbox to validate your email. (It may appear in the spam folder)',style: TextStyle(color: colors.brown, fontSize: 20)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PolicyPage()),
                  );
                },
                child: Text('Accept', style: TextStyle(color: pale_colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
              )
            ],
          );
        });
  }




}
