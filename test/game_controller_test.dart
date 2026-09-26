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

    test('Progression engine respects chapter day thresholds and extracts card numbers', () {
      expect(GameController.extractCardNumber('ST_001'), 1);
      expect(GameController.extractCardNumber('ST_015'), 15);
      expect(GameController.extractCardNumber('EM_035'), 35);
      expect(GameController.extractCardNumber('street_card_4'), 4);
      expect(GameController.extractCardNumber('non_numeric_card'), isNull);

      expect(GameController.maxCardIndexForDay(1), 10);
      expect(GameController.maxCardIndexForDay(5), 10);
      expect(GameController.maxCardIndexForDay(6), 20);
      expect(GameController.maxCardIndexForDay(12), 20);
      expect(GameController.maxCardIndexForDay(13), 30);
      expect(GameController.maxCardIndexForDay(22), 30);
      expect(GameController.maxCardIndexForDay(23), 40);
      expect(GameController.maxCardIndexForDay(35), 40);
      expect(GameController.maxCardIndexForDay(36), 50);
      expect(GameController.maxCardIndexForDay(100), 50);
    });

    test('drawNextCard filters out late-chapter cards during early game (Days 1-5)', () {
      final tieredDeck = [
        const GameCard(
          id: 'ST_005',
          campaign: 'STREET',
          speakerName: 'Ch1 Contact',
          speakerRole: 'Underworld',
          speakerAvatar: 'assets/avatars/c1.png',
          dialogue: 'Chapter 1 card',
          leftChoice: ChoiceImpact(text: 'Option A'),
          rightChoice: ChoiceImpact(text: 'Option B'),
        ),
        const GameCard(
          id: 'ST_025',
          campaign: 'STREET',
          speakerName: 'Ch3 Contact',
          speakerRole: 'Underworld',
          speakerAvatar: 'assets/avatars/c3.png',
          dialogue: 'Chapter 3 card',
          leftChoice: ChoiceImpact(text: 'Option A'),
          rightChoice: ChoiceImpact(text: 'Option B'),
        ),
      ];

      final controller = GameController(
        deck: tieredDeck,
        initialState: GameState(campaign: CampaignType.street, dayCount: 1),
      );

      // On Day 1, only ST_005 (Ch 1) should be drawn, not ST_025 (Ch 3)
      for (int i = 0; i < 5; i++) {
        controller.drawNextCard();
        expect(controller.currentCard!.id, 'ST_005');
      }

      // On Day 15 (Crisis phase, Ch 3 unlocked <= 30), ST_025 is eligible
      controller.state.dayCount = 15;
      final drawnIds = <String>{};
      for (int i = 0; i < 15; i++) {
        controller.drawNextCard();
        drawnIds.add(controller.currentCard!.id);
      }
      expect(drawnIds, contains('ST_025'));
    });

    test('Dynamic Lifeline heuristic prioritizes counter-balancing cards when gauge is in danger', () {
      final rescueDeck = [
        const GameCard(
          id: 'ST_002',
          campaign: 'STREET',
          speakerName: 'Neutral Contact',
          speakerRole: 'Civilian',
          speakerAvatar: 'assets/avatars/neutral.png',
          dialogue: 'Ordinary situation',
          leftChoice: ChoiceImpact(text: 'Left', deltaGauge1: 5, deltaGauge2: -10),
          rightChoice: ChoiceImpact(text: 'Right', deltaGauge1: -5, deltaGauge2: -10),
        ),
        const GameCard(
          id: 'ST_003',
          campaign: 'STREET',
          speakerName: 'Lifeline Donor',
          speakerRole: 'Patron',
          speakerAvatar: 'assets/avatars/donor.png',
          dialogue: 'Here is some emergency cash!',
          leftChoice: ChoiceImpact(text: 'Take Cash', deltaGauge2: 15),
          rightChoice: ChoiceImpact(text: 'Decline', deltaGauge2: 10),
        ),
      ];

      final controller = GameController(
        deck: rescueDeck,
        initialState: GameState(
          campaign: CampaignType.street,
          gauge2: 15, // Cash is critically low (<= 20)
        ),
      );

      expect(GameController.isStateInDanger(controller.state), isTrue);

      // Card draw should prioritize ST_003 as a lifeline because it restores Gauge 2
      for (int i = 0; i < 5; i++) {
        controller.drawNextCard();
        expect(controller.currentCard!.id, 'ST_003');
      }
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

    test('Initializes with default protagonist and advances generational succession on restart', () {
      final deck = createTestDeck();
      final controller = GameController(deck: deck);

      // Street default protagonist: Kimmie, Reign #1
      expect(controller.protagonist.name, 'Kimmie');
      expect(controller.protagonist.reignNumber, 1);
      expect(controller.protagonist.title, 'Danseuse en Cavale');
      expect(controller.state.nextSuccessorName, 'Lexie');

      // Restart in same campaign -> Succession to Lexie (Reign #2)
      controller.restart(CampaignType.street);

      expect(controller.protagonist.name, 'Lexie');
      expect(controller.protagonist.reignNumber, 2);
      expect(controller.state.nextSuccessorName, 'Raven');

      // Restart again -> Succession to Raven (Reign #3)
      controller.restart(CampaignType.street);

      expect(controller.protagonist.name, 'Raven');
      expect(controller.protagonist.reignNumber, 3);
      expect(controller.state.nextSuccessorName, 'Skye');

      // Restart again -> Succession to Skye (Reign #4)
      controller.restart(CampaignType.street);

      expect(controller.protagonist.name, 'Skye');
      expect(controller.protagonist.reignNumber, 4);
      expect(controller.state.nextSuccessorName, 'Maya');
    });

    test('Empire campaign initializes with Mallory Bell and cycles through aristocratic dynasty', () {
      final deck = createTestDeck();
      final controller = GameController(
        initialState: GameState.initial(campaign: CampaignType.empire),
        deck: deck,
      );

      // Empire default protagonist: Mallory Bell, Reign #1
      expect(controller.protagonist.name, 'Mallory Bell');
      expect(controller.protagonist.reignNumber, 1);
      expect(controller.protagonist.title, 'Héritière Contestée');
      expect(controller.state.nextSuccessorName, 'Victoria Bell');

      // Restart Empire -> Succession to Victoria Bell (Reign #2)
      controller.restart(CampaignType.empire);

      expect(controller.protagonist.name, 'Victoria Bell');
      expect(controller.protagonist.reignNumber, 2);
      expect(controller.state.nextSuccessorName, 'Cassandra Bell');
    });
  });
}
