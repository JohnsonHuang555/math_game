// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import '../app_lifecycle/app_lifecycle.dart';
import '../settings/settings.dart';
import 'songs.dart';
import 'sounds.dart';

/// Allows playing music and sound. A facade to `package:audioplayers`.
class AudioController {
  static final _log = Logger('AudioController');

  final AudioPlayer _musicPlayer;

  /// This is a list of [AudioPlayer] instances which are rotated to play
  /// sound effects.
  final AudioPlayer _sfxPlayer;

  final Queue<Song> _playlist;

  String? currentScreen;

  SettingsController? _settings;

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  bool _isPlaying = false;

  /// Creates an instance that plays music and sound.
  ///
  /// Use [polyphony] to configure the number of sound effects (SFX) that can
  /// play at the same time. A [polyphony] of `1` will always only play one
  /// sound (a new sound will stop the previous one). See discussion
  /// of [_sfxPlayer] to learn why this is the case.
  ///
  /// Background music does not count into the [polyphony] limit. Music will
  /// never be overridden by sound effects because that would be silly.
  AudioController()
      : assert(true),
        _musicPlayer = AudioPlayer(playerId: 'musicPlayer'),
        _sfxPlayer = AudioPlayer(playerId: 'sfxPlayer'),
        _playlist = Queue.of(List<Song>.of(songs)) {
    _musicPlayer.setReleaseMode(ReleaseMode.loop);
    unawaited(_preloadSfx());
  }

