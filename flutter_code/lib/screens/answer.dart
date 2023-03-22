import 'package:flutter/material.dart';
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
        appBar: MainAppBar(),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/clouds.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/bruja.png",
                          width: 200,
                          height: 200,
                        ),
                        (answerProvider.answer != null)
                            ? Container(
                                width: size.width * 0.9,
                                height: size.height * 0.3,
                                decoration: BoxDecoration(
                                  color: magic_colors.dark_pink,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(18),
                                    bottomLeft: Radius.circular(18),
                                    bottomRight: Radius.circular(18),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    answerProvider.answer!,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : LoadingAnimationWidget.stretchedDots(
                                color: magic_colors.dark_pink,
                                size: 200,
                              ),
                        (answerProvider.answer != null)
                            ? Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          fixedSize: Size(size.height * 0.1,
                                              size.height * 0.1),
                                          backgroundColor:
                                              magic_colors.dark_pink,
                                          shape: CircleBorder()),
                                      onPressed: () async {
                                        await Clipboard.setData(ClipboardData(
                                            text: answerProvider.answer!));
                                      },
                                      child: Icon(
                                        Icons.content_copy,
                                        color: Colors.white,
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          fixedSize: Size(size.height * 0.1,
                                              size.height * 0.1),
                                          backgroundColor:
                                              magic_colors.dark_pink,
                                          shape: CircleBorder()),
                                      onPressed: () async {
                                        Share.share(
                                            answerProvider.answer.toString());
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.share,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container()
                      ],
                    )),
              ],
            ),
          ),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
