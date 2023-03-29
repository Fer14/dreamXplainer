import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello_world/provider/answer_provider.dart';
import 'package:hello_world/screens/chat.dart';
import 'package:hello_world/screens/policy.dart';
import 'package:hello_world/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/appbar.dart';

class NamePage extends StatefulWidget {
  const NamePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final answerProvider = Provider.of<AnswerProvider>(context);

    return Scaffold(
        body: Container(
      color: colors.white,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(100),
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.brown,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 32, 20, 20),
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        FontAwesomeIcons.userNinja,
                        color: colors.white,
                        size: 250,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 80, left: 20, right: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'What is your name?',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      color: colors.brown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 80, left: 20, right: 20),
                    child: ListTile(
                        title: TextField(
                          onChanged: (value) {
                            answerProvider.setName(value);
                          },
                          cursorColor: colors.brown,
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: colors.brown,
                              fontWeight: FontWeight.w400,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: colors.brown,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: colors.brown,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: colors.white,
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: colors.brown,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PolicyPage(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: colors.brown,
                            size: 20,
                          ),
                          iconSize: 20,
                        )),
                  )
                ]),
          )
        ],
      ),
    )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
