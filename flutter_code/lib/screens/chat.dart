import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hello_world/screens/answer.dart';
import 'package:hello_world/screens/chat.dart';
import 'package:hello_world/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import '../provider/answer_provider.dart';
import '../utils/appbar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController textEditingController = TextEditingController();
  late String dream;

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
      decoration: BoxDecoration(
        color: colors.white,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Container(
            //   margin: EdgeInsets.only(top: 20),
            //   alignment: Alignment.center,
            //   child: Image.asset(
            //     "assets/dream.png",
            //     width: 200,
            //     height: 200,
            //   ),
            // ),
            Container(
              height: 50,
              width: size.width,
              color: Colors.red,
              child: Center(
                child: Text(
                  "AD",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Container(
                  width: size.width * 0.75,
                  height: size.height * 0.1,
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: colors.pink,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    "\t What kind of explanation do you want?",
                    style: TextStyle(
                      color: colors.brown,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ).animate().fade(duration: 500.ms, delay: 500.ms),
            Container(
                    width: size.width * 0.9,
                    height: size.height * 0.1,
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.brown,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    child: multiselection())
                .animate()
                .fade(duration: 500.ms, delay: 1000.ms),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Container(
                  width: size.width * 0.55,
                  height: size.height * 0.1,
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: colors.pink,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    "\t What was your dream?",
                    style: TextStyle(
                      color: colors.brown,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ).animate().fade(duration: 500.ms, delay: 1500.ms),
            (textEditingController.text != '')
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Container(
                            width: size.width * 0.3,
                            height: size.height * 0.1,
                            margin: EdgeInsets.only(top: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: colors.brown,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                            ),
                            child: LoadingAnimationWidget.prograssiveDots(
                              color: colors.white,
                              size: 50,
                            ))))
                : Container(),
            buildMessageInput(answerProvider),
          ],
        ),
      ),
    )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget multiselection() {
    return Container(
      child: MultiSelectContainer(
          maxSelectableCount: 2,
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
          items: [
            MultiSelectCard(
              value: 'Funny',
              label: 'Funny',
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: colors.pink.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: colors.pink, borderRadius: BorderRadius.circular(5)),
              ),
            ),
            MultiSelectCard(
              value: '+18',
              label: '+18',
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: colors.light_pink.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: colors.light_pink,
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            MultiSelectCard(
              value: 'Detailed',
              label: 'Detailed',
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: colors.light_orange.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: colors.light_orange,
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            MultiSelectCard(
              value: 'Random',
              label: 'Random',
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: colors.orange.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: colors.orange,
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            MultiSelectCard(
              value: 'Love',
              label: 'Love',
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: colors.gray.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: colors.gray, borderRadius: BorderRadius.circular(5)),
              ),
            ),
            MultiSelectCard(
              value: 'Sad',
              label: 'Sad',
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: colors.light_brown.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: colors.light_brown,
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ],
          onMaximumSelected: (allSelectedItems, selectedItem) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: magic_colors.dark_pink,
                content: Text('You can only select 2 options at a time')));
          },
          onChange: (allSelectedItems, selectedItem) {}),
    );
  }

  Widget buildMessageInput(AnswerProvider answerProvider) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              Flexible(
                  child: TextField(
                cursorColor: colors.brown,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10),
                  hintText: "Type your dream",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                controller: textEditingController,
                onChanged: (value) => setState(() => dream = value),
                onSubmitted: (value) {
                  //onSendMessage(textEditingController.text, MessageType.text);
                },
              )),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //   ),
              //   child: IconButton(
              //     onPressed: () {
              //       //onSendMessage(textEditingController.text, MessageType.text);
              //     },
              //     icon: const Icon(Icons.keyboard_voice_rounded),
              //     color: magic_colors.dark_pink,
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed: () {
                    answerProvider.callGPT(textEditingController.text);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AnswerPage()));
                  },
                  icon: const Icon(Icons.send_rounded),
                  color: colors.brown,
                ),
              ),
            ],
          ),
        ));
  }
}
