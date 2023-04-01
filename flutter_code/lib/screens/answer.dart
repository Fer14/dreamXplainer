import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello_world/provider/answer_provider.dart';
import 'package:hello_world/screens/chat.dart';
import 'package:hello_world/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/appbar.dart';

class AnswerPage extends StatefulWidget {
  const AnswerPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  late String answer;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final answerProvider = Provider.of<AnswerProvider>(context);

    return Scaffold(
        //appBar: MainAppBar(),
        body: Container(
      color: pale_colors.pink,
      child: Column(
        children: <Widget>[
          Container(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 20),
                child: Container(
                  width: double.infinity,
                  height: size.height * 0.75,
                  decoration: BoxDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: size.height * 0.2,
                        child: Image.asset(
                          'assets/night.png',
                        ),
                      ),
                      (answerProvider.answer != null)
                          ? Container(
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SingleChildScrollView(
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 20),
                                        height: size.height * 0.4,
                                        child: Text(
                                          answerProvider.answer!,
                                          style: TextStyle(
                                            color: colors.brown,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: LoadingAnimationWidget.stretchedDots(
                                color: pale_colors.blue,
                                size: 200,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().moveY(
                duration: 500.ms,
              ),
          Container(
            height: size.height * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(size.height * 0.1, size.height * 0.1),
                      backgroundColor: pale_colors.blue,
                      shape: CircleBorder()),
                  onPressed: () async {
                    await Clipboard.setData(
                        ClipboardData(text: answerProvider.answer!));
                  },
                  child: Icon(
                    Icons.content_copy,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(size.height * 0.1, size.height * 0.1),
                      backgroundColor: pale_colors.blue,
                      shape: CircleBorder()),
                  onPressed: () async {
                    Share.share(answerProvider.answer.toString());
                  },
                  child: Icon(
                    FontAwesomeIcons.share,
                    color: Colors.white,
                    size: 35,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
