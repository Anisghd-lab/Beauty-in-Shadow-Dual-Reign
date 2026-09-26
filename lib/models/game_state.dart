import 'package:flutter/foundation.dart';
import 'card_model.dart';
import 'protagonist_model.dart';

/// Available campaign faction modes in Dual Reign.
enum CampaignType {
  /// Dark criminal underworld, neon-lit syndicates and street-level dominance.
  street,

  /// Aristocratic dynasties, imperial intrigues, royal treasury and Senate.
  empire;

  /// String identifier matching [GameCard.campaign].
  String get key => name.toUpperCase();

  /// User-facing display title for the campaign.
  String get displayName {
    switch (this) {
      case CampaignType.street:
        return 'Street Syndicate';
      case CampaignType.empire:
        return 'Royal Empire';
    }
  }
}

/// Specific terminal condition causing game over when a gauge reaches extremity (0 or 100).
enum GameOverReason {
  /// Gauge 1 dropped to <= 0.
  gauge1Depleted(gaugeIndex: 1, isDepletion: true),

  /// Gauge 1 reached >= 100.
  gauge1Overflow(gaugeIndex: 1, isDepletion: false),

  /// Gauge 2 dropped to <= 0.
  gauge2Depleted(gaugeIndex: 2, isDepletion: true),

  /// Gauge 2 reached >= 100.
  gauge2Overflow(gaugeIndex: 2, isDepletion: false),

  /// Gauge 3 dropped to <= 0.
  gauge3Depleted(gaugeIndex: 3, isDepletion: true),

  /// Gauge 3 reached >= 100.
  gauge3Overflow(gaugeIndex: 3, isDepletion: false),

  /// Gauge 4 dropped to <= 0.
  gauge4Depleted(gaugeIndex: 4, isDepletion: true),

  /// Gauge 4 reached >= 100.
  gauge4Overflow(gaugeIndex: 4, isDepletion: false),

  /// Custom narrative fatality triggered by specific story events.
  custom(gaugeIndex: 0, isDepletion: false);

  final int gaugeIndex;
  final bool isDepletion;

  const GameOverReason({
    required this.gaugeIndex,
    required this.isDepletion,
  });
}

/// The core game state holding faction gauges, narrative progression and death state.
class GameState {
  static const int minGaugeValue = 0;
  static const int maxGaugeValue = 100;
  static const int defaultGaugeValue = 50;

  /// Active campaign mode.
  CampaignType campaign;

  /// Gauge 1 (0..100) — Street: Respect/Influence | Empire: Politics/Senate
  int gauge1;

  /// Gauge 2 (0..100) — Street: Cash/Treasury | Empire: Imperial Coffers
  int gauge2;

  /// Gauge 3 (0..100) — Street: Heat/Security | Empire: Military/Royal Guard
  int gauge3;

  /// Gauge 4 (0..100) — Street: Clan Loyalty | Empire: People/Public Order
  int gauge4;

  /// Number of days / turns survived.
  int dayCount;

  /// Active story flags unlocked by previous card choices.
  Set<String> activeFlags;

  /// Active protagonist representing the player avatar and dynastic generational lineage.
  Protagonist protagonist;

  /// Whether the current run has ended in defeat/death.
  bool isGameOver;

  /// The root cause of death if [isGameOver] is true.
  GameOverReason? deathReason;

  /// The narrative eulogy / obituary explaining the player's demise.
  String? deathMessage;

  GameState({
    this.campaign = CampaignType.street,
    this.gauge1 = defaultGaugeValue,
    this.gauge2 = defaultGaugeValue,
    this.gauge3 = defaultGaugeValue,
    this.gauge4 = defaultGaugeValue,
    this.dayCount = 1,
    Set<String>? activeFlags,
    Protagonist? protagonist,
    this.isGameOver = false,
    this.deathReason,
    this.deathMessage,
  })  : activeFlags = activeFlags ?? <String>{},
        protagonist = protagonist ?? Protagonist.initial(campaign);

