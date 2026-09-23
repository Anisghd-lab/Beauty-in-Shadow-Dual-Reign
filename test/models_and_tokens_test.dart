import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beauty_in_shadow/core/constants/app_colors.dart';
import 'package:beauty_in_shadow/models/card_model.dart';
import 'package:beauty_in_shadow/models/game_state.dart';

void main() {
  group('AppColors Design Tokens', () {
    test('Dark neo-noir surfaces match exact hex values', () {
      expect(AppColors.obsidian, const Color(0xFF0B0C10));
      expect(AppColors.darkSurface, const Color(0xFF12141D));
      expect(AppColors.cardSurface, const Color(0xFF161922));
      expect(AppColors.border, const Color(0xFF1F2833));
    });

    test('Street faction accents match exact hex values', () {
      expect(AppColors.neonViolet, const Color(0xFF8A2BE2));
      expect(AppColors.cyan, const Color(0xFF00F0FF));
      expect(AppColors.riskRed, const Color(0xFFFF0055));
    });

    test('Empire faction accents match exact hex values', () {
      expect(AppColors.champagneGold, const Color(0xFFD4AF37));
      expect(AppColors.ivory, const Color(0xFFF5F5F7));
      expect(AppColors.deepBlood, const Color(0xFF8B0000));
    });

    test('Status indicators match exact hex values', () {
      expect(AppColors.statusGood, const Color(0xFF10B981));
      expect(AppColors.statusWarning, const Color(0xFFF59E0B));
      expect(AppColors.statusDanger, const Color(0xFFEF4444));
      expect(AppColors.text, const Color(0xFFF3F4F6));
    });
  });

  group('ChoiceImpact & GameCard Models', () {
    test('ChoiceImpact defaults and copyWith', () {
      const impact = ChoiceImpact(text: 'Rejeter');
      expect(impact.deltaGauge1, 0);
      expect(impact.deltaGauge2, 0);
      expect(impact.deltaGauge3, 0);
      expect(impact.deltaGauge4, 0);
      expect(impact.setFlags, isEmpty);
      expect(impact.nextCardId, isNull);
      expect(impact.hasGaugeImpact, isFalse);
      expect(impact.hasStoryImpact, isFalse);

      final modified = impact.copyWith(
        deltaGauge1: 15,
        deltaGauge2: -10,
        setFlags: ['allied_syndicate'],
        nextCardId: 'card_002',
      );
      expect(modified.deltaGauge1, 15);
      expect(modified.deltaGauge2, -10);
      expect(modified.hasGaugeImpact, isTrue);
      expect(modified.hasStoryImpact, isTrue);
      expect(modified.setFlags, contains('allied_syndicate'));
      expect(modified.nextCardId, 'card_002');
    });

    test('ChoiceImpact serialization round-trip', () {
      const original = ChoiceImpact(
        text: 'Négocier',
        deltaGauge1: -5,
        deltaGauge2: 20,
        deltaGauge3: 10,
        deltaGauge4: -15,
        setFlags: ['flag_a', 'flag_b'],
        nextCardId: 'next_99',
      );

      final json = original.toJson();
      final restored = ChoiceImpact.fromJson(json);

      expect(restored, equals(original));
      expect(restored.deltaGauge2, 20);
      expect(restored.nextCardId, 'next_99');
    });

    test('GameCard eligibility and flag checks', () {
      const card = GameCard(
        id: 'street_ambush',
        campaign: 'STREET',
        speakerName: 'Viper',
        speakerRole: 'Guetteur',
        speakerAvatar: 'assets/avatars/viper.png',
        dialogue: 'Les flics encerclent l\'entrepôt!',
        leftChoice: ChoiceImpact(text: 'Tirer', deltaGauge3: 30),
        rightChoice: ChoiceImpact(text: 'Fuir', deltaGauge1: -15),
        requiredFlags: ['gang_leader'],
        forbiddenFlags: ['arrested'],
      );

      expect(card.isStreet, isTrue);
      expect(card.isEmpire, isFalse);

      // Missing required flag
      expect(card.isEligible({'veteran'}), isFalse);

      // Has required flag and no forbidden flag
      expect(card.isEligible({'gang_leader'}), isTrue);

      // Has required flag but ALSO has forbidden flag
      expect(card.isEligible({'gang_leader', 'arrested'}), isFalse);
    });

    test('GameCard serialization round-trip', () {
      const card = GameCard(
        id: 'emp_senate_01',
        campaign: 'EMPIRE',
        speakerName: 'Lord Vane',
        speakerRole: 'Sénateur',
        speakerAvatar: 'assets/avatars/vane.png',
        dialogue: 'Le peuple gronde aux portes.',
        leftChoice: ChoiceImpact(text: 'Réprimer', deltaGauge4: -20, deltaGauge3: 15),
        rightChoice: ChoiceImpact(text: 'Distribuer du grain', deltaGauge2: -25, deltaGauge4: 20),
        requiredFlags: ['crowned'],
        forbiddenFlags: ['exiled'],
      );

      final json = card.toJson();
      final restored = GameCard.fromJson(json);

      expect(restored, equals(card));
      expect(restored.isEmpire, isTrue);
      expect(restored.leftChoice.deltaGauge4, -20);
    });
  });

  group('GameState and checkStatus()', () {
    test('Default initial state is alive with 50 in all gauges', () {
      final state = GameState.initial(campaign: CampaignType.street);
      expect(state.campaign, CampaignType.street);
      expect(state.gauge1, 50);
      expect(state.gauge2, 50);
      expect(state.gauge3, 50);
      expect(state.gauge4, 50);
      expect(state.dayCount, 1);
      expect(state.activeFlags, isEmpty);
      expect(state.isGameOver, isFalse);
      expect(state.deathReason, isNull);
      expect(state.deathMessage, isNull);

      state.checkStatus();
      expect(state.isGameOver, isFalse);
    });

    test('Street campaign death triggers for all gauge boundaries', () {
      // Gauge 1 depleted
      final g1Min = GameState(campaign: CampaignType.street, gauge1: 0).checkStatus();
      expect(g1Min.isGameOver, isTrue);
      expect(g1Min.deathReason, GameOverReason.gauge1Depleted);
      expect(g1Min.deathMessage, contains('réputation'));

      // Gauge 1 overflow
      final g1Max = GameState(campaign: CampaignType.street, gauge1: 100).checkStatus();
      expect(g1Max.isGameOver, isTrue);
      expect(g1Max.deathReason, GameOverReason.gauge1Overflow);
      expect(g1Max.deathMessage, contains('notoriété'));

      // Gauge 2 depleted
      final g2Min = GameState(campaign: CampaignType.street, gauge2: -5).checkStatus();
      expect(g2Min.isGameOver, isTrue);
      expect(g2Min.deathReason, GameOverReason.gauge2Depleted);
      expect(g2Min.deathMessage, contains('Banqueroute'));

      // Gauge 2 overflow
      final g2Max = GameState(campaign: CampaignType.street, gauge2: 105).checkStatus();
      expect(g2Max.isGameOver, isTrue);
      expect(g2Max.deathReason, GameOverReason.gauge2Overflow);
      expect(g2Max.deathMessage, contains('fortune colossale'));

      // Gauge 3 depleted
      final g3Min = GameState(campaign: CampaignType.street, gauge3: 0).checkStatus();
      expect(g3Min.isGameOver, isTrue);
      expect(g3Min.deathReason, GameOverReason.gauge3Depleted);
      expect(g3Min.deathMessage, contains('discret'));

      // Gauge 3 overflow
      final g3Max = GameState(campaign: CampaignType.street, gauge3: 100).checkStatus();
      expect(g3Max.isGameOver, isTrue);
      expect(g3Max.deathReason, GameOverReason.gauge3Overflow);
      expect(g3Max.deathMessage, contains('SWAT'));

      // Gauge 4 depleted
      final g4Min = GameState(campaign: CampaignType.street, gauge4: 0).checkStatus();
      expect(g4Min.isGameOver, isTrue);
      expect(g4Min.deathReason, GameOverReason.gauge4Depleted);
      expect(g4Min.deathMessage, contains('Trahison'));

      // Gauge 4 overflow
      final g4Max = GameState(campaign: CampaignType.street, gauge4: 100).checkStatus();
      expect(g4Max.isGameOver, isTrue);
      expect(g4Max.deathReason, GameOverReason.gauge4Overflow);
      expect(g4Max.deathMessage, contains('fanatisme'));
    });

    test('Empire campaign death triggers with royal messages', () {
      final g1Min = GameState(campaign: CampaignType.empire, gauge1: 0).checkStatus();
      expect(g1Min.isGameOver, isTrue);
      expect(g1Min.deathReason, GameOverReason.gauge1Depleted);
      expect(g1Min.deathMessage, contains('Destitution'));

      final g2Min = GameState(campaign: CampaignType.empire, gauge2: 0).checkStatus();
      expect(g2Min.isGameOver, isTrue);
      expect(g2Min.deathReason, GameOverReason.gauge2Depleted);
      expect(g2Min.deathMessage, contains('caisses impériales'));

      final g3Max = GameState(campaign: CampaignType.empire, gauge3: 100).checkStatus();
      expect(g3Max.isGameOver, isTrue);
      expect(g3Max.deathReason, GameOverReason.gauge3Overflow);
      expect(g3Max.deathMessage, contains('junte militaire'));

      final g4Min = GameState(campaign: CampaignType.empire, gauge4: 0).checkStatus();
      expect(g4Min.isGameOver, isTrue);
      expect(g4Min.deathReason, GameOverReason.gauge4Depleted);
      expect(g4Min.deathMessage, contains('Insurrection populaire'));
    });

    test('applyChoice updates gauges, increments day, accumulates flags and checks status', () {
      final initial = GameState.initial(campaign: CampaignType.street);

      const impact = ChoiceImpact(
        text: 'Voler la banque',
        deltaGauge1: 10,
        deltaGauge2: 30,
        deltaGauge3: 20,
        deltaGauge4: -10,
        setFlags: ['heist_completed'],
      );

      final next = initial.applyChoice(impact);
      expect(next.gauge1, 60);
      expect(next.gauge2, 80);
      expect(next.gauge3, 70);
      expect(next.gauge4, 40);
      expect(next.dayCount, 2);
      expect(next.activeFlags, contains('heist_completed'));
      expect(next.isGameOver, isFalse);

      // Lethal swipe
      const fatalImpact = ChoiceImpact(
        text: 'Provoquer les flics',
        deltaGauge3: 40, // 70 + 40 = 110 -> clamped to 100 -> death
      );

      final dead = next.applyChoice(fatalImpact);
      expect(dead.gauge3, 100);
      expect(dead.isGameOver, isTrue);
      expect(dead.deathReason, GameOverReason.gauge3Overflow);
    });

    test('GameState JSON serialization round-trip', () {
      final state = GameState(
        campaign: CampaignType.empire,
        gauge1: 75,
        gauge2: 30,
        gauge3: 45,
        gauge4: 60,
        dayCount: 14,
        activeFlags: {'coronation', 'peace_treaty'},
        isGameOver: false,
      );

      final json = state.toJson();
      final restored = GameState.fromJson(json);

      expect(restored, equals(state));
      expect(restored.campaign, CampaignType.empire);
      expect(restored.activeFlags, contains('peace_treaty'));
    });
  });
}
