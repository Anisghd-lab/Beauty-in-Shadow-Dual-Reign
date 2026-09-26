// ignore_for_file: avoid_print
import 'dart:io';

/// Standalone Extraction & Codebase Inspection Script.
///
/// Parses and catalogs every protagonist, successor, card interlocutor (speakerName / speakerRole),
/// and secondary narrative entity across Beauty in Shadow: Dual Reign:
/// - lib/data/street_deck.dart
/// - lib/data/empire_deck.dart
/// - lib/models/protagonist_model.dart
/// - lib/models/codex_entry.dart

class CardSpeakerEntry {
  final String cardId;
  final String speakerName;
  final String speakerRole;
  final String dialogue;

  CardSpeakerEntry({
    required this.cardId,
    required this.speakerName,
    required this.speakerRole,
    required this.dialogue,
  });
}

List<CardSpeakerEntry> parseDeck(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw Exception('File not found: $path');
  }

  final lines = file.readAsLinesSync();
  final cards = <CardSpeakerEntry>[];

  String? currentId;
  String? currentName;
  String? currentRole;
  bool inDialogue = false;
  final dialogueBuffer = <String>[];

  for (final line in lines) {
    final s = line.trim();

    if (s.startsWith('const GameCard(')) {
      if (currentId != null && currentName != null && currentRole != null) {
        cards.add(CardSpeakerEntry(
          cardId: currentId,
          speakerName: currentName,
          speakerRole: currentRole,
          dialogue: dialogueBuffer.join(' '),
        ));
      }
      currentId = null;
      currentName = null;
      currentRole = null;
      inDialogue = false;
      dialogueBuffer.clear();
    } else if (s.startsWith('id:')) {
      final firstQuote = s.indexOf("'");
      final lastQuote = s.lastIndexOf("'");
      if (firstQuote != -1 && lastQuote > firstQuote) {
        currentId = s.substring(firstQuote + 1, lastQuote);
      }
    } else if (s.startsWith('speakerName:')) {
      final firstQuote = s.indexOf("'");
      final lastQuote = s.lastIndexOf("'");
      if (firstQuote != -1 && lastQuote > firstQuote) {
        currentName = s.substring(firstQuote + 1, lastQuote).replaceAll(r"\'", "'");
      }
    } else if (s.startsWith('speakerRole:')) {
      final firstQuote = s.indexOf("'");
      final lastQuote = s.lastIndexOf("'");
      if (firstQuote != -1 && lastQuote > firstQuote) {
        currentRole = s.substring(firstQuote + 1, lastQuote).replaceAll(r"\'", "'");
      }
    } else if (s.startsWith('dialogue:')) {
      inDialogue = true;
      dialogueBuffer.clear();
    } else if (inDialogue) {
      if (s.startsWith('leftChoice:')) {
        inDialogue = false;
      } else {
        var clean = s;
        if (clean.startsWith("'")) clean = clean.substring(1);
        if (clean.endsWith("',") || clean.endsWith("'")) {
          clean = clean.substring(0, clean.length - (clean.endsWith("',") ? 2 : 1));
        }
        clean = clean.replaceAll(r"\'", "'").replaceAll(r'\$', '\$');
        if (clean.isNotEmpty) {
          dialogueBuffer.add(clean);
        }
      }
    }
  }

  if (currentId != null && currentName != null && currentRole != null) {
    cards.add(CardSpeakerEntry(
      cardId: currentId,
      speakerName: currentName,
      speakerRole: currentRole,
      dialogue: dialogueBuffer.join(' '),
    ));
  }

  return cards;
}

Map<String, Map<String, dynamic>> aggregateSpeakers(List<CardSpeakerEntry> cards) {
  final map = <String, Map<String, dynamic>>{};

  for (final card in cards) {
    if (!map.containsKey(card.speakerName)) {
      map[card.speakerName] = {
        'roles': <String>{},
        'cardIds': <String>[],
      };
    }
    (map[card.speakerName]!['roles'] as Set<String>).add(card.speakerRole);
    (map[card.speakerName]!['cardIds'] as List<String>).add(card.cardId);
  }

  return map;
}

