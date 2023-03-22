import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class AnswerProvider extends ChangeNotifier {
  String? _answer;

  String? get answer => _answer;

  void setAnswer(String answer) {
    _answer = answer;
    notifyListeners();
  }

  Future<void> callGPT(String text) async {
    // set time sleep
    await Future.delayed(Duration(seconds: 1));
    _answer = "Answer from GPT-3........................";
    notifyListeners();

    // var url = Uri.parse('https://api.openai.com/v1/chat/completions');
    // var apiKey = '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';

    // var headers = {
    //   'Content-Type': 'application/json',
    //   'Authorization': 'Bearer $apiKey'
    // };

    // var data = {
    //   'model': 'gpt-3.5-turbo',
    //   'messages': [
    //     {'role': 'user', 'content': 'Hello!'}
    //   ]
    // };

    // var response =
    //     await http.post(url, headers: headers, body: json.encode(data));

    // print(response.statusCode);
    // print(response.body);

    // _answer = response.body;
  }
}
