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


  Map<String, String> tagwords_en = {
    'Funny':'be very funny, introducing new crazy characters',
    'Romantic': 'be very romantic, introducing love and relationships in your story',
    'Horror': 'be very scary, introducing scary characters and jumpscares',
    'Sad': 'be very sad, negative, disheartened and disastrous story',
    'Serious':'be extremely rigurous, the sotry needs to be real, without crazy stuff',
    'Fantasy':'be very fantasy, introducing new fantasy characters',
    'Tarantino':'be very dramatic, related with blood, deaths and violence, and lots of blood',
    'Action':'contain plenty of action, with many fights and explosions',
    'Erotic':'be extremely sexual and filthy, containing porn scenes and hot sentences',
  };

  Map<String, String> tagwords_es = {
    'Divertido': 'ser muy divertido, introducir nuevos personajes locos',
    'Romántico': 'ser muy romántico, introducir el amor y las relaciones amorosas en tu historia',
    'Horror': 'ser muy aterrador, introducir personajes aterradores y sustos',
    'Triste': 'ser muy triste, negativo, descorazonador y desastroso',
    'Serio': 'ser extremadamente riguroso, la historia debe ser real, sin cosas locas',
    'Fantasía': 'ser muy fantasioso, introduciendo nuevos personajes de fantasía',
    'Tarantino': 'ser muy dramático, relacionado con sangre, muertes y violencia, y mucha sangre',
    'Acción': 'contener mucha acción, con muchas peleas y explosiones',
    'Erótico': 'ser extremadamente sexual y sucio, contener escenas pornográficas y frases picantes',
  };


  Future<void> callGPT(String text, String tag, locale) async {
    _dreamanswer = text;
    subReward();
    GPT(text, tag, locale);

    if (_explanationError || _storyError) {
      // add reward
      addReward();
    }
    notifyListeners();
}


  String API_KEY = "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";

  Future<void> GPT(String text, string_tag, locale) async {


    _explanationError = false;
    _explanationAnswer = null;

    _storyError = false;
    _storyAnswer = null;

    String prompt = "";

    if(locale.toString() == "es"){
      String? tag = tagwords_es[string_tag];

      String prompt1_es = "Te voy a escribir un sueño que yo tuve anoche y tienes que inventarte una historia que continúe con el sueño y una explicación del sueño. Tu respuesta debe tener 2 párrafos. \n En el primer párrafo, explica por qué soñé con esa cosa, qué significa y qué debo esperar en mi vida según este sueño. Puedes hacer conjeturas y especular sobre lo que quieras. Intenta  $tag. El párrafo tiene que ser corto. Evita hablar en primera persona. \n En el segundo párrafo, continua el sueño de forma natural, utilizando la segunda persona. Tienes que ser creativo y la historia tiene que $tag. El párrafo tiene que ser corto. No introduzcas el párrafo con frases como: 'Continuando el sueño...', ni 'Te despiertas en...'.  \n El sueño que tuve anoche fue: ";
      String prompt2_es = "\n La interpretación que se te ocurre es: \n ";
      prompt = prompt1_es + "\n $text" + prompt2_es;
    }
    else{

      String? tag = tagwords_en[string_tag];

      String prompt1_es = "You will be given a dream that I had last night and you have to come up with a story that fulfills the dream and an explanation. Your answer has to be 2 paragraphs long.\n In the first paragraph, you will answer why I dreamt of that thing, what does it signify and what should I expect next in my life according to this dream. You can make guesses and speculate about whatever you want. Try to $tag. This paragraph will be 2 or 3 sentences long.\n In the second paragraph, you will complete what happened after the dream as if I had not woken up. You have to be creative and the story has to $tag. Use the past tense. Avoid talking in first person. This paragraph will be 2 sentences long. \n The story in the dream I had last night was: ";
      String prompt2_es = "\n The interpretation you come up with is: \n ";
      prompt = prompt1_es + "\n $text" + prompt2_es;
    }


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
       List<String> lines = answer.split('\n');
       if(locale.toString() == "es"){

         final bytes = lines[0].codeUnits;
         _explanationAnswer = Utf8Decoder().convert(bytes);

         final bytes2 = lines[2].codeUnits;
         _storyAnswer = Utf8Decoder().convert(bytes2);

         print("decoded:");
         print(_explanationAnswer);

       }
       else {
         _explanationAnswer= lines[0];
         _storyAnswer= lines[2];
       }

     }catch(e){
       _explanationError = true;
       _storyError = true;
     }


    notifyListeners();
  }



}