  /// Factory constructor to start a fresh playthrough.
  factory GameState.initial({
    CampaignType campaign = CampaignType.street,
    Protagonist? protagonist,
  }) {
    return GameState(
      campaign: campaign,
      gauge1: defaultGaugeValue,
      gauge2: defaultGaugeValue,
      gauge3: defaultGaugeValue,
      gauge4: defaultGaugeValue,
      dayCount: 1,
      activeFlags: <String>{},
      protagonist: protagonist ?? Protagonist.initial(campaign),
      isGameOver: false,
    );
  }

  /// List representation of all 4 gauge values in order [gauge1, gauge2, gauge3, gauge4].
  List<int> get gauges => [gauge1, gauge2, gauge3, gauge4];

  /// Returns gauge value by 1-based index (1..4).
  int getGauge(int index) {
    switch (index) {
      case 1:
        return gauge1;
      case 2:
        return gauge2;
      case 3:
        return gauge3;
      case 4:
        return gauge4;
      default:
        throw ArgumentError('Gauge index must be between 1 and 4, received $index');
    }
  }

  /// Evaluates gauge boundaries and triggers death if any gauge is <= 0 or >= 100.
  ///
  /// Updates [isGameOver], [deathReason] and [deathMessage] on `this` instance
  /// and returns `this` for fluent chaining.
  GameState checkStatus() {
    if (isGameOver) {
      return this;
    }

    GameOverReason? triggeredReason;

    if (gauge1 <= minGaugeValue) {
      triggeredReason = GameOverReason.gauge1Depleted;
    } else if (gauge1 >= maxGaugeValue) {
      triggeredReason = GameOverReason.gauge1Overflow;
    } else if (gauge2 <= minGaugeValue) {
      triggeredReason = GameOverReason.gauge2Depleted;
    } else if (gauge2 >= maxGaugeValue) {
      triggeredReason = GameOverReason.gauge2Overflow;
    } else if (gauge3 <= minGaugeValue) {
      triggeredReason = GameOverReason.gauge3Depleted;
    } else if (gauge3 >= maxGaugeValue) {
      triggeredReason = GameOverReason.gauge3Overflow;
    } else if (gauge4 <= minGaugeValue) {
      triggeredReason = GameOverReason.gauge4Depleted;
    } else if (gauge4 >= maxGaugeValue) {
      triggeredReason = GameOverReason.gauge4Overflow;
    }

    if (triggeredReason != null) {
      isGameOver = true;
      deathReason = triggeredReason;
      deathMessage = resolveDeathMessage(campaign, triggeredReason);
    }

    return this;
  }

  /// Applies the consequences of a player's swipe decision and immediately checks status.
  GameState applyChoice(ChoiceImpact impact) {
    if (isGameOver) return this;

    final newGauge1 = (gauge1 + impact.deltaGauge1).clamp(minGaugeValue, maxGaugeValue);
    final newGauge2 = (gauge2 + impact.deltaGauge2).clamp(minGaugeValue, maxGaugeValue);
    final newGauge3 = (gauge3 + impact.deltaGauge3).clamp(minGaugeValue, maxGaugeValue);
    final newGauge4 = (gauge4 + impact.deltaGauge4).clamp(minGaugeValue, maxGaugeValue);

    final updatedFlags = Set<String>.from(activeFlags)..addAll(impact.setFlags);
    final updatedProtagonist =
        protagonist.withUpdatedTitle(updatedFlags, campaign);

    final nextState = copyWith(
      gauge1: newGauge1,
      gauge2: newGauge2,
      gauge3: newGauge3,
      gauge4: newGauge4,
      dayCount: dayCount + 1,
      activeFlags: updatedFlags,
      protagonist: updatedProtagonist,
    );

    return nextState.checkStatus();
  }

