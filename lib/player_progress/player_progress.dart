// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:basic/helpers/current_playing_data.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers/math_symbol.dart';
import 'persistence/local_storage_player_progress_persistence.dart';
import 'persistence/player_progress_persistence.dart';

/// 成就
class Achievement {
  String id;
  String title;
  String description;
  bool isAchieve = false;
  String imageUrl;
  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

/// Encapsulates the player's progress.
class PlayerProgress extends ChangeNotifier {
  /// By default, settings are persisted using
  /// [LocalStoragePlayerProgressPersistence] (i.e. NSUserDefaults on iOS,
  /// SharedPreferences on Android or local storage on the web).
  final PlayerProgressPersistence _store;

  String _userId = '';
  String _playerName = '';
  String _yourScore = '---'; // 預設
  int _yourRank = 0;

  List<Achievement> _achievements = [
    Achievement(
      id: 'first_play',
      title: 'first_play',
      description: 'first_play_desc',
      imageUrl: 'assets/icons/game-controller.svg',
    ),
    Achievement(
      id: 'champion',
      title: 'champion',
      description: 'champion_desc',
      imageUrl: 'assets/icons/medal-reward-1.svg',
    ),
    Achievement(
      id: 'runner_up',
      title: 'runner_up',
      description: 'runner_up_desc',
      imageUrl: 'assets/icons/medal-reward-2.svg',
    ),
    Achievement(
      id: 'second_runner_up',
      title: 'second_runner_up',
      description: 'second_runner_up_desc',
      imageUrl: 'assets/icons/medal-reward-3.svg',
    ),
    Achievement(
      id: 'restart',
      title: 'restart',
      description: 'restart_desc',
      imageUrl: 'assets/icons/rocket.svg',
    ),
    Achievement(
      id: 'navigate_number',
      title: 'navigate_number',
      description: 'navigate_number_desc',
      imageUrl: 'assets/icons/plus-slash-minus.svg',
    ),
    Achievement(
      id: 'three_same',
      title: 'three_same',
      description: 'three_same_desc',
      imageUrl: 'assets/icons/playing-cards.svg',
    ),
    Achievement(
      id: '1000',
      title: 'thousand',
      description: 'thousand_desc',
      imageUrl: 'assets/icons/award-prize.svg',
    ),
    Achievement(
      id: '10000',
      title: 'ten_thousand',
      description: 'ten_thousand_desc',
      imageUrl: 'assets/icons/award-prize.svg',
    ),
    Achievement(
      id: '100000',
      title: 'one_hundred_thousand',
      description: 'one_hundred_thousand_desc',
      imageUrl: 'assets/icons/award-prize.svg',
    ),
  ];

  bool _showIntroduceScreen = false;
  CurrentPlayingData? _currentPlayingData;

  String get userId => _userId;
  String get playerName => _playerName;
  String get yourScore => _yourScore;
  int get yourRank => _yourRank;
  List<Achievement> get achievements => _achievements;

  bool get showIntroduceScreenModal => _showIntroduceScreen;
  CurrentPlayingData? get currentPlayingData => _currentPlayingData;

  FirebaseFirestore db = FirebaseFirestore.instance;

  /// Creates an instance of [PlayerProgress] backed by an injected
  /// persistence [store].
  PlayerProgress({PlayerProgressPersistence? store})
      : _store = store ?? LocalStoragePlayerProgressPersistence() {
    _getLatestFromStore();
  }

  /// Fetches the latest data from the backing persistence store.
  Future<void> _getLatestFromStore() async {
    final data = await _store.getCurrentPlayingData();
    if (data != null) {
      _currentPlayingData = data;
    }

    final userIdFromDB = await _store.getUserId();
    if (userIdFromDB != '') {
      final playersRef = db.collection('players');
      final doc = await playersRef.doc(userIdFromDB).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _playerName = data['name'] as String;
        _yourScore = data['score'].toString();

        _getAchievement(userIdFromDB);
        _userId = userIdFromDB;
        // 更新 rank
        _yourRank = await _getUserRank();
      }
    } else {
      _showIntroduceScreen = true;
    }
    notifyListeners();
  }

  /// 查詢前十名玩家
  Future<List<DocumentSnapshot>> getTopTenPlayers() async {
    final querySnapshot = await db
        .collection('players')
        .orderBy('score', descending: true)
        .limit(20)
        .get();

    return querySnapshot.docs;
  }