  /// Makes sure the audio controller is listening to changes
  /// of both the app lifecycle (e.g. suspended app) and to changes
  /// of settings (e.g. muted sound).
  void attachDependencies(AppLifecycleStateNotifier lifecycleNotifier,
      SettingsController settingsController) {
    _attachLifecycleNotifier(lifecycleNotifier);
    _attachSettings(settingsController);
  }

  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);
    _stopAllSound();
    _musicPlayer.dispose();
    _sfxPlayer.dispose();
  }

  /// Plays a single sound effect, defined by [type].
  ///
  /// The controller will ignore this call when the attached settings'
  /// [SettingsController.audioOn] is `true` or if its
  /// [SettingsController.soundsOn] is `false`.
  Future<void> playSfx(SfxType type) async {
    if (_isPlaying) {
      _isPlaying = false;
      await _sfxPlayer.stop();
    }
    final audioOn = _settings?.audioOn.value ?? false;
    if (!audioOn) {
      _log.fine(() => 'Ignoring playing sound ($type) because audio is muted.');
      return;
    }
    final soundsOn = _settings?.soundsOn.value ?? false;
    if (!soundsOn) {
      _log.fine(() =>
          'Ignoring playing sound ($type) because sounds are turned off.');
      return;
    }

    _log.fine(() => 'Playing sound: $type');
    final options = soundTypeToFilename(type);
    final filename = options[0];
    _log.fine(() => '- Chosen filename: $filename');

    _isPlaying = true;
    await _sfxPlayer.play(
      AssetSource('sfx/$filename'),
    );
  }

  Future<void> playMusic(String screenName) async {
    currentScreen = screenName;
    final audioOn = _settings?.audioOn.value ?? false;
    final musicOn = _settings?.musicOn.value ?? false;

    try {
      if (audioOn && musicOn) {
        if (screenName == 'main_menu') {
          await _musicPlayer
              .play(AssetSource('music/${_playlist.first.filename}'));
        } else {
          await _musicPlayer
              .play(AssetSource('music/${_playlist.last.filename}'));
        }
      }

      // Settings can change while the music player is preparing
      // to play a song (i.e. during the `await` above).
      // Unfortunately, `audioplayers` has a bug which will ignore calls
      // to `pause()` before that await is finished, so we need
      // to double check here.
      // See issue: https://github.com/bluefireteam/audioplayers/issues/1687
      if (!_settings!.audioOn.value || !_settings!.musicOn.value) {
        _log.fine('Settings changed while preparing to play song. '
            'Pausing music.');
        await _musicPlayer.pause();
      }
    } catch (e) {
      _log.severe('Could not play song', e);
    }
  }

  Future<void> pauseMusic() async {
    await _musicPlayer.pause();
  }

  /// Enables the [AudioController] to listen to [AppLifecycleState] events,
  /// and therefore do things like stopping playback when the game
  /// goes into the background.
  void _attachLifecycleNotifier(AppLifecycleStateNotifier lifecycleNotifier) {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);

    lifecycleNotifier.addListener(_handleAppLifecycle);
    _lifecycleNotifier = lifecycleNotifier;
  }

  /// Enables the [AudioController] to track changes to settings.
  /// Namely, when any of [SettingsController.audioOn],
  /// [SettingsController.musicOn] or [SettingsController.soundsOn] changes,
  /// the audio controller will act accordingly.
  void _attachSettings(SettingsController settingsController) {
    if (_settings == settingsController) {
      // Already attached to this instance. Nothing to do.
      return;
    }

    // Remove handlers from the old settings controller if present
    final oldSettings = _settings;
    if (oldSettings != null) {
      oldSettings.audioOn.removeListener(_audioOnHandler);
      oldSettings.musicOn.removeListener(_musicOnHandler);
      oldSettings.soundsOn.removeListener(_soundsOnHandler);
    }

    _settings = settingsController;

    // Add handlers to the new settings controller
    settingsController.audioOn.addListener(_audioOnHandler);
    settingsController.musicOn.addListener(_musicOnHandler);
    settingsController.soundsOn.addListener(_soundsOnHandler);
  }

  void _audioOnHandler() {
    _log.fine('audioOn changed to ${_settings!.audioOn.value}');
    if (_settings!.audioOn.value) {
      // All sound just got un-muted. Audio is on.
      if (_settings!.musicOn.value) {
        _startOrResumeMusic();
      }
    } else {
      // All sound just got muted. Audio is off.
      _stopAllSound();
    }
  }

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _stopAllSound();
      case AppLifecycleState.resumed:
        if (_settings!.audioOn.value && _settings!.musicOn.value) {
          _startOrResumeMusic();
        }
      case AppLifecycleState.inactive:
        // No need to react to this state change.
        break;
    }
  }

  void _musicOnHandler() {
    if (_settings!.musicOn.value) {
      // Music got turned on.
      if (_settings!.audioOn.value) {
        _startOrResumeMusic();
      }
    } else {
      // Music got turned off.
      _musicPlayer.pause();
    }
  }

  /// Preloads all sound effects.
  Future<void> _preloadSfx() async {
    _log.info('Preloading sound effects');
    // This assumes there is only a limited number of sound effects in the game.
    // If there are hundreds of long sound effect files, it's better
    // to be more selective when preloading.
    await AudioCache.instance.loadAll(SfxType.values
        .expand(soundTypeToFilename)
        .map((path) => 'sfx/$path')
        .toList());
  }

  void _soundsOnHandler() {
    if (_sfxPlayer.state == PlayerState.playing) {
      _sfxPlayer.stop();
    }
  }

  void _startOrResumeMusic() async {
    if (currentScreen == null) {
      _musicPlayer.stop();
      return;
    }
    if (_musicPlayer.source == null) {
      _log.info('No music source set. '
          'Start playing the current song in playlist.');
      await playMusic(currentScreen!);
      return;
    }

    _log.info('Resuming paused music.');
    try {
      _musicPlayer.resume();
    } catch (e) {
      // Sometimes, resuming fails with an "Unexpected" error.
      _log.severe("Error resuming music", e);
      // Try starting the song from scratch.
      playMusic(currentScreen!);
    }
  }

  void _stopAllSound() {
    _log.info('Stopping all sound');
    _musicPlayer.pause();
    _sfxPlayer.stop();
  }
}
