import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beauty_in_shadow/core/services/audio_service.dart';
import 'package:beauty_in_shadow/core/services/codex_service.dart';
import 'package:beauty_in_shadow/models/card_model.dart';
import 'package:beauty_in_shadow/models/codex_entry.dart';
import 'package:beauty_in_shadow/models/game_state.dart';
import 'package:beauty_in_shadow/providers/game_controller.dart';
import 'package:beauty_in_shadow/ui/screens/codex_screen.dart';
import 'package:beauty_in_shadow/ui/screens/menu_screen.dart';

import 'helpers/mock_audioplayers.dart';

void main() {
  setUpAll(() {
    setupMockAudioPlatform();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AudioService.instance = AudioService();
    CodexService.instance = CodexService();
  });

  group('Codex Models & Canonicals', () {
    test('Canonical deaths definition includes 16 balanced entries (8 street, 8 empire)', () {
      expect(canonicalDeathEntries.length, 16);
      expect(canonicalStreetDeaths.length, 8);
      expect(canonicalEmpireDeaths.length, 8);

      for (final death in canonicalDeathEntries) {
        expect(death.id, isNotEmpty);
        expect(death.title, isNotEmpty);
        expect(death.description, isNotEmpty);
        expect(death.hint, isNotEmpty);
        expect(death.isUnlocked, isFalse);
        expect(death.deathCount, 0);
        expect(death.gaugeIndex, inInclusiveRange(1, 4));
      }
    });

    test('Canonical achievements definition includes 16 entries (8 street, 8 empire)', () {
      expect(canonicalStoryAchievements.length, 16);
      expect(canonicalStreetAchievements.length, 8);
      expect(canonicalEmpireAchievements.length, 8);

      for (final ach in canonicalStoryAchievements) {
        expect(ach.id, isNotEmpty);
        expect(ach.flag, isNotEmpty);
        expect(ach.title, isNotEmpty);
        expect(ach.description, isNotEmpty);
        expect(ach.hint, isNotEmpty);
        expect(ach.isUnlocked, isFalse);
      }
    });

    test('DeathEntry and StoryAchievement JSON serialization and copyWith', () {
      final death = canonicalStreetDeaths.first;
      final unlocked = death.copyWith(
        isUnlocked: true,
        deathCount: 3,
        lastDaysSurvived: 15,
        unlockedAt: DateTime(2026, 9, 23, 12, 0),
      );

      final json = unlocked.toJson();
      expect(json['id'], death.id);
      expect(json['isUnlocked'], isTrue);
      expect(json['deathCount'], 3);
      expect(json['lastDaysSurvived'], 15);

      final restored = DeathEntry.fromJson(json, death);
      expect(restored.isUnlocked, isTrue);
      expect(restored.deathCount, 3);
      expect(restored.lastDaysSurvived, 15);
      expect(restored.title, death.title);

      final ach = canonicalStreetAchievements.first;
      final unlockedAch = ach.copyWith(
        isUnlocked: true,
        unlockedAt: DateTime(2026, 9, 23, 12, 0),
      );
      final achJson = unlockedAch.toJson();
      final restoredAch = StoryAchievement.fromJson(achJson, ach);
      expect(restoredAch.isUnlocked, isTrue);
      expect(restoredAch.flag, ach.flag);
    });
  });

  group('CodexService Unit Tests', () {
    test('Initial state is empty and uncorrupted', () {
      final service = CodexService();
      expect(service.totalDecisions, 0);
      expect(service.getHighestStreak(CampaignType.street), 0);
      expect(service.getHighestStreak(CampaignType.empire), 0);
      expect(service.getUnlockedDeathCount(), 0);
      expect(service.getTotalDeathCount(), 16);
      expect(service.getUnlockedAchievementCount(), 0);
      expect(service.getTotalAchievementCount(), 16);
      expect(service.getDeathCompletionPercentage(), 0.0);
    });

    test('recordDeath unlocks entry, increments count and updates streak', () async {
      final service = CodexService();

      service.recordDeath(
        CampaignType.street,
        GameOverReason.gauge1Depleted,
        14,
      );

      expect(service.getUnlockedDeathCount(CampaignType.street), 1);
      expect(service.getUnlockedDeathCount(CampaignType.empire), 0);
      expect(service.getUnlockedDeathCount(), 1);
      expect(service.getHighestStreak(CampaignType.street), 14);

      final death = service
          .getDeaths(CampaignType.street)
          .firstWhere((d) => d.reason == GameOverReason.gauge1Depleted);
      expect(death.isUnlocked, isTrue);
      expect(death.deathCount, 1);
      expect(death.lastDaysSurvived, 14);
      expect(death.unlockedAt, isNotNull);

      // Record same death with higher day count
      service.recordDeath(
        CampaignType.street,
        GameOverReason.gauge1Depleted,
        22,
      );

      final updatedDeath = service
          .getDeaths(CampaignType.street)
          .firstWhere((d) => d.reason == GameOverReason.gauge1Depleted);
      expect(updatedDeath.deathCount, 2);
      expect(updatedDeath.lastDaysSurvived, 22);
      expect(service.getHighestStreak(CampaignType.street), 22);
    });

    test('recordDecision and recordSurvivalDays track lifetime metrics', () {
      final service = CodexService();
      expect(service.totalDecisions, 0);

      service.recordDecision();
      service.recordDecision();
      expect(service.totalDecisions, 2);

      service.recordSurvivalDays(CampaignType.empire, 35);
      expect(service.getHighestStreak(CampaignType.empire), 35);

      // Lower days does not lower highest streak
      service.recordSurvivalDays(CampaignType.empire, 12);
      expect(service.getHighestStreak(CampaignType.empire), 35);
    });

    test('recordFlagIfAchievement unlocks narrative achievements', () {
      final service = CodexService();

      expect(service.getUnlockedAchievementCount(), 0);

      // Irrelevant flag
      service.recordFlagIfAchievement('flag_inconnu_random');
      expect(service.getUnlockedAchievementCount(), 0);

      // Known Street story flag
      service.recordFlagIfAchievement('kimmie_a_la_cle');
      expect(service.getUnlockedAchievementCount(CampaignType.street), 1);
      expect(service.getUnlockedAchievementCount(CampaignType.empire), 0);

      final ach = service
          .getAchievements(CampaignType.street)
          .firstWhere((a) => a.flag == 'kimmie_a_la_cle');
      expect(ach.isUnlocked, isTrue);
      expect(ach.title, 'Clé des Bell Dérobée');

      // Known Empire story flag
      service.recordFlagIfAchievement('dynastie_eternelle');
      expect(service.getUnlockedAchievementCount(CampaignType.empire), 1);
      expect(service.getUnlockedAchievementCount(), 2);
    });

    test('Progress percentage calculations are accurate', () {
      final service = CodexService();
      expect(service.getDeathCompletionPercentage(), 0.0);

      // Unlock 4 deaths out of 16
      service.recordDeath(CampaignType.street, GameOverReason.gauge1Depleted, 5);
      service.recordDeath(CampaignType.street, GameOverReason.gauge1Overflow, 6);
      service.recordDeath(CampaignType.empire, GameOverReason.gauge1Depleted, 7);
      service.recordDeath(CampaignType.empire, GameOverReason.gauge1Overflow, 8);

      expect(service.getUnlockedDeathCount(), 4);
      expect(service.getDeathCompletionPercentage(), 4 / 16); // 25%
      expect(service.getDeathCompletionPercentage(CampaignType.street), 2 / 8);
    });

    test('Persistence to SharedPreferences and restoring via init()', () async {
      SharedPreferences.setMockInitialValues({});
      final service1 = CodexService();

      service1.recordDecision();
      service1.recordDecision();
      service1.recordDeath(
          CampaignType.street, GameOverReason.gauge2Depleted, 18);
      service1.recordFlagIfAchievement('danseuse_active');

      // Ensure written to storage
      await service1.save();

      // Read back raw JSON from prefs
      final prefs = await SharedPreferences.getInstance();
      final rawJson = prefs.getString(CodexService.codexStorageKey);
      expect(rawJson, isNotNull);

      final parsed = jsonDecode(rawJson!) as Map<String, dynamic>;
      expect(parsed['totalDecisions'], 2);
      expect(parsed['highestStreaks']['street'], 18);
      expect(parsed['unlockedDeaths']['ST_D2_MIN'], isNotNull);
      expect(parsed['unlockedAchievements']['ACH_ST_DANSE'], isNotNull);

      // Instantiate fresh service and init
      final service2 = CodexService();
      await service2.init();

      expect(service2.totalDecisions, 2);
      expect(service2.getHighestStreak(CampaignType.street), 18);
      expect(service2.getUnlockedDeathCount(CampaignType.street), 1);
      expect(service2.getUnlockedAchievementCount(CampaignType.street), 1);

      // Test clearAll
      await service2.clearAll();
      expect(service2.totalDecisions, 0);
      expect(service2.getUnlockedDeathCount(), 0);
      expect(service2.getHighestStreak(CampaignType.street), 0);
    });
  });

  group('GameController & Codex Integration', () {
    test('Card decisions increment decisions and track deaths in CodexService', () {
      final codex = CodexService.instance;

      final testDeck = [
        GameCard(
          id: 'TEST_01',
          campaign: 'STREET',
          speakerName: 'Indicateur',
          speakerRole: 'Guetteur',
          speakerAvatar: 'assets/avatar.png',
          dialogue: 'La police approche.',
          leftChoice: ChoiceImpact(
            text: 'Fuir',
            deltaGauge1: -60, // Kills gauge 1 (50 - 60 = 0 => death)
            deltaGauge2: 0,
            deltaGauge3: 0,
            deltaGauge4: 0,
            setFlags: ['fuite_reussie'],
          ),
          rightChoice: ChoiceImpact(
            text: 'Rester',
            deltaGauge1: 10,
            deltaGauge2: 10,
            deltaGauge3: 10,
            deltaGauge4: 10,
            setFlags: ['kimmie_a_la_cle'],
          ),
        ),
      ];

      final controller = GameController(
        initialState: GameState.initial(campaign: CampaignType.street),
        deck: testDeck,
      );

      // Select right choice first: adds flag 'kimmie_a_la_cle' and increments decisions
      controller.onChoiceSelected(true);

      expect(codex.totalDecisions, 1);
      expect(codex.getUnlockedAchievementCount(CampaignType.street), 1);
      expect(controller.isGameOver, isFalse);

      // Now reset and select left choice: causes death on Gauge 1
      controller.restart(CampaignType.street);
      controller.setDeck(testDeck);
      controller.onChoiceSelected(false);

      expect(controller.isGameOver, isTrue);
      expect(controller.state.deathReason, GameOverReason.gauge1Depleted);
      expect(codex.getUnlockedDeathCount(CampaignType.street), 1);

      final death = codex
          .getDeaths(CampaignType.street)
          .firstWhere((d) => d.reason == GameOverReason.gauge1Depleted);
      expect(death.isUnlocked, isTrue);
    });
  });

  group('CodexScreen Widget Tests', () {
    testWidgets('Renders header, progress bar, dual tabs and locked cards',
        (WidgetTester tester) async {
      final codex = CodexService();

      await tester.pumpWidget(
        MaterialApp(
          home: CodexScreen(codexService: codex),
        ),
      );
      await tester.pumpAndSettle();

      // Top title
      expect(find.text('LE GRIMOIRE DES OMBRES'), findsOneWidget);
      expect(find.text('Archives secrètes • Destins & Conquêtes'), findsOneWidget);

      // Progress bar header
      expect(find.byKey(const ValueKey('codex_progress_bar')), findsOneWidget);
      expect(find.text('FINS DÉCOUVERTES : 0 / 16'), findsOneWidget);

      // Dual Tabs
      expect(find.byKey(const ValueKey('tab_street')), findsOneWidget);
      expect(find.byKey(const ValueKey('tab_empire')), findsOneWidget);
      expect(find.text('L\'Ombre de la Rue'), findsOneWidget);
      expect(find.text('Les Secrets de l\'Empire'), findsOneWidget);

      // Default tab is Street, checking for locked redacted dossiers
      expect(find.text('DOSSIER CLASSÉ'), findsWidgets);
      expect(find.text('FINS CANONIQUES (0/8)'), findsOneWidget);

      // Scroll down to achievements section in the active ListView
      await tester.drag(find.byType(ListView).first, const Offset(0, -800));
      await tester.pumpAndSettle();
      expect(find.text('FAITS D\'ARMES & SECRETS (0/8)'), findsOneWidget);
    });

    testWidgets('Unlocked death displays title, lore and metadata',
        (WidgetTester tester) async {
      final codex = CodexService();
      codex.recordDeath(
        CampaignType.street,
        GameOverReason.gauge1Depleted,
        17,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: CodexScreen(codexService: codex),
        ),
      );
      await tester.pumpAndSettle();

      // Progress now 1 / 16
      expect(find.text('FINS DÉCOUVERTES : 1 / 16'), findsOneWidget);

      // ST_D1_MIN is Ruine Morale
      expect(find.text('Ruine Morale'), findsOneWidget);
      expect(
        find.textContaining('Votre réputation s\'effondre dans les bas-fonds.'),
        findsOneWidget,
      );
      expect(find.text('Record sur ce destin : 17 jours'), findsOneWidget);
      expect(find.text('Subi 1 fois'), findsOneWidget);
    });

    testWidgets('Switching tabs to Empire displays empire deaths and secrets',
        (WidgetTester tester) async {
      final codex = CodexService();
      codex.recordDeath(
        CampaignType.empire,
        GameOverReason.gauge1Depleted,
        30,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: CodexScreen(codexService: codex),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to Empire Tab
      await tester.tap(find.byKey(const ValueKey('tab_empire')));
      await tester.pumpAndSettle();

      // Should display Destitution Royale
      expect(find.text('Destitution Royale'), findsOneWidget);
      expect(
        find.textContaining('Destitution royale. La cour impériale'),
        findsOneWidget,
      );
      expect(find.text('Record sur ce destin : 30 jours'), findsOneWidget);
    });

    testWidgets('Back button pops navigation', (WidgetTester tester) async {
      final codex = CodexService();
      bool popped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CodexScreen(codexService: codex),
                  ),
                );
                popped = true;
              },
              child: const Text('Open Codex'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Codex'));
      await tester.pumpAndSettle();

      expect(find.text('LE GRIMOIRE DES OMBRES'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('btn_codex_back')));
      await tester.pumpAndSettle();

      expect(popped, isTrue);
    });
  });

  group('MenuScreen Archives Navigation', () {
    testWidgets('MenuScreen contains btn_open_codex and navigates to CodexScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MenuScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Archives button exists
      final archivesBtn = find.byKey(const ValueKey('btn_open_codex'));
      expect(archivesBtn, findsOneWidget);

      // Tap Archives button
      await tester.tap(archivesBtn);
      await tester.pumpAndSettle();

      // Should have navigated to CodexScreen
      expect(find.byType(CodexScreen), findsOneWidget);
      expect(find.text('LE GRIMOIRE DES OMBRES'), findsOneWidget);
    });
  });
}
