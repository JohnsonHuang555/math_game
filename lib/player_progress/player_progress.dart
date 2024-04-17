// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:basic/helpers/current_playing_data.dart';
import 'package:easy_localization/easy_localization.dart';
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

/// 道具
class Item {
  String id;
  String title;
  String description;
  int count = 0;
  String imageUrl;
  Item({
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

  String _userId = '';
  String _playerName = '';
  String _yourScore = '---'; // 預設
  int _yourRank = 0;

  List<Achievement> _achievements = [
    Achievement(
      id: 'first_play',
      title: 'first_play'.tr(),
      description: 'first_play_desc'.tr(),
      imageUrl: 'assets/icons/game-controller.svg',
    ),
    Achievement(
      id: 'champion',
      title: 'champion'.tr(),
      description: 'champion_desc'.tr(),
      imageUrl: 'assets/icons/medal-reward-1.svg',
    ),
    Achievement(
      id: 'runner_up',
      title: 'runner_up'.tr(),
      description: 'runner_up_desc'.tr(),
      imageUrl: 'assets/icons/medal-reward-2.svg',
    ),
    Achievement(
      id: 'second_runner_up',
      title: 'second_runner_up'.tr(),
      description: 'second_runner_up_desc'.tr(),
      imageUrl: 'assets/icons/medal-reward-3.svg',
    ),
    Achievement(
      id: 'restart',
      title: 'restart'.tr(),
      description: 'restart_desc'.tr(),
      imageUrl: 'assets/icons/rocket.svg',
    ),
    Achievement(
      id: 'navigate_number',
      title: 'navigate_number'.tr(),
      description: 'navigate_number_desc'.tr(),
      imageUrl: 'assets/icons/sign-plus-minus.svg',
    ),
    Achievement(
      id: 'three_same',
      title: 'three_same'.tr(),
      description: 'three_same_desc'.tr(),
      imageUrl: 'assets/icons/playing-cards.svg',
    ),
    Achievement(
      id: '1000',
      title: 'thousand'.tr(),
      description: 'thousand_desc'.tr(),
      imageUrl: 'assets/icons/award-prize.svg',
    ),
    Achievement(
      id: '10000',
      title: 'ten_thousand'.tr(),
      description: 'ten_thousand_desc'.tr(),
      imageUrl: 'assets/icons/award-prize.svg',
    ),
    Achievement(
      id: '100000',
      title: 'one_hundred_thousand'.tr(),
      description: 'one_hundred_thousand_desc'.tr(),
      imageUrl: 'assets/icons/award-prize.svg',
    ),
  ];

  final Map<String, Item> _items = {
    'magnifier': Item(
      id: 'magnifier',
      title: 'magnifier'.tr(),
      description: '',
      imageUrl: '',
    ),
    'elimination': Item(
      id: 'elimination',
      title: 'elimination'.tr(),
      description: '',
      imageUrl: '',
    ),
    'reset': Item(
      id: 'reset',
      title: 'reset'.tr(),
      description: '',
      imageUrl: '',
    ),
    'symbol_controller': Item(
      id: 'symbol_controller',
      title: 'symbol_controller'.tr(),
      description: '',
      imageUrl: '',
    ),
    'number_controller': Item(
      id: 'number_controller',
      title: 'number_controller'.tr(),
      description: '',
      imageUrl: '',
    ),
  };

  bool _showIntroduceScreen = false;
  CurrentPlayingData? _currentPlayingData;

  String get userId => _userId;
  String get playerName => _playerName;
  String get yourScore => _yourScore;
  int get yourRank => _yourRank;
  List<Achievement> get achievements => _achievements;
  Map<String, Item> get items => _items;

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
        _getItems(userIdFromDB);
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
      'items': [0, 0, 0, 0, 0],
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
    List<dynamic> tempAchievements = selfUser!['achievements'] as List<String>;

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

  Future<void> _getItems(String id) async {
    final playersRef = db.collection('players');
    final selfUserDoc = await playersRef.doc(id).get();
    final selfUser = selfUserDoc.data();
    _items.update('magnifier', (value) {
      value.count = selfUser!['items'][0] as int;
      return value;
    });
    _items.update('elimination', (value) {
      value.count = selfUser!['items'][1] as int;
      return value;
    });
    _items.update('reset', (value) {
      value.count = selfUser!['items'][2] as int;
      return value;
    });
    _items.update('symbol_controller', (value) {
      value.count = selfUser!['items'][3] as int;
      return value;
    });
    _items.update('number_controller', (value) {
      value.count = selfUser!['items'][4] as int;
      return value;
    });
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
}