  Future<bool> createNewPlayer(String name) async {
    const initScore = 100;
    final player = <String, dynamic>{
      'name': name,
      'score': initScore,
      'achievements': [],
      'created_date': Timestamp.now(),
    };

    try {
      final playersRef = db.collection('players');
      final existPlayer = await playersRef.where('name', isEqualTo: name).get();
      if (existPlayer.docs.isNotEmpty) {
        return false;
      }

      final doc = await playersRef.add(player);
      await _store.setUserId(doc.id);
      _userId = doc.id;
      _yourScore = initScore.toString();
      _playerName = name;
      _yourRank = await _getUserRank();

      _showIntroduceScreen = false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 儲存積分到 firebase
  Future<bool> saveNewScore({
    required String newScore,
    required List<SelectedItem> selectedSymbols,
    required List<SelectedItem> selectedNumbers,
  }) async {
    final playerRef = db.collection('players').doc(userId);
    final convertedIntScore = int.parse(newScore);

    try {
      playerRef.update({
        'score': convertedIntScore.round(),
      });
      final newRank = await _getUserRank();

      // 更新成就
      List<String> newAchievements = ['first_play'];
      if (newRank == 1) {
        newAchievements.add('champion');
      }
      if (newRank == 2) {
        newAchievements.add('runner_up');
      }
      if (newRank == 2) {
        newAchievements.add('second_runner_up');
      }
      if (convertedIntScore == 0) {
        newAchievements.add('restart');
      }
      if (int.parse(_yourScore) < 0 && convertedIntScore > 0) {
        newAchievements.add('navigate_number');
      }
      if (selectedSymbols.every((e) => e.mathSymbol == MathSymbol.plus) ||
          selectedSymbols.every((e) => e.mathSymbol == MathSymbol.minus) ||
          selectedSymbols.every((e) => e.mathSymbol == MathSymbol.times) ||
          selectedSymbols.every((e) => e.mathSymbol == MathSymbol.divide) ||
          selectedNumbers.every((e) => e.number == -9) ||
          selectedNumbers.every((e) => e.number == -8) ||
          selectedNumbers.every((e) => e.number == -7) ||
          selectedNumbers.every((e) => e.number == -6) ||
          selectedNumbers.every((e) => e.number == -5) ||
          selectedNumbers.every((e) => e.number == -4) ||
          selectedNumbers.every((e) => e.number == -3) ||
          selectedNumbers.every((e) => e.number == -2) ||
          selectedNumbers.every((e) => e.number == -1) ||
          selectedNumbers.every((e) => e.number == 0) ||
          selectedNumbers.every((e) => e.number == 1) ||
          selectedNumbers.every((e) => e.number == 2) ||
          selectedNumbers.every((e) => e.number == 3) ||
          selectedNumbers.every((e) => e.number == 4) ||
          selectedNumbers.every((e) => e.number == 5) ||
          selectedNumbers.every((e) => e.number == 6) ||
          selectedNumbers.every((e) => e.number == 7) ||
          selectedNumbers.every((e) => e.number == 8) ||
          selectedNumbers.every((e) => e.number == 9)) {
        newAchievements.add('three_same');
      }
      if (convertedIntScore >= 1000 && convertedIntScore < 10000) {
        newAchievements.add('1000');
      }
      if (convertedIntScore >= 10000 && convertedIntScore < 100000) {
        newAchievements.add('10000');
      }
      if (convertedIntScore >= 100000) {
        newAchievements.add('100000');
      }

      playerRef.update({
        'achievements': FieldValue.arrayUnion(
          newAchievements,
        )
      });

      _yourScore = newScore;
      _yourRank = newRank;
      _getAchievement(_userId);

      return true;
    } catch (e) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> _getAchievement(String id) async {
    final playersRef = db.collection('players');
    final selfUserDoc = await playersRef.doc(id).get();
    final selfUser = selfUserDoc.data();
    List<dynamic> tempAchievements = selfUser!['achievements'] as List<dynamic>;

    _achievements = _achievements.map(
      (item) {
        bool isExist = tempAchievements.contains(item.id);
        if (isExist) {
          item.isAchieve = true;
          return item;
        }
        return item;
      },
    ).toList();
  }

  /// 從 firebase 取得自己名次
  Future<int> _getUserRank() async {
    final playersRef = db.collection('players');

    // 步驟1：取得自己的使用者資料
    final selfUserDoc = await playersRef.doc(userId).get();
    final selfUser = selfUserDoc.data();

    // 步驟2：取得自己的分數
    final selfScore = selfUser!['score'] as int;

    // 步驟3：查詢分數比自己高的使用者數量
    final higherScoreUsersQuery =
        playersRef.where('score', isGreaterThan: selfScore);
    final higherScoreUsersSnapshot = await higherScoreUsersQuery.get();
    final higherScoreUsersCount = higherScoreUsersSnapshot.docs.length;

    // 步驟4：計算自己的排名
    final selfRank = higherScoreUsersCount + 1;

    return selfRank;
  }

  void saveCurrentPlayingData({
    required int step,
    required List<MathSymbol> boxSymbols,
    required List<int> boxNumbers,
    required List<SelectedItem> selectedSymbols,
    required List<SelectedItem> selectedNumbers,
  }) {
    // 中離遊戲暫存
    _store.saveCurrentPlayingData(CurrentPlayingData(
      step: step,
      boxSymbols: boxSymbols,
      boxNumbers: boxNumbers,
      selectedSymbols: selectedSymbols,
      selectedNumbers: selectedNumbers,
    ));
  }

  Future<void> removeCurrentPlayingData() async {
    await _store.removeCurrentPlayingData();
    _currentPlayingData = null;
    notifyListeners();
  }
}
