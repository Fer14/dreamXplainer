import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AdProvider extends ChangeNotifier {

  int _rewardScore = 5;
  int get rewardScore => _rewardScore;

  set rewardScore(int value) {
    _rewardScore = value;
    notifyListeners();
  }

  Future<void> addReward() async {
    await Future.delayed(Duration(seconds: 1));
    final doc = FirebaseFirestore.instance.collection('user-coins').doc(GetStorage().read('email'));
    await doc.update({
      'coins': FieldValue.increment(1),
    });
    _rewardScore++;
    notifyListeners();
  }
  Future<void> subReward() async {
    final doc = FirebaseFirestore.instance.collection('user-coins').doc(GetStorage().read('email'));
    await doc.update({
      'coins': FieldValue.increment(-1),
    });
    _rewardScore--;
    notifyListeners();
  }

}