  /// Resolves the campaign-specific narrative death message for any terminal condition.
  static String resolveDeathMessage(CampaignType campaign, GameOverReason reason) {
    switch (campaign) {
      case CampaignType.street:
        switch (reason) {
          case GameOverReason.gauge1Depleted:
            return 'Votre réputation s\'effondre dans les bas-fonds. Considéré comme faible et sans autorité, votre propre syndicat vous élimine dans une ruelle sombre.';
          case GameOverReason.gauge1Overflow:
            return 'Votre notoriété démesurée terrifie les cartels rivaux. Une coalition criminelle s\'organise et pulvérise votre quartier général.';
          case GameOverReason.gauge2Depleted:
            return 'Banqueroute totale. Incapable de payer vos guetteurs ni vos dettes d\'approvisionnement, les tueurs à gages du cartel viennent saisir votre vie.';
          case GameOverReason.gauge2Overflow:
            return 'Votre fortune colossale suscite une convoitise aveugle. Vos lieutenants les plus proches vous empoisonnent pour s\'emparer de vos coffres.';
          case GameOverReason.gauge3Depleted:
            return 'Trop discret et inactif, vous perdez le contrôle de la rue. Des gangs opportunistes s\'emparent de vos territoires sans résistance.';
          case GameOverReason.gauge3Overflow:
            return 'L\'indice de recherche atteint un seuil critique. Le SWAT et les forces fédérales encerclent votre refuge et donnent l\'assaut sans sommation.';
          case GameOverReason.gauge4Depleted:
            return 'Trahison absolue. Abandonné par tous vos fidèles qui refusent de mourir pour vous, vos ennemis n\'ont plus qu\'à venir vous cueillir.';
          case GameOverReason.gauge4Overflow:
            return 'Le fanatisme de votre clan échappe à tout contrôle. Une purge fratricide éclate et vous mourez sous les balles de vos propres hommes.';
          case GameOverReason.custom:
            return 'Le destin de la rue s\'est refermé sur vous.';
        }

      case CampaignType.empire:
        switch (reason) {
          case GameOverReason.gauge1Depleted:
            return 'Destitution royale. La cour impériale et le Sénat votent votre déchéance et vous condamnent à finir vos jours dans les cachots de la forteresse.';
          case GameOverReason.gauge1Overflow:
            return 'Votre emprise tyrannique terrifie l\'aristocratie. Une conspiration de ministres vous encercle et vous poignarde au cœur de la salle du trône.';
          case GameOverReason.gauge2Depleted:
            return 'Les caisses impériales sont à sec. Les mercenaires royaux impayés se mutinent, mettent la capitale à sac et pillent le palais.';
          case GameOverReason.gauge2Overflow:
            return 'L\'opulence excessive plonge la cour dans la décadence. Des barons avides s\'unissent pour vous assassiner et se partager le trésor impérial.';
          case GameOverReason.gauge3Depleted:
            return 'L\'armée capitule et la garde royale déserte. Les légions ennemies franchissent les remparts de la cité sans la moindre résistance.';
          case GameOverReason.gauge3Overflow:
            return 'La junte militaire s\'empare du pouvoir absolu. Le grand maréchal mène un coup d\'État sanglant et s\'autoproclame empereur sur votre trône.';
          case GameOverReason.gauge4Depleted:
            return 'Insurrection populaire massive. La foule enragée force les grilles du domaine impérial et traîne la dynastie sous le couperet.';
          case GameOverReason.gauge4Overflow:
            return 'La dévotion populaire vire au fanatisme mystique hystérique. Une marée humaine déferle dans vos quartiers et vous étouffe dans sa ferveur.';
          case GameOverReason.custom:
            return 'La couronne d\'ombre est tombée.';
        }
    }
  }

  /// The name of the next generational heir/successor who will take over if the current reign falls.
  String get nextSuccessorName => protagonist.getNextSuccessorName(campaign);

  /// Dynamic reign summary description (e.g., "Jour 12 du règne de Kimmie").
  String get reignText => protagonist.getReignDurationText(dayCount);

