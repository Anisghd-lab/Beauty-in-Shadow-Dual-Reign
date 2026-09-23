import 'dart:async';
import 'dart:typed_data';
import 'package:audioplayers_platform_interface/audioplayers_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test fake for [GlobalAudioplayersPlatformInterface].
class FakeGlobalAudioplayersPlatform
    extends GlobalAudioplayersPlatformInterface {
  final StreamController<GlobalAudioEvent> _eventController =
      StreamController<GlobalAudioEvent>.broadcast();

  @override
  Future<void> init() async {}

  @override
  Future<void> setGlobalAudioContext(AudioContext ctx) async {}

  @override
  Future<void> emitGlobalLog(String message) async {}

  @override
  Future<void> emitGlobalError(String code, String message) async {}

  @override
  Stream<GlobalAudioEvent> getGlobalEventStream() => _eventController.stream;
}

/// Test fake for [AudioplayersPlatformInterface].
class FakeAudioplayersPlatform extends AudioplayersPlatformInterface {
  final Map<String, StreamController<AudioEvent>> _eventControllers = {};

  @override
  Future<void> create(String playerId) async {
    _eventControllers[playerId] = StreamController<AudioEvent>.broadcast();
  }

  @override
  Future<void> dispose(String playerId) async {
    _eventControllers[playerId]?.close();
    _eventControllers.remove(playerId);
  }

  @override
  Future<void> emitError(String playerId, String code, String message) async {}

  @override
  Future<void> emitLog(String playerId, String message) async {}

  @override
  Future<int?> getCurrentPosition(String playerId) async => 0;

  @override
  Future<int?> getDuration(String playerId) async => 1000;

  @override
  Stream<AudioEvent> getEventStream(String playerId) {
    return _eventControllers
        .putIfAbsent(playerId, () => StreamController<AudioEvent>.broadcast())
        .stream;
  }

  @override
  Future<void> pause(String playerId) async {}

  @override
  Future<void> release(String playerId) async {}

  @override
  Future<void> resume(String playerId) async {}

  @override
  Future<void> seek(String playerId, Duration position) async {}

  @override
  Future<void> setAudioContext(String playerId, AudioContext context) async {}

  @override
  Future<void> setBalance(String playerId, double balance) async {}

  @override
  Future<void> setPlaybackRate(String playerId, double playbackRate) async {}

  @override
  Future<void> setPlayerMode(String playerId, PlayerMode playerMode) async {}

  @override
  Future<void> setReleaseMode(String playerId, ReleaseMode releaseMode) async {}

  @override
  Future<void> setSourceBytes(String playerId, Uint8List bytes,
      {String? mimeType}) async {}

  @override
  Future<void> setSourceUrl(
    String playerId,
    String url, {
    bool? isLocal,
    String? mimeType,
  }) async {}

  @override
  Future<void> setVolume(String playerId, double volume) async {}

  @override
  Future<void> stop(String playerId) async {}
}

/// Initializes mock audioplayers platform interfaces for headless Flutter tests.
void setupMockAudioPlatform() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AudioplayersPlatformInterface.instance = FakeAudioplayersPlatform();
  GlobalAudioplayersPlatformInterface.instance =
      FakeGlobalAudioplayersPlatform();
}
