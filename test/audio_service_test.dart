import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beauty_in_shadow/core/services/audio_service.dart';
import 'package:beauty_in_shadow/models/game_state.dart';
import 'package:beauty_in_shadow/ui/screens/menu_screen.dart';
import 'helpers/mock_audioplayers.dart';

void main() {
  setUpAll(() {
    setupMockAudioPlatform();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AudioService.instance = AudioService();
  });

  group('AudioService Unit Tests', () {
    test('Default audio state is not muted', () {
      final audio = AudioService.instance;
      expect(audio.isMuted, isFalse);
    });

    test('toggleMute updates isMuted and notifies listeners', () async {
      final audio = AudioService.instance;
      int notifications = 0;
      audio.addListener(() => notifications++);

      expect(audio.isMuted, isFalse);

      await audio.toggleMute();
      expect(audio.isMuted, isTrue);
      expect(notifications, 1);

      // Verify persisted value in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('bis_audio_muted'), isTrue);

      // Toggle back to unmuted
      await audio.toggleMute();
      expect(audio.isMuted, isFalse);
      expect(notifications, 2);
      expect(prefs.getBool('bis_audio_muted'), isFalse);
    });

    test('init loads persisted mute preference', () async {
      SharedPreferences.setMockInitialValues({'bis_audio_muted': true});
      final audio = AudioService();
      await audio.init();

      expect(audio.isMuted, isTrue);
    });

    test('Audio cue methods execute without throwing in headless test environment',
        () async {
      final audio = AudioService.instance;

      // Ensure all BGM and SFX methods are fail-soft
      await expectLater(audio.playBgm(CampaignType.street), completes);
      await expectLater(audio.playBgm(CampaignType.empire), completes);
      await expectLater(audio.stopBgm(), completes);
      await expectLater(audio.playSwipeSfx(true), completes);
      await expectLater(audio.playSwipeSfx(false), completes);
      await expectLater(audio.playGameOverSfx(), completes);
      await expectLater(audio.playWarningSfx(), completes);
      await expectLater(audio.playClickSfx(), completes);
    });

    test('Playing cues when muted silently suppresses playback', () async {
      final audio = AudioService.instance;
      await audio.toggleMute();
      expect(audio.isMuted, isTrue);

      await expectLater(audio.playBgm(CampaignType.street), completes);
      await expectLater(audio.playSwipeSfx(true), completes);
      await expectLater(audio.playGameOverSfx(), completes);
      await expectLater(audio.playWarningSfx(), completes);
      await expectLater(audio.playClickSfx(), completes);
    });
  });

  group('Audio UI Integration Tests', () {
    testWidgets('MenuScreen contains audio toggle and responds to taps',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      AudioService.instance = AudioService();

      await tester.pumpWidget(
        const MaterialApp(
          home: MenuScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final toggleFinder = find.byKey(const ValueKey('btn_audio_toggle'));
      expect(toggleFinder, findsOneWidget);
      expect(find.byIcon(Icons.volume_up), findsOneWidget);

      // Tap mute toggle
      await tester.tap(toggleFinder);
      await tester.pumpAndSettle();

      expect(AudioService.instance.isMuted, isTrue);
      expect(find.byIcon(Icons.volume_off), findsOneWidget);
    });
  });
}
