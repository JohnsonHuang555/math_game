// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

List<String> soundTypeToFilename(SfxType type) {
  switch (type) {
    case SfxType.buttonPlay:
      return const [
        'play_button.mp3',
      ];
    case SfxType.buttonTap:
      return const [
        'all_button.mp3',
      ];
    case SfxType.buttonBack:
      return const [
        'back_cancel_button.mp3',
      ];
    case SfxType.buttonGaming:
      return const [
        'game_playing_button.mp3',
      ];
    case SfxType.congrats:
      return const [
        'congrats.mp3',
      ];
  }
}

enum SfxType {
  buttonPlay,
  buttonTap,
  buttonBack,
  buttonGaming,
  congrats,
}
