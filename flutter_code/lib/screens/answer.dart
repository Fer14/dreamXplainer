import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello_world/provider/answer_provider.dart';
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

class _AnswerPageState extends State<AnswerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _selectedColor = pale_colors.blue;
  final _unselectedColor = colors.brown;
  final _tabs = const [
    Tab(text: 'Explanation'),
    Tab(text: 'End of dream'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final answerProvider = Provider.of<AnswerProvider>(context);

    return Scaffold(
        //appBar: MainAppBar(),
        body: SingleChildScrollView(
            child: Container(
      height: size.height * 1.05,
      color: pale_colors.pink,
      child: Column(
        children: <Widget>[
          Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                tabs: _tabs,
                labelColor: _selectedColor,
                indicatorColor: _selectedColor,
                unselectedLabelColor: _unselectedColor,
              )),
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
                  height: size.height * 0.7,
                  decoration: BoxDecoration(),
                  child: TabBarView(controller: _tabController, children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Explanation',
                          style: TextStyle(
                            color: pale_colors.blue,
                            fontSize: 30,
                          ),
                        ),
                        Container(
                          height: size.height * 0.2,
                          child: Image.asset(
                            'assets/explanation.png',
                          ),
                        ),
                        (answerProvider.explanationAnswer != null)
                            ? Container(
                                padding: const EdgeInsets.only(top: 10),
                                height: size.height * 0.3,
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Text(
                                        answerProvider.explanationAnswer!,
                                        style: TextStyle(
                                          color: colors.brown,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
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
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'End of dream',
                          style: TextStyle(
                            color: pale_colors.blue,
                            fontSize: 30,
                          ),
                        ),
                        Container(
                          height: size.height * 0.2,
                          child: Image.asset(
                            'assets/completion.png',
                          ),
                        ),
                        (answerProvider.storyAnswer != null)
                            ? Container(
                                padding: const EdgeInsets.only(top: 10),
                                height: size.height * 0.3,
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Text(
                                        answerProvider.storyAnswer!,
                                        style: TextStyle(
                                          color: colors.brown,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: LoadingAnimationWidget.stretchedDots(
                                  color: pale_colors.blue,
                                  size: 200,
                                ),
                              ),
                      ],
                    )
                  ]),
                ),
              ),
            ),
          ).animate().moveY(
                duration: 500.ms,
              ),
          Container(
            height: size.height * 0.2,
            child: TabBarView(
              controller: _tabController,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    (answerProvider.explanationAnswer != null)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize:
                                    Size(size.height * 0.1, size.height * 0.1),
                                backgroundColor: pale_colors.blue,
                                shape: CircleBorder()),
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(
                                  text: answerProvider.explanationAnswer!));
                            },
                            child: Icon(
                              Icons.content_copy,
                              color: Colors.white,
                              size: 35,
                            ),
                          )
                        : Container(),
                    (answerProvider.explanationAnswer != null)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize:
                                    Size(size.height * 0.1, size.height * 0.1),
                                backgroundColor: pale_colors.blue,
                                shape: CircleBorder()),
                            onPressed: () async {
                              Share.share(
                                  answerProvider.explanationAnswer.toString());
                            },
                            child: Icon(
                              FontAwesomeIcons.share,
                              color: Colors.white,
                              size: 35,
                            ),
                          )
                        : Container(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    (answerProvider.storyAnswer != null)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize:
                                    Size(size.height * 0.1, size.height * 0.1),
                                backgroundColor: pale_colors.blue,
                                shape: CircleBorder()),
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(
                                  text: answerProvider.storyAnswer!));
                            },
                            child: Icon(
                              Icons.content_copy,
                              color: Colors.white,
                              size: 35,
                            ),
                          )
                        : Container(),
                    (answerProvider.storyAnswer != null)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize:
                                    Size(size.height * 0.1, size.height * 0.1),
                                backgroundColor: pale_colors.blue,
                                shape: CircleBorder()),
                            onPressed: () async {
                              Share.share(
                                  answerProvider.storyAnswer.toString());
                            },
                            child: Icon(
                              FontAwesomeIcons.share,
                              color: Colors.white,
                              size: 35,
                            ),
                          )
                        : Container()
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ))
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
