import 'package:flutter/material.dart';

class AdProvider extends ChangeNotifier {

  int _rewardScore = 0;
  int get rewardScore => _rewardScore;

  void addReward(){
    _rewardScore++;
    notifyListeners();
  }
  void subReward(){
    _rewardScore--;
    notifyListeners();
  }

}
