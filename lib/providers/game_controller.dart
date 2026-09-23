import 'dart:math';
import 'package:flutter/foundation.dart';
import '../core/services/audio_service.dart';
import '../models/card_model.dart';
import '../models/game_state.dart';

/// Real-time swipe gesture preview for HUD feedback.
enum SwipeDirection {
  /// Card is centered; no choice is currently being previewed.
  none,

  /// Card is being dragged towards the left choice.
  left,

  /// Card is being dragged towards the right choice.
  right;

  /// Whether any choice is currently being previewed.
  bool get isPreviewing => this != SwipeDirection.none;
}

/// The reactive game engine managing Reigns-style state, decks, swipe choices and lifecycles.
class GameController extends ChangeNotifier {
  GameState _state;
  List<GameCard> _deck;
  GameCard? _currentCard;
  SwipeDirection _swipePreview;
  final Random _random;

  GameController({
    GameState? initialState,
    List<GameCard> deck = const <GameCard>[],
    Random? random,
    bool autoDrawInitialCard = true,
  })  : _state = initialState ?? GameState.initial(),
        _deck = List<GameCard>.from(deck),
        _swipePreview = SwipeDirection.none,
        _random = random ?? Random() {
    if (autoDrawInitialCard && _deck.isNotEmpty && _currentCard == null) {
      drawNextCard();
    }
  }

  // ==========================================
  // Getters
  // ==========================================

  /// Current game state (gauges, day count, flags, game over status).
  GameState get state => _state;

  /// Immutable snapshot of the registered cards in the deck.
  List<GameCard> get deck => List.unmodifiable(_deck);

  /// The active card currently presented to the player.
  GameCard? get currentCard => _currentCard;

  /// Current swipe preview direction (left, right, or none).
  SwipeDirection get swipePreview => _swipePreview;

  /// Whether the current run has reached a terminal game-over condition.
  bool get isGameOver => _state.isGameOver;

  /// The active campaign mode (street or empire).
  CampaignType get campaign => _state.campaign;

  /// Number of days survived.
  int get dayCount => _state.dayCount;

  /// Currently unlocked flags.
  Set<String> get activeFlags => _state.activeFlags;

  /// The choice impact currently being previewed during a drag gesture, if any.
  ChoiceImpact? get activeChoiceImpact {
    if (_currentCard == null) return null;
    switch (_swipePreview) {
      case SwipeDirection.left:
        return _currentCard!.leftChoice;
      case SwipeDirection.right:
        return _currentCard!.rightChoice;
      case SwipeDirection.none:
        return null;
    }
  }

  /// Calculates the projected value of a gauge (1..4) based on the active swipe preview.
  int getPreviewGauge(int gaugeIndex) {
    final current = _state.getGauge(gaugeIndex);
    final impact = activeChoiceImpact;
    if (impact == null) return current;

    int delta = 0;
    switch (gaugeIndex) {
      case 1:
        delta = impact.deltaGauge1;
        break;
      case 2:
        delta = impact.deltaGauge2;
        break;
      case 3:
        delta = impact.deltaGauge3;
        break;
      case 4:
        delta = impact.deltaGauge4;
        break;
      default:
        return current;
    }

    return (current + delta).clamp(GameState.minGaugeValue, GameState.maxGaugeValue);
  }

  /// Returns the delta applied to a gauge (1..4) under the current swipe preview.
  int getPreviewDelta(int gaugeIndex) {
    final impact = activeChoiceImpact;
    if (impact == null) return 0;
    switch (gaugeIndex) {
      case 1:
        return impact.deltaGauge1;
      case 2:
        return impact.deltaGauge2;
      case 3:
        return impact.deltaGauge3;
      case 4:
        return impact.deltaGauge4;
      default:
        return 0;
    }
  }

  // ==========================================
  // Preview State Management
  // ==========================================

  /// Updates the real-time swipe preview direction to feed HUD gauge indicators.
  void setSwipePreview(SwipeDirection direction) {
    if (_swipePreview == direction) return;
    _swipePreview = direction;
    notifyListeners();
  }

  /// Clears the real-time swipe preview.
  void resetSwipePreview() {
    setSwipePreview(SwipeDirection.none);
  }

  // ==========================================
  // Deck Management & Card Drawing
  // ==========================================

  /// Replaces the current card deck and optionally draws the first eligible card.
  void setDeck(List<GameCard> newDeck, {bool drawFirst = true}) {
    _deck = List<GameCard>.from(newDeck);
    if (drawFirst && !_state.isGameOver) {
      drawNextCard();
    } else {
      notifyListeners();
    }
  }

