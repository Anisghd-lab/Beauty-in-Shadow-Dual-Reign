import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/game_state.dart';

/// Service responsible for managing background music (BGM) and sound effects (SFX).
///
/// Features:
/// - Singleton instance with reactive [ChangeNotifier] state.
/// - Dedicated [AudioPlayer] for looping ambient tracks and low-latency SFX.
/// - Persistent mute state across game launches via [SharedPreferences].
/// - Resilient fail-soft architecture catching un-decoded, missing audio assets,
///   or uninitialized test environments.
class AudioService extends ChangeNotifier {
  final SharedPreferences? injectedPrefs;
  AudioPlayer? injectedBgmPlayer;
  AudioPlayer? injectedSfxPlayer;

  AudioPlayer? _bgmPlayer;
  AudioPlayer? _sfxPlayer;

  AudioService({
    this.injectedPrefs,
    this.injectedBgmPlayer,
    this.injectedSfxPlayer,
  });

  static AudioService? _instance;
  static AudioService get instance => _instance ??= AudioService();
  static set instance(AudioService value) => _instance = value;

  static const String _mutedKey = 'bis_audio_muted';
  static const double bgmDefaultVolume = 0.4;
  static const double sfxDefaultVolume = 1.0;

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  CampaignType? _currentCampaign;
  CampaignType? get currentCampaign => _currentCampaign;

  Future<SharedPreferences> get _prefs async =>
      injectedPrefs ?? await SharedPreferences.getInstance();

  bool get _isBindingInitialized {
    try {
      WidgetsBinding.instance;
      return true;
    } catch (_) {
      return false;
    }
  }

  AudioPlayer? get bgmPlayer {
    if (injectedBgmPlayer != null) return injectedBgmPlayer;
    if (_bgmPlayer != null) return _bgmPlayer;
    if (!_isBindingInitialized) return null;
    try {
      _bgmPlayer = AudioPlayer();
      return _bgmPlayer;
    } catch (e) {
      debugPrint('AudioService bgmPlayer init fallback: $e');
      return null;
    }
  }

  AudioPlayer? get sfxPlayer {
    if (injectedSfxPlayer != null) return injectedSfxPlayer;
    if (_sfxPlayer != null) return _sfxPlayer;
    if (!_isBindingInitialized) return null;
    try {
      _sfxPlayer = AudioPlayer();
      return _sfxPlayer;
    } catch (e) {
      debugPrint('AudioService sfxPlayer init fallback: $e');
      return null;
    }
  }

  /// Initializes audio state and loads user mute preference.
  Future<void> init() async {
    try {
      final prefs = await _prefs;
      _isMuted = prefs.getBool(_mutedKey) ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('AudioService init fallback: $e');
    }
  }

  /// Toggles mute state, stops/resumes current BGM, and persists choice.
  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    notifyListeners();

    try {
      final prefs = await _prefs;
      await prefs.setBool(_mutedKey, _isMuted);

      if (_isMuted) {
        await bgmPlayer?.pause();
      } else {
        if (_currentCampaign != null) {
          await playBgm(_currentCampaign!);
        }
      }
    } catch (e) {
      debugPrint('AudioService toggleMute fallback: $e');
    }
  }

  /// Plays dark ambient BGM for Street or luxurious piano/strings for Empire in loop.
  Future<void> playBgm(CampaignType campaign) async {
    _currentCampaign = campaign;
    if (_isMuted) return;

    final assetPath = campaign == CampaignType.street
        ? 'audio/street_ambient.mp3'
        : 'audio/empire_ambient.mp3';

    try {
      final player = bgmPlayer;
      if (player == null) return;
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(bgmDefaultVolume);
      await player.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('AudioService playBgm fallback ($assetPath): $e');
    }
  }

  /// Smoothly stops background music.
  Future<void> stopBgm() async {
    try {
      await bgmPlayer?.stop();
    } catch (e) {
      debugPrint('AudioService stopBgm fallback: $e');
    }
  }

  /// Triggers crisp card swipe sound effect.
  Future<void> playSwipeSfx(bool isRight) async {
    final assetPath =
        isRight ? 'audio/swipe_right.mp3' : 'audio/swipe_left.mp3';
    await _playSfx(assetPath);
  }

  /// Plays fatal chord / broken glass sound when reign ends.
  Future<void> playGameOverSfx() async {
    await _playSfx('audio/game_over.mp3');
  }

  /// Triggers heartbeat / warning pulse when any gauge drops <= 20%.
  Future<void> playWarningSfx() async {
    await _playSfx('audio/gauge_warning.mp3');
  }

  /// Plays subtle tactile UI tap feedback.
  Future<void> playClickSfx() async {
    await _playSfx('audio/button_click.mp3');
  }

  /// Internal helper to dispatch sound effects with error suppression.
  Future<void> _playSfx(String assetPath) async {
    if (_isMuted) return;

    try {
      final player = sfxPlayer;
      if (player == null) return;
      await player.setVolume(sfxDefaultVolume);
      await player.play(
        AssetSource(assetPath),
        mode: PlayerMode.lowLatency,
      );
    } catch (e) {
      debugPrint('AudioService SFX fallback ($assetPath): $e');
    }
  }

  @override
  void dispose() {
    _bgmPlayer?.dispose();
    _sfxPlayer?.dispose();
    injectedBgmPlayer?.dispose();
    injectedSfxPlayer?.dispose();
    super.dispose();
  }
}
