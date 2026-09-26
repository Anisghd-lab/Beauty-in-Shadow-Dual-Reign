import 'package:flutter/foundation.dart';

/// Represents the consequences of choosing a specific swipe option on a card.
@immutable
class ChoiceImpact {
  /// User-facing label or response for this choice (e.g., "Accepter l'offre").
  final String text;

  /// Delta applied to Gauge 1 (-100 to +100).
  final int deltaGauge1;

  /// Delta applied to Gauge 2 (-100 to +100).
  final int deltaGauge2;

  /// Delta applied to Gauge 3 (-100 to +100).
  final int deltaGauge3;

  /// Delta applied to Gauge 4 (-100 to +100).
  final int deltaGauge4;

  /// Flags activated/unlocked when choosing this option.
  final List<String> setFlags;

  /// Optional deterministic next card ID triggered by this decision.
  final String? nextCardId;

  const ChoiceImpact({
    required this.text,
    this.deltaGauge1 = 0,
    this.deltaGauge2 = 0,
    this.deltaGauge3 = 0,
    this.deltaGauge4 = 0,
    this.setFlags = const <String>[],
    this.nextCardId,
  });

  /// Whether this choice alters any of the 4 gauge values.
  bool get hasGaugeImpact =>
      deltaGauge1 != 0 ||
      deltaGauge2 != 0 ||
      deltaGauge3 != 0 ||
      deltaGauge4 != 0;

  /// Whether this choice branches narrative flow (sets flags or points to next card).
  bool get hasStoryImpact => nextCardId != null || setFlags.isNotEmpty;

