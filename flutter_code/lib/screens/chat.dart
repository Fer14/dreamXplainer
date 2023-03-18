import 'package:flutter/material.dart';
import 'package:hello_world/screens/answer.dart';
import 'package:hello_world/screens/chat.dart';
import 'package:hello_world/utils/colors.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import '../provider/answer_provider.dart';

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
        appBar: AppBar(
          backgroundColor: magic_colors.dark_pink,
          title: Text(
            "Dream Explainer",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Container(
          color: magic_colors.light_pink,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/dream.png",
                    width: 200,
                    height: 200,
                  ),
                ),
                Container(
                  width: size.width * 0.9,
                  height: size.height * 0.1,
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    "¿What kind of explanation do you want?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
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
                          value: 'Divertido',
                          label: 'Divertido',
                          decorations: MultiSelectItemDecorations(
                            decoration: BoxDecoration(
                                color:
                                    magic_colors.dark_purple.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)),
                            selectedDecoration: BoxDecoration(
                                color: magic_colors.dark_purple,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                        MultiSelectCard(
                          value: '+18',
                          label: '+18',
                          decorations: MultiSelectItemDecorations(
                            decoration: BoxDecoration(
                                color: magic_colors.dark_blue.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)),
                            selectedDecoration: BoxDecoration(
                                color: magic_colors.dark_blue,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                        MultiSelectCard(
                          value: 'Detallado',
                          label: 'Detallado',
                          decorations: MultiSelectItemDecorations(
                            decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)),
                            selectedDecoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                        MultiSelectCard(
                          value: 'Random',
                          label: 'Random',
                          decorations: MultiSelectItemDecorations(
                            decoration: BoxDecoration(
                                color: magic_colors.green.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)),
                            selectedDecoration: BoxDecoration(
                                color: magic_colors.green,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                        MultiSelectCard(
                          value: 'Amoroso',
                          label: 'Amoroso',
                          decorations: MultiSelectItemDecorations(
                            decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)),
                            selectedDecoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                        MultiSelectCard(
                          value: 'Triste',
                          label: 'Triste',
                          decorations: MultiSelectItemDecorations(
                            decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)),
                            selectedDecoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ],
                      onMaximumSelected: (allSelectedItems, selectedItem) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: magic_colors.dark_pink,
                            content:
                                Text('Solo puedes seleccionar 2 opciones')));
                      },
                      onChange: (allSelectedItems, selectedItem) {}),
                ),
                Container(
                  width: size.width * 0.9,
                  height: size.height * 0.1,
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    "¿What is your dream?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                buildMessageInput(answerProvider),
              ],
            ),
          ),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
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
                cursorColor: magic_colors.dark_pink,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10),
                  hintText: "Escribe tu sueño...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                controller: textEditingController,
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
                  color: magic_colors.dark_pink,
                ),
              ),
            ],
          ),
        ));
  }
}