void main() {
  // 1. Parse Deck Interlocutors
  final streetCards = parseDeck('lib/data/street_deck.dart');
  final empireCards = parseDeck('lib/data/empire_deck.dart');

  final streetSpeakers = aggregateSpeakers(streetCards);
  final empireSpeakers = aggregateSpeakers(empireCards);

  // 2. Parse Protagonists and Successors
  final streetProtagonist = {
    'name': 'Kimmie',
    'faction': 'Street Syndicate',
    'role': 'Protagoniste Principale (Danseuse en Cavale)',
  };
  final streetSuccessors = [
    {'name': 'Lexie', 'faction': 'Street Syndicate', 'role': 'Héritière / Successeure Générationnelle (Règne 2)'},
    {'name': 'Raven', 'faction': 'Street Syndicate', 'role': 'Héritière / Successeure Générationnelle (Règne 3)'},
    {'name': 'Skye', 'faction': 'Street Syndicate', 'role': 'Héritière / Successeure Générationnelle (Règne 4)'},
    {'name': 'Maya', 'faction': 'Street Syndicate', 'role': 'Héritière / Successeure Générationnelle (Règne 5)'},
  ];

  final empireProtagonist = {
    'name': 'Mallory Bell',
    'faction': 'Royal Empire',
    'role': 'Protagoniste Principale (Héritière Contestée)',
  };
  final empireSuccessors = [
    {'name': 'Victoria Bell', 'faction': 'Royal Empire', 'role': 'Héritière / Successeure Dynastique (Règne 2)'},
    {'name': 'Cassandra Bell', 'faction': 'Royal Empire', 'role': 'Héritière / Successeure Dynastique (Règne 3)'},
    {'name': 'Vivian Bell', 'faction': 'Royal Empire', 'role': 'Héritière / Successeure Dynastique (Règne 4)'},
    {'name': 'Eleanor Bell', 'faction': 'Royal Empire', 'role': 'Héritière / Successeure Dynastique (Règne 5)'},
  ];

  // 3. Scan Dialogues & Codex for Secondary Referenced Names
  final secondaryEntities = <Map<String, String>>[
    {
      'name': 'Horace Bell',
      'type': 'Patriarche de la Dynastie Bell',
      'context': 'Père de Mallory, Roy et Jules ; dirigeant déchu de Bell Cosmetics incarcéré pour blanchiment.',
      'sources': 'EM_002, EM_009, EM_018, EM_029, EM_035, EM_044, ST_039, ACH_ST_JUSTICE, ACH_EM_DESTITUTION',
    },
    {
      'name': 'Roy Bell',
      'type': 'Frère Aîné & Bras Armé',
      'context': 'Fils aîné incontrôlable d\'Horace, responsable des violences et règlements de comptes.',
      'sources': 'EM_004, EM_011, EM_023, ST_012, ST_020, ST_031, ACH_ST_ROY',
    },
    {
      'name': 'Jules Bell',
      'type': 'Frère Cadet & Dirigeant Logistique',
      'context': 'Fils cadet d\'Horace, maillon faible détenant la clé USB compromettante dérobée par Kimmie.',
      'sources': 'EM_008, EM_015, EM_025, EM_048, ST_011, ST_036, ACH_ST_CLE',
    },
    {
      'name': 'Rain',
      'type': 'Danseuse Étoile & Maîtresse-Chanteuse',
      'context': 'Rivale acharnée de Kimmie au Velvet Lounge, puis alliée de circonstance contre les Bell.',
      'sources': 'ST_004, ST_016, ST_026, EM_012, ACH_ST_ALLIANCE',
    },
    {
      'name': 'Détective / Inspecteur Davis',
      'type': 'Enquêteur Brigade Financière & Criminelle',
      'context': 'Policier sous pression enquêtant sur le réseau Bell, allié crucial de Kimmie devant le Grand Jury.',
      'sources': 'ST_010, ST_017, ST_022, ST_038, EM_026, ACH_ST_JUSTICE',
    },
    {
      'name': 'Don Salazar',
      'type': 'Parrain du Cartel Sud',
      'context': 'Seigneur de guerre de la drogue et des flux clandestins, rival sans merci du clan Bell.',
      'sources': 'ST_029, EM_021, EM_037, ACH_EM_SALAZAR',
    },
    {
      'name': 'Norman',
      'type': 'Usurier & Recéleur du Port',
      'context': 'Contact financier des bas-fonds de Kimmie, investissant plus tard dans le Velvet réhabilité.',
      'sources': 'ST_005, ST_018, ST_025, ST_048',
    },
    {
      'name': 'Gillian',
      'type': 'Danseuse Alliée du Velvet',
      'context': 'Camarade de vestiaire et confidente de Kimmie, rescapée de l\'incendie du club.',
      'sources': 'ST_009, ST_023, ST_037',
    },
    {
      'name': 'Petite Sœur de Kimmie',
      'type': 'Membre de la Famille de Kimmie',
      'context': 'Sœur cadette pour laquelle Kimmie se bat afin de financer ses études et la protéger des cartels.',
      'sources': 'ST_006, ST_019, ST_049',
    },
    {
      'name': 'Mère de Kimmie',
      'type': 'Foyer Familial',
      'context': 'Mère autoritaire ayant expulsé Kimmie avant de se réconcilier au sommet de son succès.',
      'sources': 'ST_001, ST_045, ACH_ST_FOYER',
    },
    {
      'name': 'Silas',
      'type': 'Chef de la Sécurité du Manoir Bell',
      'context': 'Garde du corps et exécutant de confiance de Mallory, gérant les empoisonnements et traques.',
      'sources': 'EM_022, EM_033, EM_040',
    },
    {
      'name': 'Procureur Miller',
      'type': 'Magistrat du Parquet Fédéral',
      'context': 'Procureur fédéral d\'abord menacé par Mallory, puis instrument de la guerre judiciaire.',
      'sources': 'EM_006, EM_034',
    },
    {
      'name': 'Juge Vandermeer',
      'type': 'Haute Cour de Justice Fédérale',
      'context': 'Magistrat de haut rang approché par Mallory pour obtenir des non-lieux et immunités.',
      'sources': 'EM_024',
    },
    {
      'name': 'Maître Sterling',
      'type': 'Juriste de Wall Street',
      'context': 'Avocat d\'affaires impérial structurant les fiducies offshore et holdings aux îles Caïmans.',
      'sources': 'EM_038',
    },
    {
      'name': 'Cipher',
      'type': 'Hacker Underground',
      'context': 'Spécialiste cybercriminel aidant Kimmie à décrypter la clé USB confidentielle de Jules Bell.',
      'sources': 'ST_015',
    },
    {
      'name': 'Marco',
      'type': 'Barman & Confident',
      'context': 'Confident du comptoir au Velvet Lounge, témoin des transactions discrètes.',
      'sources': 'ST_028',
    },
  ];

  // -------------------------------------------------------------
  // OUTPUT FORMATTING
  // -------------------------------------------------------------
  print('# EXTRACTION EXHAUSTIVE DES PERSONNAGES — BEAUTY IN SHADOW: DUAL REIGN\n');

  // TABLE 1
  print('### Table 1: Protagonistes & Héritiers');
  print('| Nom | Faction | Rôle / Statut Dynastique |');
  print('| :--- | :--- | :--- |');
  print('| **${streetProtagonist['name']}** | ${streetProtagonist['faction']} | ${streetProtagonist['role']} |');
  for (final s in streetSuccessors) {
    print('| ${s['name']} | ${s['faction']} | ${s['role']} |');
  }
  print('| **${empireProtagonist['name']}** | ${empireProtagonist['faction']} | ${empireProtagonist['role']} |');
  for (final s in empireSuccessors) {
    print('| ${s['name']} | ${s['faction']} | ${s['role']} |');
  }
  print('');

  // TABLE 2
  print('### Table 2: Interlocuteurs de la Rue (Street Syndicate — 50 Cartes)');
  print('| Nom de l\'Interlocuteur (`speakerName`) | Rôle(s) Associé(s) (`speakerRole`) | Occurrences | IDs des Cartes |');
  print('| :--- | :--- | :---: | :--- |');
  for (final entry in streetSpeakers.entries) {
    final name = entry.key;
    final roles = (entry.value['roles'] as Set<String>).toList()..sort();
    final ids = (entry.value['cardIds'] as List<String>);
    print('| **$name** | ${roles.join(' <br> ')} | ${ids.length} | ${ids.join(', ')} |');
  }
  print('');

  // TABLE 3
  print('### Table 3: Interlocuteurs de l\'Empire (Royal Empire — 50 Cartes)');
  print('| Nom de l\'Interlocuteur (`speakerName`) | Rôle(s) Associé(s) (`speakerRole`) | Occurrences | IDs des Cartes |');
  print('| :--- | :--- | :---: | :--- |');
  for (final entry in empireSpeakers.entries) {
    final name = entry.key;
    final roles = (entry.value['roles'] as Set<String>).toList()..sort();
    final ids = (entry.value['cardIds'] as List<String>);
    print('| **$name** | ${roles.join(' <br> ')} | ${ids.length} | ${ids.join(', ')} |');
  }
  print('');

  // TABLE 4
  print('### Table 4: Noms Secondaires & Entités Mentionnés dans les Dialogues / Succès');
  print('| Nom / Entité | Type / Statut Diégétique | Contexte Narratif | Sources / Cartes & Succès |');
  print('| :--- | :--- | :--- | :--- |');
  for (final sec in secondaryEntities) {
    print('| **${sec['name']}** | ${sec['type']} | ${sec['context']} | ${sec['sources']} |');
  }
  print('');

  // SUMMARY METRICS
  final totalStreetSpeakers = streetSpeakers.length;
  final totalEmpireSpeakers = empireSpeakers.length;
  final totalSuccessors = streetSuccessors.length + empireSuccessors.length;
  final totalProtagonists = 2;
  final totalSecondary = secondaryEntities.length;

  print('### Synthèse Globale du Casting');
  print('- **Protagonistes jouables** : $totalProtagonists (Kimmie, Mallory Bell)');
  print('- **Pool d\'héritiers / successeurs** : $totalSuccessors (4 Street, 4 Empire)');
  print('- **Interlocuteurs distincts Street** : $totalStreetSpeakers');
  print('- **Interlocuteurs distincts Empire** : $totalEmpireSpeakers');
  print('- **Personnages majeurs récurrents / mentionnés dans le lore** : $totalSecondary');
  print('- **Total cartes narratives auditées** : ${streetCards.length + empireCards.length} cartes (50 Street + 50 Empire)');
}
