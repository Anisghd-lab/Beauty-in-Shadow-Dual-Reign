import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beauty_in_shadow/core/services/storage_service.dart';
import 'package:beauty_in_shadow/models/game_state.dart';
import 'package:beauty_in_shadow/ui/screens/game_over_screen.dart';
import 'package:beauty_in_shadow/ui/screens/game_screen.dart';
import 'package:beauty_in_shadow/ui/screens/menu_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('MenuScreen Widget Tests', () {
    testWidgets('Renders Street & Empire options, badges, titles, descriptions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MenuScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Street Campaign Elements
      expect(find.text('LA RUE & LA NUIT'), findsOneWidget);
      expect(find.text('Kimmie — Survie Urbaine'), findsOneWidget);
      expect(find.text('4 Jauges : Dignité, Cash, Réputation, Discrétion.'),
          findsOneWidget);
      expect(find.text('INFILTRER LES BAS-FONDS'), findsOneWidget);

      // Empire Campaign Elements
      expect(find.text('L\'EMPIRE BELL'), findsOneWidget);
      expect(find.text('Mallory Bell — Dynastie & Crime'), findsOneWidget);
      expect(find.text('4 Jauges : Prestige, Blanchiment, Impunité, Clan.'),
          findsOneWidget);
      expect(find.text('PRENDRE LE CONTRÔLE'), findsOneWidget);

      // Center Crest
      expect(find.text('BEAUTY IN SHADOW: DUAL REIGN'), findsOneWidget);

      // Default Record Badges
      expect(find.text('RECORD : 0 JOURS'), findsNWidgets(2));
    });

    testWidgets('Displays persisted records correctly from StorageService',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'bis_best_days_street': 14,
        'bis_best_days_empire': 28,
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: MenuScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('RECORD : 14 JOURS'), findsOneWidget);
      expect(find.text('RECORD : 28 JOURS'), findsOneWidget);
    });

    testWidgets('Tapping Street campaign navigates to GameScreen in Street mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MenuScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Street Campaign
      await tester.tap(find.byKey(const ValueKey('campaign_street')));
      await tester.pumpAndSettle();

      // Should be in GameScreen with Street campaign status pill
      expect(find.byType(GameScreen), findsOneWidget);
      expect(find.textContaining('CAMPAGNE DE LA RUE'), findsOneWidget);
    });

    testWidgets('Tapping Empire campaign navigates to GameScreen in Empire mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MenuScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Empire Campaign
      await tester.tap(find.byKey(const ValueKey('campaign_empire')));
      await tester.pumpAndSettle();

      // Should be in GameScreen with Empire campaign status pill
      expect(find.byType(GameScreen), findsOneWidget);
      expect(find.textContaining('CAMPAGNE DE L\'EMPIRE'), findsOneWidget);
    });

    testWidgets('GameOverScreen renders return to menu button and saves record',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      bool returnedToMenu = false;

      final gameOverState = GameState(
        campaign: CampaignType.street,
        dayCount: 19,
        isGameOver: true,
        deathReason: GameOverReason.gauge1Depleted,
        deathMessage: 'Votre volonté s\'est éteinte.',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: GameOverScreen(
            state: gameOverState,
            onReturnToMenu: () => returnedToMenu = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check button existence
      expect(find.byKey(const ValueKey('btn_return_menu')), findsOneWidget);
      expect(find.text('RETOUR AU MENU PRINCIPAL'), findsOneWidget);

      // Verify record was saved
      final bestDays =
          await StorageService.instance.getBestDays(CampaignType.street);
      expect(bestDays, 19);

      // Tap Return to Menu
      await tester.tap(find.byKey(const ValueKey('btn_return_menu')));
      await tester.pumpAndSettle();

      expect(returnedToMenu, isTrue);
    });
  });
}
