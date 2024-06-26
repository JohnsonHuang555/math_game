// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../helpers/current_playing_data.dart';

/// An interface of persistence stores for the player's progress.
///
/// Implementations can range from simple in-memory storage through
/// local preferences to cloud saves.
abstract class PlayerProgressPersistence {
  Future<String> getUserId();

  Future<void> setUserId(String id);

  Future<void> saveCurrentPlayingData(CurrentPlayingData data);

  Future<CurrentPlayingData?> getCurrentPlayingData();

  Future<void> removeCurrentPlayingData();
}
