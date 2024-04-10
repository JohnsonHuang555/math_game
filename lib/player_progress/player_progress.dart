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
  static const maxHighestScoresPerPlayer = 10;

  /// By default, settings are persisted using
  /// [LocalStoragePlayerProgressPersistence] (i.e. NSUserDefaults on iOS,
  /// SharedPreferences on Android or local storage on the web).
  final PlayerProgressPersistence _store;

  int _highestLevelReached = 0;

  String _userId = '';
  String _playerName = '';
  String _yourScore = '---'; // 預設
  int _yourRank = 0;

  List<Achievement> _achievements = [
    Achievement(
      id: 'first_play',
      title: '小試身手',
      description: '完成一場遊戲',
      imageUrl: 'assets/icons/game-controller.svg',
    ),
    Achievement(
      id: 'champion',
      title: '冠軍',
      description: '成為第一名',
      imageUrl: 'assets/icons/game-controller.svg',
    ),
    Achievement(
      id: 'runner_up',
      title: '亞軍',
      description: '成為第二名',
      imageUrl: 'assets/icons/game-controller.svg',
    ),
    Achievement(
      id: 'second_runner_up',
      title: '季軍',
      description: '成為第三名',
      imageUrl: 'assets/icons/game-controller.svg',
    ),
    Achievement(
      id: 'restart',
      title: '從頭開始',
      description: '當分數歸零',
      imageUrl: 'assets/icons/game-controller.svg',
    ),
    Achievement(
      id: 'navigate_number',
      title: '負負得正',
      description: '當分數變負的',
      imageUrl: 'assets/icons/game-controller.svg',
    ),
    Achievement(
      id: 'three_same',
      title: '三條',
      description: '抽到三個一樣的符號或數字',
      imageUrl: 'assets/icons/game-controller.svg',
    ),
    Achievement(
      id: '1000',
      title: '1,000分',
      description: '達1000分',
      imageUrl: 'assets/icons/game-controller.svg',
    ),
    Achievement(
      id: '10000',
      title: '10,000分',
      description: '達10000分',
      imageUrl: 'assets/icons/game-controller.svg',
    ),
    Achievement(
      id: '100000',
      title: '100,000分',
      description: '達100000分',
      imageUrl: 'assets/icons/game-controller.svg',
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

  /// The highest level that the player has reached so far.
  int get highestLevelReached => _highestLevelReached;

  /// Resets the player's progress so it's like if they just started
  /// playing the game for the first time.
  void reset() {
    _highestLevelReached = 0;
    notifyListeners();
    _store.saveHighestLevelReached(_highestLevelReached);
  }

  /// Registers [level] as reached.
  ///
  /// If this is higher than [highestLevelReached], it will update that
  /// value and save it to the injected persistence store.
  void setLevelReached(int level) {
    if (level > _highestLevelReached) {
      _highestLevelReached = level;
      notifyListeners();

      unawaited(_store.saveHighestLevelReached(level));
    }
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
      await playersRef.doc(userIdFromDB).get().then((doc) async {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          _playerName = data['name'] as String;
          _yourScore = data['score'].toString();

          List<dynamic> yourArray = data['achievements'] as List<dynamic>;
          _achievements = _achievements.map(
            (item) {
              bool isExist = yourArray.contains(item.id);
              if (isExist) {
                item.isAchieve = true;
                return item;
              }
              return item;
            },
          ).toList();

          _userId = userIdFromDB;
          // 更新 rank
          _yourRank = await _getUserRank();
        }
      });
    } else {
      _showIntroduceScreen = true;
    }
    notifyListeners();
  }

  Future<bool> createNewPlayer(String name) async {
    const initScore = 100;
    final player = <String, dynamic>{
      'name': name,
      'score': initScore,
      'created_date': Timestamp.now(),
    };

    try {
      final doc = await db.collection('players').add(player);
      await _store.setUserId(doc.id);
      _userId = doc.id;
      _yourScore = initScore.toString();
      _playerName = name;
      _yourRank = await _getUserRank();

      _showIntroduceScreen = false;
      return true;
    } catch (e) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// 儲存積分到 firebase
  Future<bool> saveNewScore(String score) async {
    final data = {'score': double.parse(score).round()};
    try {
      await db
          .collection('players')
          .doc(userId)
          .set(data, SetOptions(merge: true));
      _yourScore = score;
      _yourRank = await _getUserRank();
      return true;
    } catch (e) {
      return false;
    } finally {
      notifyListeners();
    }
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
  }) async {
    // 中離遊戲暫存
    _store.saveCurrentPlayingData(CurrentPlayingData(
      step: step,
      boxSymbols: boxSymbols,
      boxNumbers: boxNumbers,
      selectedSymbols: selectedSymbols,
      selectedNumbers: selectedNumbers,
    ));
  }

  void removeCurrentPlayingData() {
    _store.removeCurrentPlayingData();
  }

  /// 查詢前十名玩家
  Future<List<DocumentSnapshot>> getTopTenPlayers() async {
    QuerySnapshot querySnapshot = await db
        .collection('players')
        .orderBy('score', descending: true)
        .limit(20)
        .get();

    return querySnapshot.docs;
  }
}