  /// Draws the next card to present to the player.
  ///
  /// If [forceCardId] is specified, attempts to find and draw that exact card.
  /// Otherwise, filters deck cards by:
  /// 1. Campaign match ([GameCard.campaign] == current campaign key).
  /// 2. Flag eligibility ([GameCard.requiredFlags] present, [GameCard.forbiddenFlags] absent).
  /// Then randomly selects from eligible cards.
  void drawNextCard({String? forceCardId}) {
    _swipePreview = SwipeDirection.none;

    if (_deck.isEmpty) {
      _currentCard = null;
      notifyListeners();
      return;
    }

    // 1. Forced card branching (narrative chaining)
    if (forceCardId != null && forceCardId.isNotEmpty) {
      final forcedMatch = _deck.where((c) => c.id == forceCardId).toList();
      if (forcedMatch.isNotEmpty) {
        _currentCard = forcedMatch.first;
        notifyListeners();
        return;
      }
    }

    // 2. Filter by campaign and active flags
    final targetCampaignKey = _state.campaign.key;
    final eligible = _deck.where((card) {
      final matchesCampaign = card.campaign.toUpperCase() == targetCampaignKey;
      return matchesCampaign && card.isEligible(_state.activeFlags);
    }).toList();

    if (eligible.isEmpty) {
      // Secondary fallback: any card in current campaign ignoring optional flags
      final campaignFallback = _deck.where((card) {
        return card.campaign.toUpperCase() == targetCampaignKey;
      }).toList();

      if (campaignFallback.isNotEmpty) {
        _currentCard = campaignFallback[_random.nextInt(campaignFallback.length)];
      } else {
        _currentCard = null;
      }
      notifyListeners();
      return;
    }

    // Avoid immediately repeating the exact same card if alternatives exist
    if (eligible.length > 1 && _currentCard != null) {
      final nonRepeating = eligible.where((c) => c.id != _currentCard!.id).toList();
      if (nonRepeating.isNotEmpty) {
        _currentCard = nonRepeating[_random.nextInt(nonRepeating.length)];
        notifyListeners();
        return;
      }
    }

    _currentCard = eligible[_random.nextInt(eligible.length)];
    notifyListeners();
  }

  // ==========================================
  // Choice Execution
  // ==========================================

  /// Executes the consequences of the player's swipe choice.
  ///
  /// [isRight] == true selects [GameCard.rightChoice], false selects [GameCard.leftChoice].
  /// Clamps all gauges between 0 and 100, updates story flags, increments day count,
  /// and evaluates death via [GameState.checkStatus].
  ///
  /// If the player survives, draws the next card (or chains to [ChoiceImpact.nextCardId]).
  void onChoiceSelected(bool isRight) {
    if (_state.isGameOver || _currentCard == null) return;

    final impact = isRight ? _currentCard!.rightChoice : _currentCard!.leftChoice;
    AudioService.instance.playSwipeSfx(isRight);

    // Apply gauge modifications with strict [0, 100] clamping
    _state.gauge1 = (_state.gauge1 + impact.deltaGauge1)
        .clamp(GameState.minGaugeValue, GameState.maxGaugeValue);
    _state.gauge2 = (_state.gauge2 + impact.deltaGauge2)
        .clamp(GameState.minGaugeValue, GameState.maxGaugeValue);
    _state.gauge3 = (_state.gauge3 + impact.deltaGauge3)
        .clamp(GameState.minGaugeValue, GameState.maxGaugeValue);
    _state.gauge4 = (_state.gauge4 + impact.deltaGauge4)
        .clamp(GameState.minGaugeValue, GameState.maxGaugeValue);

    // Accumulate story flags
    if (impact.setFlags.isNotEmpty) {
      _state.activeFlags.addAll(impact.setFlags);
    }

    // Advance turn
    _state.dayCount += 1;

    // Reset preview
    _swipePreview = SwipeDirection.none;

    // Evaluate terminal boundaries
    _state.checkStatus();

    if (_state.isGameOver) {
      AudioService.instance.playGameOverSfx();
      notifyListeners();
    } else {
      if (_state.gauge1 <= 20 ||
          _state.gauge2 <= 20 ||
          _state.gauge3 <= 20 ||
          _state.gauge4 <= 20) {
        AudioService.instance.playWarningSfx();
      }
      drawNextCard(forceCardId: impact.nextCardId);
    }
  }

  // ==========================================
  // Session Lifecycle
  // ==========================================

  /// Restarts the playthrough with a clean slate for the specified [campaign].
  ///
  /// Resets gauges to 50, clears active flags, resets day count to 1,
  /// and draws a fresh starting card.
  void restart(CampaignType campaign) {
    _state = GameState.initial(campaign: campaign);
    _swipePreview = SwipeDirection.none;
    drawNextCard();
    notifyListeners();
  }
}
