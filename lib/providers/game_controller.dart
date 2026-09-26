import 'dart:math';
import 'package:flutter/foundation.dart';
import '../core/services/audio_service.dart';
import '../core/services/codex_service.dart';
import '../models/card_model.dart';
import '../models/game_state.dart';
import '../models/protagonist_model.dart';

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

  /// Active protagonist representing the player avatar and generational dynasty.
  Protagonist get protagonist => _state.protagonist;

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

  /// Extracts the numeric index from a card ID (e.g. "ST_005" -> 5, "EM_023" -> 23).
  /// Returns null if the card ID does not contain a numeric suffix.
  static int? extractCardNumber(String cardId) {
    final match = RegExp(r'(?:ST_|EM_)(\d+)', caseSensitive: false).firstMatch(cardId);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    final genericMatch = RegExp(r'(\d+)').firstMatch(cardId);
    if (genericMatch != null) {
      return int.tryParse(genericMatch.group(1)!);
    }
    return null;
  }

  /// Returns the maximum card index accessible for the given survival [day].
  ///
  /// Chapter Progression Gates:
  /// - Days 1 to 5 (Early Game): Chapter 1 introductory cards (IDs 001 to 010).
  /// - Days 6 to 12 (Mid Game): Unlocks Chapter 2 cards (IDs 011 to 020).
  /// - Days 13 to 22 (Crisis Phase): Unlocks Chapter 3 cards (IDs 021 to 030).
  /// - Days 23 to 35 (Climax Phase): Unlocks Chapter 4 cards (IDs 031 to 040).
  /// - Days 36+ (Endgame / Apex): Full deck unlocked (IDs 001 to 050).
  static int maxCardIndexForDay(int day) {
    if (day <= 5) return 10;
    if (day <= 12) return 20;
    if (day <= 22) return 30;
    if (day <= 35) return 40;
    return 50;
  }

  /// Checks whether any gauge is currently within the critical danger zone (<= 20 or >= 80).
  static bool isStateInDanger(GameState state) {
    return state.gauge1 <= 20 ||
        state.gauge1 >= 80 ||
        state.gauge2 <= 20 ||
        state.gauge2 >= 80 ||
        state.gauge3 <= 20 ||
        state.gauge3 >= 80 ||
        state.gauge4 <= 20 ||
        state.gauge4 >= 80;
  }

  /// Evaluates whether a [choice] acts as a lifeline for any gauge currently in danger.
  ///
  /// Returns a positive recovery score if the choice helps counter-balance endangered gauges
  /// without triggering immediate lethal boundary breaches (<= 0 or >= 100) on any gauge.
  static int evaluateChoiceRescueScore(ChoiceImpact choice, GameState state) {
    final postG1 = state.gauge1 + choice.deltaGauge1;
    final postG2 = state.gauge2 + choice.deltaGauge2;
    final postG3 = state.gauge3 + choice.deltaGauge3;
    final postG4 = state.gauge4 + choice.deltaGauge4;

    // Reject choices that lead to immediate death on any gauge
    if (postG1 <= GameState.minGaugeValue || postG1 >= GameState.maxGaugeValue) return -999999;
    if (postG2 <= GameState.minGaugeValue || postG2 >= GameState.maxGaugeValue) return -999999;
    if (postG3 <= GameState.minGaugeValue || postG3 >= GameState.maxGaugeValue) return -999999;
    if (postG4 <= GameState.minGaugeValue || postG4 >= GameState.maxGaugeValue) return -999999;

    int score = 0;
    int helpedGauges = 0;

    void scoreGauge(int current, int delta) {
      if (current <= 20) {
        if (delta > 0) {
          score += delta;
          helpedGauges++;
        } else if (delta < 0) {
          score += delta * 2; // Penalize worsening depleted gauge heavily
        }
      } else if (current >= 80) {
        if (delta < 0) {
          score += -delta;
          helpedGauges++;
        } else if (delta > 0) {
          score -= delta * 2; // Penalize worsening overflowing gauge heavily
        }
      }
    }

    scoreGauge(state.gauge1, choice.deltaGauge1);
    scoreGauge(state.gauge2, choice.deltaGauge2);
    scoreGauge(state.gauge3, choice.deltaGauge3);
    scoreGauge(state.gauge4, choice.deltaGauge4);

    return (helpedGauges > 0 && score > 0) ? score : 0;
  }

  /// Whether [card] offers at least one rescue option for the current [state].
  static bool isRescueCard(GameCard card, GameState state) {
    return evaluateChoiceRescueScore(card.leftChoice, state) > 0 ||
        evaluateChoiceRescueScore(card.rightChoice, state) > 0;
  }

  /// Draws the next card to present to the player.
  ///
  /// If [forceCardId] is specified, attempts to find and draw that exact card.
  /// Otherwise, filters deck cards by:
  /// 1. Campaign match ([GameCard.campaign] == current campaign key).
  /// 2. Flag eligibility ([GameCard.requiredFlags] present, [GameCard.forbiddenFlags] absent).
  /// 3. Chapter-gated day progression thresholds.
  /// 4. Dynamic Lifeline / Rescue heuristic when gauges are in critical danger.
  /// 5. Non-repeating card draw.
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

    // 3. Chapter-gated progression filter
    final maxIndex = maxCardIndexForDay(_state.dayCount);
    final chapterFiltered = eligible.where((card) {
      final num = extractCardNumber(card.id);
      return num == null || num <= maxIndex;
    }).toList();

    var candidates = chapterFiltered.isNotEmpty ? chapterFiltered : eligible;

    // 4. Dynamic Lifeline / Rescue Heuristic
    if (isStateInDanger(_state)) {
      final rescueCandidates = candidates.where((c) => isRescueCard(c, _state)).toList();
      if (rescueCandidates.isNotEmpty) {
        candidates = rescueCandidates;
      } else {
        // Broaden search to full eligible pool if current chapter lacks a lifeline
        final broadRescue = eligible.where((c) => isRescueCard(c, _state)).toList();
        if (broadRescue.isNotEmpty) {
          candidates = broadRescue;
        }
      }
    }

    // 5. Avoid immediately repeating the exact same card if alternatives exist
    if (candidates.length > 1 && _currentCard != null) {
      final nonRepeating = candidates.where((c) => c.id != _currentCard!.id).toList();
      if (nonRepeating.isNotEmpty) {
        candidates = nonRepeating;
      }
    }

    _currentCard = candidates[_random.nextInt(candidates.length)];
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
      for (final flag in impact.setFlags) {
        CodexService.instance.recordFlagIfAchievement(flag);
      }
    }

    // Advance turn
    _state.dayCount += 1;
    CodexService.instance.recordDecision();
    CodexService.instance.recordSurvivalDays(_state.campaign, _state.dayCount);

    // Reset preview
    _swipePreview = SwipeDirection.none;

    // Evaluate terminal boundaries
    _state.checkStatus();

    if (_state.isGameOver) {
      AudioService.instance.playGameOverSfx();
      if (_state.deathReason != null) {
        CodexService.instance.recordDeath(
          _state.campaign,
          _state.deathReason!,
          _state.dayCount,
        );
      }
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
  /// If restarting the same campaign, advances to the next generational successor
  /// (incrementing reign number and assigning the next heir from the pool).
  /// If switching campaigns, initializes the respective founding protagonist.
  /// Resets gauges to 50, clears active flags, resets day count to 1,
  /// and draws a fresh starting card.
  void restart(CampaignType campaign, {Protagonist? customProtagonist}) {
    final Protagonist nextProtagonist;
    if (customProtagonist != null) {
      nextProtagonist = customProtagonist;
    } else if (_state.campaign == campaign) {
      nextProtagonist = _state.protagonist.nextSuccessor(campaign);
    } else {
      nextProtagonist = Protagonist.initial(campaign);
    }

    _state = GameState.initial(
      campaign: campaign,
      protagonist: nextProtagonist,
    );
    _swipePreview = SwipeDirection.none;
    drawNextCard();
    notifyListeners();
  }
}
