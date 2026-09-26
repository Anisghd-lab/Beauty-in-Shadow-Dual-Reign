import 'package:flutter/foundation.dart';
import 'game_state.dart';

/// Represents the player's active protagonist avatar and dynastic generational lineage.
class Protagonist {
  /// Name of the current active protagonist (e.g. "Kimmie" or "Mallory Bell").
  final String name;

  /// Dynamic narrative honorific or status reflecting campaign progress.
  final String title;

  /// Generational reign number (1 for founding reign, 2, 3... for successors).
  final int reignNumber;

  /// Pool of successor names available upon generational succession.
  final List<String> successorNames;

  const Protagonist({
    required this.name,
    required this.title,
    this.reignNumber = 1,
    this.successorNames = const <String>[],
  });

  /// Default successor pool for the Street campaign.
  static const List<String> streetSuccessors = [
    'Lexie',
    'Raven',
    'Skye',
    'Maya',
  ];

  /// Default successor pool for the Empire campaign.
  static const List<String> empireSuccessors = [
    'Victoria Bell',
    'Cassandra Bell',
    'Vivian Bell',
    'Eleanor Bell',
  ];

  /// Default starting protagonist for the given [campaign].
  factory Protagonist.initial(CampaignType campaign) {
    switch (campaign) {
      case CampaignType.street:
        return const Protagonist(
          name: 'Kimmie',
          title: 'Danseuse en Cavale',
          reignNumber: 1,
          successorNames: streetSuccessors,
        );
      case CampaignType.empire:
        return const Protagonist(
          name: 'Mallory Bell',
          title: 'Héritière Contestée',
          reignNumber: 1,
          successorNames: empireSuccessors,
        );
    }
  }

  /// Calculates the designated name of the next generational successor.
  String getNextSuccessorName(CampaignType campaign) {
    final pool = successorNames.isNotEmpty
        ? successorNames
        : (campaign == CampaignType.street ? streetSuccessors : empireSuccessors);
    final nextIndex = (reignNumber - 1) % pool.length;
    return pool[nextIndex];
  }

  /// Advances to the next generation successor upon defeat or dynastic succession.
  Protagonist nextSuccessor(CampaignType campaign) {
    final pool = successorNames.isNotEmpty
        ? successorNames
        : (campaign == CampaignType.street ? streetSuccessors : empireSuccessors);
    final nextName = getNextSuccessorName(campaign);
    final nextReign = reignNumber + 1;
    final defaultTitle = campaign == CampaignType.street
        ? 'Héritière de la Nuit'
        : 'Nouvelle Régente';

    return Protagonist(
      name: nextName,
      title: defaultTitle,
      reignNumber: nextReign,
      successorNames: pool,
    );
  }

  /// Evaluates and updates the narrative title based on currently unlocked story flags.
  Protagonist withUpdatedTitle(Set<String> activeFlags, CampaignType campaign) {
    String newTitle = title;

    if (campaign == CampaignType.street) {
      if (activeFlags.contains('reine_de_la_nuit') ||
          activeFlags.contains('epilogue_rue') ||
          activeFlags.contains('proces_bell')) {
        newTitle = 'Reine de la Nuit';
      } else if (activeFlags.contains('leader_syndicat') ||
          activeFlags.contains('syndicat_fonde') ||
          activeFlags.contains('alliances_scellees')) {
        newTitle = 'Cheffe du Syndicat';
      } else if (activeFlags.contains('danseuse_active') ||
          activeFlags.contains('kimmie_infiltree') ||
          activeFlags.contains('vip_room_decouverte')) {
        newTitle = 'Infiltrée du Velvet';
      }
    } else {
      if (activeFlags.contains('dynastie_eternelle') ||
          activeFlags.contains('epilogue_empire') ||
          activeFlags.contains('regne_absolu')) {
        newTitle = 'Matriarche Absolue';
      } else if (activeFlags.contains('sacre_imperial') ||
          activeFlags.contains('couronnement_celebre')) {
        newTitle = 'Impératrice d\'Airain';
      } else if (activeFlags.contains('horace_destitue') ||
          activeFlags.contains('horace_neutralise') ||
          activeFlags.contains('senat_soumis')) {
        newTitle = 'Maîtresse de la Dynastie';
      }
    }

    if (newTitle == title) return this;

    return copyWith(title: newTitle);
  }

  /// Returns user-facing reign duration summary.
  String getReignDurationText(int dayCount) =>
      'Jour $dayCount du règne de $name';

  Protagonist copyWith({
    String? name,
    String? title,
    int? reignNumber,
    List<String>? successorNames,
  }) {
    return Protagonist(
      name: name ?? this.name,
      title: title ?? this.title,
      reignNumber: reignNumber ?? this.reignNumber,
      successorNames: successorNames ?? this.successorNames,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'title': title,
        'reignNumber': reignNumber,
        'successorNames': successorNames,
      };

  factory Protagonist.fromJson(Map<String, dynamic> json) {
    return Protagonist(
      name: json['name'] as String? ?? 'Kimmie',
      title: json['title'] as String? ?? 'Danseuse en Cavale',
      reignNumber: (json['reignNumber'] as num?)?.toInt() ?? 1,
      successorNames: (json['successorNames'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          streetSuccessors,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Protagonist &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          title == other.title &&
          reignNumber == other.reignNumber &&
          listEquals(successorNames, other.successorNames);

  @override
  int get hashCode => Object.hash(
        name,
        title,
        reignNumber,
        Object.hashAll(successorNames),
      );

  @override
  String toString() =>
      'Protagonist($name, Reign #$reignNumber, "$title")';
}