  GameState copyWith({
    CampaignType? campaign,
    int? gauge1,
    int? gauge2,
    int? gauge3,
    int? gauge4,
    int? dayCount,
    Set<String>? activeFlags,
    Protagonist? protagonist,
    bool? isGameOver,
    GameOverReason? deathReason,
    String? deathMessage,
  }) {
    return GameState(
      campaign: campaign ?? this.campaign,
      gauge1: gauge1 ?? this.gauge1,
      gauge2: gauge2 ?? this.gauge2,
      gauge3: gauge3 ?? this.gauge3,
      gauge4: gauge4 ?? this.gauge4,
      dayCount: dayCount ?? this.dayCount,
      activeFlags: activeFlags != null
          ? Set<String>.from(activeFlags)
          : Set<String>.from(this.activeFlags),
      protagonist: protagonist ?? this.protagonist,
      isGameOver: isGameOver ?? this.isGameOver,
      deathReason: deathReason ?? this.deathReason,
      deathMessage: deathMessage ?? this.deathMessage,
    );
  }

  Map<String, dynamic> toJson() => {
        'campaign': campaign.name,
        'gauge1': gauge1,
        'gauge2': gauge2,
        'gauge3': gauge3,
        'gauge4': gauge4,
        'dayCount': dayCount,
        'activeFlags': activeFlags.toList(),
        'protagonist': protagonist.toJson(),
        'isGameOver': isGameOver,
        if (deathReason != null) 'deathReason': deathReason!.name,
        if (deathMessage != null) 'deathMessage': deathMessage,
      };

  factory GameState.fromJson(Map<String, dynamic> json) {
    final campaignName = json['campaign'] as String? ?? 'street';
    final campaign = CampaignType.values.firstWhere(
      (c) => c.name.toLowerCase() == campaignName.toLowerCase(),
      orElse: () => CampaignType.street,
    );

    final reasonName = json['deathReason'] as String?;
    final deathReason = reasonName != null
        ? GameOverReason.values.firstWhere(
            (r) => r.name == reasonName,
            orElse: () => GameOverReason.custom,
          )
        : null;

    final flags = (json['activeFlags'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toSet() ??
        <String>{};

    final protagonistJson = json['protagonist'] as Map<String, dynamic>?;
    final protagonist = protagonistJson != null
        ? Protagonist.fromJson(protagonistJson)
        : Protagonist.initial(campaign);

    return GameState(
      campaign: campaign,
      gauge1: (json['gauge1'] as num?)?.toInt() ?? defaultGaugeValue,
      gauge2: (json['gauge2'] as num?)?.toInt() ?? defaultGaugeValue,
      gauge3: (json['gauge3'] as num?)?.toInt() ?? defaultGaugeValue,
      gauge4: (json['gauge4'] as num?)?.toInt() ?? defaultGaugeValue,
      dayCount: (json['dayCount'] as num?)?.toInt() ?? 1,
      activeFlags: flags,
      protagonist: protagonist,
      isGameOver: json['isGameOver'] as bool? ?? false,
      deathReason: deathReason,
      deathMessage: json['deathMessage'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameState &&
          runtimeType == other.runtimeType &&
          campaign == other.campaign &&
          gauge1 == other.gauge1 &&
          gauge2 == other.gauge2 &&
          gauge3 == other.gauge3 &&
          gauge4 == other.gauge4 &&
          dayCount == other.dayCount &&
          setEquals(activeFlags, other.activeFlags) &&
          protagonist == other.protagonist &&
          isGameOver == other.isGameOver &&
          deathReason == other.deathReason &&
          deathMessage == other.deathMessage;

  @override
  int get hashCode => Object.hash(
        campaign,
        gauge1,
        gauge2,
        gauge3,
        gauge4,
        dayCount,
        Object.hashAll(activeFlags),
        protagonist,
        isGameOver,
        deathReason,
        deathMessage,
      );

  @override
  String toString() =>
      'GameState(${campaign.name}, $protagonist, G: [$gauge1, $gauge2, $gauge3, $gauge4], Day: $dayCount, Over: $isGameOver)';
}
