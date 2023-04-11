import 'package:flutter/material.dart';

class AdProvider extends ChangeNotifier {

  int _rewardScore = 5;
  int get rewardScore => _rewardScore;

  Future<void> addReward() async {
    await Future.delayed(Duration(seconds: 1));
    _rewardScore++;
    notifyListeners();
  }
  void subReward(){
    _rewardScore--;
    notifyListeners();
  }

}
