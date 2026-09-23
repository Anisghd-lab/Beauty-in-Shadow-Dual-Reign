import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:beauty_in_shadow/models/card_model.dart';
import 'package:beauty_in_shadow/models/game_state.dart';
import 'package:beauty_in_shadow/providers/game_controller.dart';
import 'package:beauty_in_shadow/ui/screens/game_screen.dart';

void main() {
  Widget buildGameScreen(GameController controller) {
    return MaterialApp(
      home: ChangeNotifierProvider<GameController>.value(
        value: controller,
        child: const GameScreen(),
      ),
    );
  }

  const testCardA = GameCard(
    id: 'test_card_A',
    campaign: 'STREET',
    speakerName: 'Raven Test',
    speakerRole: 'Lieutenante',
    speakerAvatar: 'assets/test_avatar.png',
    dialogue: 'Le cartel nous attend au tournant.',
    leftChoice: ChoiceImpact(
      text: 'Riposter',
      deltaGauge1: 15,
      deltaGauge2: -10,
    ),
    rightChoice: ChoiceImpact(
      text: 'Négocier',
      deltaGauge1: -20,
      deltaGauge2: 20,
    ),
  );

  const testCardB = GameCard(
    id: 'test_card_B',
    campaign: 'STREET',
    speakerName: 'Boss Test',
    speakerRole: 'Parrain',
    speakerAvatar: 'assets/boss.png',
    dialogue: 'Vous avez fait le bon choix.',
    leftChoice: ChoiceImpact(text: 'Option 1'),
    rightChoice: ChoiceImpact(text: 'Option 2'),
  );

  group('GameScreen Widget Tests', () {
    testWidgets('Swipe card displays correct speaker name, role, and dialogue',
        (tester) async {
      final controller = GameController(
        initialState: GameState(
          campaign: CampaignType.street,
          dayCount: 3,
        ),
        deck: [testCardA],
      );

      await tester.pumpWidget(buildGameScreen(controller));
      await tester.pumpAndSettle();

      // Check Sub-header status pill
      expect(find.text('JOUR 3 — CAMPAGNE DE LA RUE'), findsOneWidget);

      // Check card content
      expect(find.text('RAVEN TEST'), findsOneWidget);
      expect(find.text('Lieutenante'), findsOneWidget);
      expect(find.text('Le cartel nous attend au tournant.'), findsOneWidget);

      // Check fallback buttons
      expect(find.text('Riposter'), findsOneWidget);
      expect(find.text('Négocier'), findsOneWidget);
    });

    testWidgets('Tapping tactile choice buttons dispatches actions to GameController',
        (tester) async {
      final controller = GameController(
        initialState: GameState(
          campaign: CampaignType.street,
          gauge1: 50,
          gauge2: 50,
          dayCount: 1,
        ),
        deck: [testCardA, testCardB],
      );
      controller.drawNextCard(forceCardId: 'test_card_A');

      await tester.pumpWidget(buildGameScreen(controller));
      await tester.pumpAndSettle();

      expect(controller.state.dayCount, 1);
      expect(controller.state.gauge1, 50);
      expect(controller.state.gauge2, 50);

      // Tap left tactile button: 'Riposter' (deltaGauge1: +15, deltaGauge2: -10)
      await tester.tap(find.byKey(const ValueKey('btn_choice_left')));
      await tester.pumpAndSettle();

      expect(controller.state.gauge1, 65);
      expect(controller.state.gauge2, 40);
      expect(controller.state.dayCount, 2);
    });

    testWidgets('Game Over screen renders seamlessly when state.isGameOver becomes true',
        (tester) async {
      final controller = GameController(
        initialState: GameState(
          campaign: CampaignType.street,
          gauge1: 10, // Close to depletion
          dayCount: 5,
        ),
        deck: [testCardA],
      );

      await tester.pumpWidget(buildGameScreen(controller));
      await tester.pumpAndSettle();

      // Tap right button ('Négocier': deltaGauge1: -20 -> 10 - 20 = -10 -> 0 -> Game Over)
      await tester.tap(find.byKey(const ValueKey('btn_choice_right')));
      await tester.pumpAndSettle();

      // Verify Game Over screen appears
      expect(controller.isGameOver, isTrue);
      expect(find.text('RÈGNE BRISÉ'), findsOneWidget);
      expect(find.text('JOURS SURVÉCUS : 6'), findsOneWidget);
      expect(find.byKey(const ValueKey('btn_restart_same')), findsOneWidget);
      expect(find.byKey(const ValueKey('btn_switch_campaign')), findsOneWidget);

      // Tap restart same campaign button
      await tester.tap(find.byKey(const ValueKey('btn_restart_same')));
      await tester.pumpAndSettle();

      // Should be back to active game screen
      expect(controller.isGameOver, isFalse);
      expect(controller.state.dayCount, 1);
      expect(controller.state.gauge1, 50);
      expect(find.text('JOUR 1 — CAMPAGNE DE LA RUE'), findsOneWidget);
    });
  });
}
