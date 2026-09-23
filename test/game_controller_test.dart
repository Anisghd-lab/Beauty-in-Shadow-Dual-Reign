import 'package:flutter_test/flutter_test.dart';
import 'package:beauty_in_shadow/models/card_model.dart';
import 'package:beauty_in_shadow/models/game_state.dart';
import 'package:beauty_in_shadow/providers/game_controller.dart';

void main() {
  // Test fixture helper creating a mock deck
  List<GameCard> createTestDeck() {
    return [
      const GameCard(
        id: 'street_card_1',
        campaign: 'STREET',
        speakerName: 'Raven',
        speakerRole: 'Lieutenante',
        speakerAvatar: 'assets/avatars/raven.png',
        dialogue: 'Un convoi du cartel traverse notre territoire.',
        leftChoice: ChoiceImpact(
          text: 'Attaquer',
          deltaGauge1: 15,
          deltaGauge2: 25,
          deltaGauge3: 20,
          deltaGauge4: -10,
          setFlags: ['convoi_pille'],
          nextCardId: 'street_chained',
        ),
        rightChoice: ChoiceImpact(
          text: 'Laisser passer',
          deltaGauge1: -10,
          deltaGauge2: -5,
          deltaGauge3: -15,
          deltaGauge4: 5,
        ),
      ),
      const GameCard(
        id: 'street_chained',
        campaign: 'STREET',
        speakerName: 'Boss Marcus',
        speakerRole: 'Parrain',
        speakerAvatar: 'assets/avatars/marcus.png',
        dialogue: 'Vous avez osé toucher au convoi !',
        leftChoice: ChoiceImpact(
          text: 'Assumer',
          deltaGauge1: 20,
          deltaGauge3: 40,
        ),
        rightChoice: ChoiceImpact(
          text: 'Négocier',
          deltaGauge2: -30,
          deltaGauge3: -10,
        ),
        requiredFlags: ['convoi_pille'],
      ),
      const GameCard(
        id: 'street_forbidden_card',
        campaign: 'STREET',
        speakerName: 'Infiltré',
        speakerRole: 'Taupe',
        speakerAvatar: 'assets/avatars/mole.png',
        dialogue: 'Je peux effacer vos traces.',
        leftChoice: ChoiceImpact(text: 'Payer', deltaGauge2: -20),
        rightChoice: ChoiceImpact(text: 'Refuser'),
        forbiddenFlags: ['convoi_pille'],
      ),
      const GameCard(
        id: 'empire_card_1',
        campaign: 'EMPIRE',
        speakerName: 'Général Kael',
        speakerRole: 'Commandant',
        speakerAvatar: 'assets/avatars/kael.png',
        dialogue: 'Les légions réclament une augmentation de solde.',
        leftChoice: ChoiceImpact(
          text: 'Augmenter la solde',
          deltaGauge2: -25,
          deltaGauge3: 30,
        ),
        rightChoice: ChoiceImpact(
          text: 'Refuser',
          deltaGauge3: -35,
          deltaGauge4: -15,
        ),
      ),
    ];
  }

  group('GameController - Initialization & State Orchestration', () {
    test('Initializes with default state, deck, and automatically draws first card', () {
      final deck = createTestDeck();
      final controller = GameController(deck: deck);

      expect(controller.state.campaign, CampaignType.street);
      expect(controller.state.gauge1, 50);
      expect(controller.state.gauge2, 50);
      expect(controller.state.gauge3, 50);
      expect(controller.state.gauge4, 50);
      expect(controller.state.dayCount, 1);
      expect(controller.state.activeFlags, isEmpty);
      expect(controller.isGameOver, isFalse);
      expect(controller.swipePreview, SwipeDirection.none);
      expect(controller.currentCard, isNotNull);
      expect(controller.currentCard!.campaign, 'STREET');
    });

    test('Swipe preview updates direction and provides HUD feedback calculation', () {
      final deck = createTestDeck();
      final controller = GameController(deck: deck);

      // Force drawing street_card_1 for deterministic impact testing
      controller.drawNextCard(forceCardId: 'street_card_1');
      expect(controller.currentCard!.id, 'street_card_1');

      // Default preview is none
      expect(controller.swipePreview, SwipeDirection.none);
      expect(controller.activeChoiceImpact, isNull);
      expect(controller.getPreviewDelta(1), 0);
      expect(controller.getPreviewGauge(1), 50);

      // Dragging towards left choice: deltaGauge1 is +15, deltaGauge4 is -10
      controller.setSwipePreview(SwipeDirection.left);
      expect(controller.swipePreview, SwipeDirection.left);
      expect(controller.activeChoiceImpact, isNotNull);
      expect(controller.activeChoiceImpact!.text, 'Attaquer');
      expect(controller.getPreviewDelta(1), 15);
      expect(controller.getPreviewGauge(1), 65); // 50 + 15
      expect(controller.getPreviewDelta(4), -10);
      expect(controller.getPreviewGauge(4), 40); // 50 - 10

      // Dragging towards right choice: deltaGauge1 is -10
      controller.setSwipePreview(SwipeDirection.right);
      expect(controller.swipePreview, SwipeDirection.right);
      expect(controller.activeChoiceImpact!.text, 'Laisser passer');
      expect(controller.getPreviewDelta(1), -10);
      expect(controller.getPreviewGauge(1), 40);

      // Reset preview
      controller.resetSwipePreview();
      expect(controller.swipePreview, SwipeDirection.none);
      expect(controller.activeChoiceImpact, isNull);
    });
  });

  group('GameController - Card Drawing & Flag Filtering', () {
    test('Filters cards by campaign and flag matching', () {
      final deck = createTestDeck();
      final controller = GameController(deck: deck);

      // Without flag 'convoi_pille', 'street_chained' cannot be drawn
      // but 'street_forbidden_card' and 'street_card_1' can be drawn
      for (int i = 0; i < 10; i++) {
        controller.drawNextCard();
        expect(controller.currentCard!.id, isNot('street_chained'));
        expect(controller.currentCard!.campaign, 'STREET');
      }

      // Add flag 'convoi_pille'
      controller.state.activeFlags.add('convoi_pille');

      // Now 'street_forbidden_card' cannot be drawn
      for (int i = 0; i < 10; i++) {
        controller.drawNextCard();
        expect(controller.currentCard!.id, isNot('street_forbidden_card'));
      }
    });

    test('drawNextCard with forceCardId draws the exact requested card', () {
      final deck = createTestDeck();
      final controller = GameController(deck: deck);

      controller.drawNextCard(forceCardId: 'street_chained');
      expect(controller.currentCard!.id, 'street_chained');
      expect(controller.currentCard!.speakerName, 'Boss Marcus');
    });
  });

  group('GameController - Choice Execution & Clamping', () {
    test('Executing choice applies deltas, updates flags, advances days and chains cards', () {
      final deck = createTestDeck();
      final controller = GameController(deck: deck);

      controller.drawNextCard(forceCardId: 'street_card_1');

      // Left choice: deltaGauge1: +15, deltaGauge2: +25, deltaGauge3: +20, deltaGauge4: -10
      // setFlags: ['convoi_pille'], nextCardId: 'street_chained'
      controller.onChoiceSelected(false); // left choice

      expect(controller.state.gauge1, 65);
      expect(controller.state.gauge2, 75);
      expect(controller.state.gauge3, 70);
      expect(controller.state.gauge4, 40);
      expect(controller.state.dayCount, 2);
      expect(controller.state.activeFlags, contains('convoi_pille'));
      expect(controller.isGameOver, isFalse);

      // Chaining check: should have drawn street_chained!
      expect(controller.currentCard!.id, 'street_chained');
    });

    test('Gauges are clamped between 0 and 100 on extreme impacts', () {
      final deck = createTestDeck();
      final controller = GameController(deck: deck);

      controller.state.gauge1 = 90;
      controller.drawNextCard(forceCardId: 'street_card_1');

      // street_card_1 left has deltaGauge1 = +15 -> 90 + 15 = 105 -> clamped to 100
      controller.onChoiceSelected(false);

      expect(controller.state.gauge1, 100);
      // Reaching 100 triggers game over (overflow)
      expect(controller.isGameOver, isTrue);
      expect(controller.state.deathReason, GameOverReason.gauge1Overflow);
    });

    test('Triggering death stops card drawing and sets death message', () {
      final deck = createTestDeck();
      final controller = GameController(
        initialState: GameState(
          campaign: CampaignType.street,
          gauge3: 90, // Heat is high
        ),
        deck: deck,
      );

      controller.drawNextCard(forceCardId: 'street_chained');

      // street_chained left choice: deltaGauge3 = +40 -> 90 + 40 = 130 -> 100 (SWAT assault)
      controller.onChoiceSelected(false);

      expect(controller.isGameOver, isTrue);
      expect(controller.state.gauge3, 100);
      expect(controller.state.deathReason, GameOverReason.gauge3Overflow);
      expect(controller.state.deathMessage, contains('SWAT'));

      final lastCard = controller.currentCard;

      // Further calls to onChoiceSelected should be ignored
      controller.onChoiceSelected(true);
      expect(controller.currentCard, equals(lastCard));
    });
  });

  group('GameController - Session Lifecycle', () {
    test('restart resets gauges, dayCount, flags and changes campaign', () {
      final deck = createTestDeck();
      final controller = GameController(deck: deck);

      // Play a few turns and mutate state
      controller.state.gauge1 = 20;
      controller.state.gauge2 = 95;
      controller.state.dayCount = 12;
      controller.state.activeFlags.add('some_flag');
      controller.state.isGameOver = true;

      // Restart in Empire campaign
      controller.restart(CampaignType.empire);

      expect(controller.state.campaign, CampaignType.empire);
      expect(controller.state.gauge1, 50);
      expect(controller.state.gauge2, 50);
      expect(controller.state.gauge3, 50);
      expect(controller.state.gauge4, 50);
      expect(controller.state.dayCount, 1);
      expect(controller.state.activeFlags, isEmpty);
      expect(controller.isGameOver, isFalse);
      expect(controller.currentCard, isNotNull);
      expect(controller.currentCard!.campaign, 'EMPIRE');
      expect(controller.currentCard!.id, 'empire_card_1');
    });
  });
}
