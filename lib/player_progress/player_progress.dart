// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'persistence/local_storage_player_progress_persistence.dart';
import 'persistence/player_progress_persistence.dart';

/// Encapsulates the player's progress.
class PlayerProgress extends ChangeNotifier {
  static const maxHighestScoresPerPlayer = 10;

  /// By default, settings are persisted using
  /// [LocalStoragePlayerProgressPersistence] (i.e. NSUserDefaults on iOS,
  /// SharedPreferences on Android or local storage on the web).
  final PlayerProgressPersistence _store;

  int _highestLevelReached = 0;

  String _userId = '';
  String _editedPlayerName = '';
  String _playerName = '';
  String _yourScore = '---'; // 預設
  int _yourRank = 0;

  String get userId => _userId;
  String get playerName => _playerName;
  String get editedPlayerName => _editedPlayerName;
  String get yourScore => _yourScore;
  int get yourRank => _yourRank;

  // FirebaseFirestore db = FirebaseFirestore.instance;

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
    // final usersRef = db.collection('players');
    // await db.collection("players").get().then((event) {
    //   for (var doc in event.docs) {
    //     print("${doc.id} => ${doc.data()}");
    //   }
    // });
    // await usersRef.doc('3bHWeJHfWYsYJnSJmFSf').get().then((doc) async {
    //   if (doc.exists) {
    //     final data = doc.data() as Map<String, dynamic>;
    //     _playerName = data['name'] as String;
    //     _yourScore = data['score'].toString();
    //     print(_playerName);
    //     print(_yourScore);
    //     // final rank = await getUserRank();
    //     // _yourRank = rank;
    //   }
    // });
    // final level = await _store.getHighestLevelReached();
    // if (level > _highestLevelReached) {
    //   _highestLevelReached = level;
    //   notifyListeners();
    // } else if (level < _highestLevelReached) {
    //   await _store.saveHighestLevelReached(_highestLevelReached);
    // }
  }
}
