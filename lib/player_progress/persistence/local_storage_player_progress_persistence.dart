// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:basic/helpers/math_symbol.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/current_playing_data.dart';
import 'player_progress_persistence.dart';

/// An implementation of [PlayerProgressPersistence] that uses
/// `package:shared_preferences`.
class LocalStoragePlayerProgressPersistence extends PlayerProgressPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<int> getHighestLevelReached() async {
    final prefs = await instanceFuture;
    return prefs.getInt('highestLevelReached') ?? 0;
  }

  @override
  Future<void> saveHighestLevelReached(int level) async {
    final prefs = await instanceFuture;
    await prefs.setInt('highestLevelReached', level);
  }

  @override
  Future<String> getUserId() async {
    final prefs = await instanceFuture;
    return prefs.getString('userId') ?? '';
  }

  @override
  Future<void> setUserId(String id) async {
    final prefs = await instanceFuture;
    await prefs.setString('userId', id);
  }

  @override
  Future<void> saveCurrentPlayingData(CurrentPlayingData data) async {
    String convertedCurrentPlayingData = jsonEncode(data);

    final prefs = await instanceFuture;
    await prefs.setString('currentPlayingData', convertedCurrentPlayingData);
  }

  @override
  Future<CurrentPlayingData?> getCurrentPlayingData() async {
    final prefs = await instanceFuture;
    final currentPlayingData = prefs.getString('currentPlayingData');
    if (currentPlayingData != null) {
      final dataMap = jsonDecode(currentPlayingData) as Map<String, dynamic>;
      return CurrentPlayingData.fromJson(dataMap);
    } else {
      return null;
    }
  }

  @override
  Future<void> removeCurrentPlayingData() async {
    final prefs = await instanceFuture;
    await prefs.remove('currentPlayingData');
  }
}
