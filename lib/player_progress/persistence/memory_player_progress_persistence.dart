// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:basic/helpers/current_playing_data.dart';

import '../../helpers/math_symbol.dart';
import 'player_progress_persistence.dart';

/// An in-memory implementation of [PlayerProgressPersistence].
/// Useful for testing.
class MemoryOnlyPlayerProgressPersistence implements PlayerProgressPersistence {
  int level = 0;
  String userId = '';

  // 遊戲階段
  int? step;
  // 當前符號
  List<MathSymbol>? boxSymbols;
  // 當前數字
  List<int>? boxNumbers;
  List<SelectedItem>? selectedSymbols;
  List<SelectedItem>? selectedNumbers;

  @override
  Future<int> getHighestLevelReached() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return level;
  }

  @override
  Future<void> saveHighestLevelReached(int level) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    this.level = level;
  }

  @override
  Future<String> getUserId() async {
    return userId;
  }

  @override
  Future<void> setUserId(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    this.userId = userId;
  }

  @override
  Future<void> saveCurrentPlayingData(CurrentPlayingData data) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    step = data.step;
    boxSymbols = data.boxSymbols;
    boxNumbers = data.boxNumbers;
    selectedSymbols = data.selectedSymbols;
    selectedNumbers = data.selectedNumbers;
  }

  @override
  Future<CurrentPlayingData?> getCurrentPlayingData() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return  null;
  }

  @override
  Future<void> removeCurrentPlayingData() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    step = null;
    boxSymbols = null;
    boxNumbers = null;
    selectedSymbols = null;
    selectedNumbers = null;
  }
}
