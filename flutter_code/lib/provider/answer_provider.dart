import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

import '../utils/global_vars.dart';

class AnswerProvider extends ChangeNotifier {

  int _rewardScore = GlobalVars.score_state;
  int get rewardScore => _rewardScore;

  set rewardScore(int value) {
    _rewardScore = value;
    notifyListeners();
  }

  Future<void> addReward() async {
    await Future.delayed(Duration(seconds: 1));
    final doc = FirebaseFirestore.instance.collection('user-coins').doc(GlobalVars.email);
    await doc.update({
      'coins': FieldValue.increment(1),
    });
    _rewardScore++;
    notifyListeners();
  }
  Future<void> subReward() async {
    print("subReward");
    final doc = FirebaseFirestore.instance.collection('user-coins').doc(GlobalVars.email);
    await doc.update({
      'coins': FieldValue.increment(-1),
    });
    _rewardScore--;
    notifyListeners();
  }

  String? _dreamanswer;
  String? get dreamanswer => _dreamanswer;

  String? _explanationAnswer;
  String? get explanationAnswer => _explanationAnswer;

  String? _storyAnswer;
  String? get storyAnswer => _storyAnswer;

  bool _explanationError = false;
  bool get explanationError => _explanationError;

  bool _storyError = false;
  bool get storyError => _storyError;

  void setExplanationAnswer(String answer) {
    _explanationAnswer = answer;
    notifyListeners();
  }


  Map<String, String> tagwords = {
    'Funny':'be very funny, introducing new crazy characters',
    'Romantic': 'be very romantic, introducing love and relationships in your story',
    'Horror': 'be very scary, introducing scary characters and jumpscares',
    'Sad': 'be very sad, negative, disheartened and disastrous story',
    'Serious':'be extremely rigurous, the sotry needs to be real, without crazy stuff',
    'Fantasy':'be very fantasy, introducing new fantasy characters',
    'Tarantino':'be related with blood, many deaths and violence, as if it was a Tarantino movie',
    'Action':'contain plenty of action, with many fights and explosions',
  };


  Future<void> callGPT(String text, String tag) async {
    _dreamanswer = text;
    subReward();
    GPT(text, tag);

    if (_explanationError || _storyError) {
      // add reward
      addReward();
    }
    notifyListeners();
}


  String API_KEY = "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";

  Future<void> GPT(String text, string_tag) async {

    _explanationError = false;
    _explanationAnswer = null;

    _storyError = false;
    _storyAnswer = null;

    String? tag = tagwords[string_tag];
    String prompt1 = "You will be given a dream that I had last night and you have to come up with a story that fulfills the dream and an explanation. Your answer has to be 2 paragraphs long.\n In the first paragraph, you will answer why I dreamt of that thing, what does it signify and what should I expect next in my life according to this dream. You can make guesses and speculate about whatever you want. Try to $tag. This paragraph will be 2 or 3 sentences long.\n In the second paragraph, you will complete what happened after the dream as if I had not woken up. You have to be creative and the story has to $tag. Use the past tense. Avoid talking in first person. This paragraph will be 2 sentences long. \n The story in the dream I had last night was: ";
    String prompt2 = "\n The interpretation you come up with is: \n ";
    String prompt = prompt1 + "\n $text" + prompt2;


    print("prompt: $prompt");

    //await Future.delayed(Duration(seconds: 1));
/*    _explanationAnswer =
        "Answer explanation from GPT-3........................aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    _explanationError = false;*/


    var url = Uri.parse('https://api.openai.com/v1/chat/completions');

    var headers = {
      'Content-Type': 'application/json',
       'Authorization': 'Bearer $API_KEY'
     };

     var data = {
       'model': 'gpt-3.5-turbo',
       'messages': [
         {'role': 'user', 'content': '$prompt'}
       ]
     };

     try{
       var response = await http.post(url, headers: headers, body: json.encode(data));
       Map map = json.decode(response.body);
       String answer = map["choices"][0]['message']['content'];
       // split answer into 2 parts
       print(answer);
       List<String> lines = answer.split('\n');
       _explanationAnswer= lines[0];
       _storyAnswer= lines[2];
        print(lines);
        print("explanation: $_explanationAnswer");
        print("story: $_storyAnswer");
     }catch(e){
       print(e);
       _explanationError = true;
       _storyError = true;
     }


    notifyListeners();
  }


}
