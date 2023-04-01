import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hello_world/screens/answer.dart';
import 'package:hello_world/screens/chat.dart';
import 'package:hello_world/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import '../provider/answer_provider.dart';
import '../utils/appbar.dart';

class Chat2Page extends StatefulWidget {
  const Chat2Page({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<Chat2Page> createState() => _Chat2PageState();
}

class _Chat2PageState extends State<Chat2Page> {
  TextEditingController textEditingController = TextEditingController();
  late String dream;

  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final answerProvider = Provider.of<AnswerProvider>(context);

    return Scaffold(
        //appBar: MainAppBar(),
        body: Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                Container(
                  height: 50,
                  width: size.width,
                  color: pale_colors.blue,
                  child: Center(
                    child: Text(
                      "dreamXplainer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: size.width,
                  color: Colors.pink,
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
              ],
            ),
            Container(
              width: size.width * 0.8,
              child: Center(
                child: Text(
                  "Write your dream and choose the way in chich you want it to be explained and finnished.",
                  style: TextStyle(
                    color: colors.brown,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              child: multiselection(),
            ),
            Container(
                child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    height: size.height * 0.25,
                    child: Center(child: Image.asset("assets/dream2.png"))),
                Container(
                  width: size.width * 0.8,
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: textEditingController,
                    onChanged: (value) => setState(() => dream = value),
                    cursorColor: pale_colors.blue,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: pale_colors.blue, width: 2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: pale_colors.blue, width: 5),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      )),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 7,
                  ),
                ),
              ],
            )),
            Container(
              width: size.width * 0.35,
              height: size.height * 0.05,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: pale_colors.blue),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(pale_colors.blue),
                ),
                onPressed: () {
                  answerProvider.callGPT(textEditingController.text);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnswerPage()),
                  );
                },
                child: Text('Submit',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            SizedBox(
              height: 50,
            )
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
                    color: pale_colors.violet.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.violet,
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            MultiSelectCard(
              value: 'Detailed',
              label: 'Detailed',
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: pale_colors.pink.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.pink,
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            MultiSelectCard(
              value: 'Random',
              label: 'Random',
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: pale_colors.dark_pink.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.dark_pink,
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            MultiSelectCard(
              value: 'Love',
              label: 'Love',
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: pale_colors.light_blue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.light_blue,
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            MultiSelectCard(
              value: 'Sad',
              label: 'Sad',
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: pale_colors.yellow.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.yellow,
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