  ChoiceImpact copyWith({
    String? text,
    int? deltaGauge1,
    int? deltaGauge2,
    int? deltaGauge3,
    int? deltaGauge4,
    List<String>? setFlags,
    String? nextCardId,
  }) {
    return ChoiceImpact(
      text: text ?? this.text,
      deltaGauge1: deltaGauge1 ?? this.deltaGauge1,
      deltaGauge2: deltaGauge2 ?? this.deltaGauge2,
      deltaGauge3: deltaGauge3 ?? this.deltaGauge3,
      deltaGauge4: deltaGauge4 ?? this.deltaGauge4,
      setFlags: setFlags ?? this.setFlags,
      nextCardId: nextCardId ?? this.nextCardId,
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'deltaGauge1': deltaGauge1,
        'deltaGauge2': deltaGauge2,
        'deltaGauge3': deltaGauge3,
        'deltaGauge4': deltaGauge4,
        'setFlags': setFlags,
        if (nextCardId != null) 'nextCardId': nextCardId,
      };

  factory ChoiceImpact.fromJson(Map<String, dynamic> json) {
    return ChoiceImpact(
      text: json['text'] as String? ?? '',
      deltaGauge1: (json['deltaGauge1'] as num?)?.toInt() ?? 0,
      deltaGauge2: (json['deltaGauge2'] as num?)?.toInt() ?? 0,
      deltaGauge3: (json['deltaGauge3'] as num?)?.toInt() ?? 0,
      deltaGauge4: (json['deltaGauge4'] as num?)?.toInt() ?? 0,
      setFlags: (json['setFlags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const <String>[],
      nextCardId: json['nextCardId'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChoiceImpact &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          deltaGauge1 == other.deltaGauge1 &&
          deltaGauge2 == other.deltaGauge2 &&
          deltaGauge3 == other.deltaGauge3 &&
          deltaGauge4 == other.deltaGauge4 &&
          listEquals(setFlags, other.setFlags) &&
          nextCardId == other.nextCardId;

  @override
  int get hashCode => Object.hash(
        text,
        deltaGauge1,
        deltaGauge2,
        deltaGauge3,
        deltaGauge4,
        Object.hashAll(setFlags),
        nextCardId,
      );

  @override
  String toString() =>
      'ChoiceImpact(text: "$text", Δ1: $deltaGauge1, Δ2: $deltaGauge2, Δ3: $deltaGauge3, Δ4: $deltaGauge4, next: $nextCardId)';
}

/// A narrative card presented to the player during Reign-style swipe gameplay.
@immutable
class GameCard {
  /// Unique identifier of the card (e.g. "street_001", "emp_intro_01").
  final String id;

  /// Target campaign faction: "STREET" or "EMPIRE".
  final String campaign;

  /// Name of the speaking character or entity.
  final String speakerName;

  /// Social role, title or gang faction of the speaker.
  final String speakerRole;

  /// Asset path or network URI for the character's portrait/avatar.
  final String speakerAvatar;

  /// Dialogue or narration displayed on the card.
  final String dialogue;

  /// Optional canonical interlocutor ID (e.g., "ST_004", "EM_002").
  final String? interlocutorId;

  /// Consequence triggered on left swipe.
  final ChoiceImpact leftChoice;

  /// Consequence triggered on right swipe.
  final ChoiceImpact rightChoice;

  /// Flags that MUST be active in the game state for this card to appear.
  final List<String> requiredFlags;

  /// Flags that MUST NOT be active in the game state for this card to appear.
  final List<String> forbiddenFlags;

  const GameCard({
    required this.id,
    required this.campaign,
    required this.speakerName,
    required this.speakerRole,
    required this.speakerAvatar,
    required this.dialogue,
    required this.leftChoice,
    required this.rightChoice,
    this.interlocutorId,
    this.requiredFlags = const <String>[],
    this.forbiddenFlags = const <String>[],
  });

  /// Whether this card belongs to the Street Syndicate campaign.
  bool get isStreet => campaign.toUpperCase() == 'STREET';

  /// Whether this card belongs to the Royal Empire campaign.
  bool get isEmpire => campaign.toUpperCase() == 'EMPIRE';

  /// Evaluates whether this card is valid to draw given the current [activeFlags].
  bool isEligible(Set<String> activeFlags) {
    final meetsRequired =
        requiredFlags.isEmpty || requiredFlags.every(activeFlags.contains);
    final avoidsForbidden =
        forbiddenFlags.isEmpty || !forbiddenFlags.any(activeFlags.contains);
    return meetsRequired && avoidsForbidden;
  }

  GameCard copyWith({
    String? id,
    String? campaign,
    String? speakerName,
    String? speakerRole,
    String? speakerAvatar,
    String? dialogue,
    String? interlocutorId,
    ChoiceImpact? leftChoice,
    ChoiceImpact? rightChoice,
    List<String>? requiredFlags,
    List<String>? forbiddenFlags,
  }) {
    return GameCard(
      id: id ?? this.id,
      campaign: campaign ?? this.campaign,
      speakerName: speakerName ?? this.speakerName,
      speakerRole: speakerRole ?? this.speakerRole,
      speakerAvatar: speakerAvatar ?? this.speakerAvatar,
      dialogue: dialogue ?? this.dialogue,
      interlocutorId: interlocutorId ?? this.interlocutorId,
      leftChoice: leftChoice ?? this.leftChoice,
      rightChoice: rightChoice ?? this.rightChoice,
      requiredFlags: requiredFlags ?? this.requiredFlags,
      forbiddenFlags: forbiddenFlags ?? this.forbiddenFlags,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'campaign': campaign,
        'speakerName': speakerName,
        'speakerRole': speakerRole,
        'speakerAvatar': speakerAvatar,
        if (interlocutorId != null) 'interlocutorId': interlocutorId,
        'dialogue': dialogue,
        'leftChoice': leftChoice.toJson(),
        'rightChoice': rightChoice.toJson(),
        'requiredFlags': requiredFlags,
        'forbiddenFlags': forbiddenFlags,
      };

  factory GameCard.fromJson(Map<String, dynamic> json) {
    return GameCard(
      id: json['id'] as String? ?? '',
      campaign: json['campaign'] as String? ?? 'STREET',
      speakerName: json['speakerName'] as String? ?? '',
      speakerRole: json['speakerRole'] as String? ?? '',
      speakerAvatar: json['speakerAvatar'] as String? ?? '',
      interlocutorId: json['interlocutorId'] as String?,
      dialogue: json['dialogue'] as String? ?? '',
      leftChoice: ChoiceImpact.fromJson(
        json['leftChoice'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      ),
      rightChoice: ChoiceImpact.fromJson(
        json['rightChoice'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      ),
      requiredFlags: (json['requiredFlags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const <String>[],
      forbiddenFlags: (json['forbiddenFlags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const <String>[],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameCard &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          campaign == other.campaign &&
          speakerName == other.speakerName &&
          speakerRole == other.speakerRole &&
          speakerAvatar == other.speakerAvatar &&
          interlocutorId == other.interlocutorId &&
          dialogue == other.dialogue &&
          leftChoice == other.leftChoice &&
          rightChoice == other.rightChoice &&
          listEquals(requiredFlags, other.requiredFlags) &&
          listEquals(forbiddenFlags, other.forbiddenFlags);

  @override
  int get hashCode => Object.hash(
        id,
        campaign,
        speakerName,
        speakerRole,
        speakerAvatar,
        interlocutorId,
        dialogue,
        leftChoice,
        rightChoice,
        Object.hashAll(requiredFlags),
        Object.hashAll(forbiddenFlags),
      );

  @override
  String toString() =>
      'GameCard(id: "$id", interlocutor: "$interlocutorId", campaign: "$campaign", speaker: "$speakerName ($speakerRole)")';
}
