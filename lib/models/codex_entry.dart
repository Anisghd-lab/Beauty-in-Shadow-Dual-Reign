import 'game_state.dart';

/// Represents one of the 16 canonical death fates in Dual Reign.
class DeathEntry {
  final String id;
  final CampaignType campaign;
  final GameOverReason reason;
  final int gaugeIndex;
  final bool isOverflow;
  final String gaugeName;
  final String title;
  final String description;
  final String hint;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int deathCount;
  final int? lastDaysSurvived;

  const DeathEntry({
    required this.id,
    required this.campaign,
    required this.reason,
    required this.gaugeIndex,
    required this.isOverflow,
    required this.gaugeName,
    required this.title,
    required this.description,
    required this.hint,
    this.isUnlocked = false,
    this.unlockedAt,
    this.deathCount = 0,
    this.lastDaysSurvived,
  });

  DeathEntry copyWith({
    String? id,
    CampaignType? campaign,
    GameOverReason? reason,
    int? gaugeIndex,
    bool? isOverflow,
    String? gaugeName,
    String? title,
    String? description,
    String? hint,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? deathCount,
    int? lastDaysSurvived,
  }) {
    return DeathEntry(
      id: id ?? this.id,
      campaign: campaign ?? this.campaign,
      reason: reason ?? this.reason,
      gaugeIndex: gaugeIndex ?? this.gaugeIndex,
      isOverflow: isOverflow ?? this.isOverflow,
      gaugeName: gaugeName ?? this.gaugeName,
      title: title ?? this.title,
      description: description ?? this.description,
      hint: hint ?? this.hint,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      deathCount: deathCount ?? this.deathCount,
      lastDaysSurvived: lastDaysSurvived ?? this.lastDaysSurvived,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'isUnlocked': isUnlocked,
        if (unlockedAt != null) 'unlockedAt': unlockedAt!.toIso8601String(),
        'deathCount': deathCount,
        if (lastDaysSurvived != null) 'lastDaysSurvived': lastDaysSurvived,
      };

  factory DeathEntry.fromJson(Map<String, dynamic> json, DeathEntry template) {
    return template.copyWith(
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.tryParse(json['unlockedAt'] as String)
          : null,
      deathCount: (json['deathCount'] as num?)?.toInt() ?? 0,
      lastDaysSurvived: (json['lastDaysSurvived'] as num?)?.toInt(),
    );
  }
}

/// Represents a key narrative milestone / achievement unlocked via card flags.
class StoryAchievement {
  final String id;
  final CampaignType campaign;
  final String flag;
  final String title;
  final String description;
  final String hint;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const StoryAchievement({
    required this.id,
    required this.campaign,
    required this.flag,
    required this.title,
    required this.description,
    required this.hint,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  StoryAchievement copyWith({
    String? id,
    CampaignType? campaign,
    String? flag,
    String? title,
    String? description,
    String? hint,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return StoryAchievement(
      id: id ?? this.id,
      campaign: campaign ?? this.campaign,
      flag: flag ?? this.flag,
      title: title ?? this.title,
      description: description ?? this.description,
      hint: hint ?? this.hint,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'isUnlocked': isUnlocked,
        if (unlockedAt != null) 'unlockedAt': unlockedAt!.toIso8601String(),
      };

  factory StoryAchievement.fromJson(
      Map<String, dynamic> json, StoryAchievement template) {
    return template.copyWith(
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.tryParse(json['unlockedAt'] as String)
          : null,
    );
  }
}

// ==========================================
// Canonical 16 Deaths (8 Street, 8 Empire)
// ==========================================

const List<DeathEntry> canonicalStreetDeaths = [
  DeathEntry(
    id: 'ST_D1_MIN',
    campaign: CampaignType.street,
    reason: GameOverReason.gauge1Depleted,
    gaugeIndex: 1,
    isOverflow: false,
    gaugeName: 'Dignité',
    title: 'Ruine Morale',
    description:
        'Votre réputation s\'effondre dans les bas-fonds. Considéré comme faible et sans autorité, votre propre syndicat vous élimine dans une ruelle sombre.',
    hint: 'Laissez votre Dignité sombrer jusqu\'à zéro dans les bas-fonds.',
  ),
  DeathEntry(
    id: 'ST_D1_MAX',
    campaign: CampaignType.street,
    reason: GameOverReason.gauge1Overflow,
    gaugeIndex: 1,
    isOverflow: true,
    gaugeName: 'Dignité',
    title: 'L\'Orgueil Fatal',
    description:
        'Votre notoriété démesurée terrifie les cartels rivaux. Une coalition criminelle s\'organise et pulvérise votre quartier général.',
    hint: 'Accumulez un orgueil si absolu qu\'il terrifie les barons rivaux.',
  ),
  DeathEntry(
    id: 'ST_D2_MIN',
    campaign: CampaignType.street,
    reason: GameOverReason.gauge2Depleted,
    gaugeIndex: 2,
    isOverflow: false,
    gaugeName: 'Cash',
    title: 'Banqueroute Criminelle',
    description:
        'Banqueroute totale. Incapable de payer vos guetteurs ni vos dettes d\'approvisionnement, les tueurs à gages du cartel viennent saisir votre vie.',
    hint: 'Tombez à sec sans le moindre centime pour payer vos guetteurs.',
  ),
  DeathEntry(
    id: 'ST_D2_MAX',
    campaign: CampaignType.street,
    reason: GameOverReason.gauge2Overflow,
    gaugeIndex: 2,
    isOverflow: true,
    gaugeName: 'Cash',
    title: 'La Fosse aux Vipères',
    description:
        'Votre fortune colossale suscite une convoitise aveugle. Vos lieutenants les plus proches vous empoisonnent pour s\'emparer de vos coffres.',
    hint: 'Entassez des coffres pleins à craquer qui réveilleront la cupidité des vôtres.',
  ),
  DeathEntry(
    id: 'ST_D3_MIN',
    campaign: CampaignType.street,
    reason: GameOverReason.gauge3Depleted,
    gaugeIndex: 3,
    isOverflow: false,
    gaugeName: 'Club',
    title: 'Bannissement du Velvet',
    description:
        'Trop discret et inactif, vous perdez le contrôle de la rue. Des gangs opportunistes s\'emparent de vos territoires sans résistance.',
    hint: 'Négligez totalement votre emprise et votre présence au Velvet Lounge.',
  ),
  DeathEntry(
    id: 'ST_D3_MAX',
    campaign: CampaignType.street,
    reason: GameOverReason.gauge3Overflow,
    gaugeIndex: 3,
    isOverflow: true,
    gaugeName: 'Club',
    title: 'Raid Fédéral',
    description:
        'L\'indice de recherche atteint un seuil critique. Le SWAT et les forces fédérales encerclent votre refuge et donnent l\'assaut sans sommation.',
    hint: 'Embrasez le club jusqu\'à déclencher l\'intervention armée du SWAT.',
  ),
  DeathEntry(
    id: 'ST_D4_MIN',
    campaign: CampaignType.street,
    reason: GameOverReason.gauge4Depleted,
    gaugeIndex: 4,
    isOverflow: false,
    gaugeName: 'Discrétion',
    title: 'Trahison Absolue',
    description:
        'Trahison absolue. Abandonné par tous vos fidèles qui refusent de mourir pour vous, vos ennemis n\'ont plus qu\'à venir vous cueillir.',
    hint: 'Laissez votre discrétion s\'effondrer et exposez-vous aux représailles.',
  ),
  DeathEntry(
    id: 'ST_D4_MAX',
    campaign: CampaignType.street,
    reason: GameOverReason.gauge4Overflow,
    gaugeIndex: 4,
    isOverflow: true,
    gaugeName: 'Discrétion',
    title: 'Purge Fratricide',
    description:
        'Le fanatisme de votre clan échappe à tout contrôle. Une purge fratricide éclate et vous mourez sous les balles de vos propres hommes.',
    hint: 'Poussez le culte du secret jusqu\'au fanatisme interne sanglant.',
  ),
];

const List<DeathEntry> canonicalEmpireDeaths = [
  DeathEntry(
    id: 'EM_D1_MIN',
    campaign: CampaignType.empire,
    reason: GameOverReason.gauge1Depleted,
    gaugeIndex: 1,
    isOverflow: false,
    gaugeName: 'Prestige',
    title: 'Destitution Royale',
    description:
        'Destitution royale. La cour impériale et le Sénat votent votre déchéance et vous condamnent à finir vos jours dans les cachots de la forteresse.',
    hint: 'Laissez le prestige dynastique s\'effondrer devant la cour impériale.',
  ),
  DeathEntry(
    id: 'EM_D1_MAX',
    campaign: CampaignType.empire,
    reason: GameOverReason.gauge1Overflow,
    gaugeIndex: 1,
    isOverflow: true,
    gaugeName: 'Prestige',
    title: 'Le Poignard des Pairs',
    description:
        'Votre emprise tyrannique terrifie l\'aristocratie. Une conspiration de ministres vous encercle et vous poignarde au cœur de la salle du trône.',
    hint: 'Impressionnez tellement l\'aristocratie par votre tyrannie qu\'elle ourdit un régicide.',
  ),
  DeathEntry(
    id: 'EM_D2_MIN',
    campaign: CampaignType.empire,
    reason: GameOverReason.gauge2Depleted,
    gaugeIndex: 2,
    isOverflow: false,
    gaugeName: 'Blanchiment',
    title: 'Coffres Vides & Mutinerie',
    description:
        'Les caisses impériales sont à sec. Les mercenaires royaux impayés se mutinent, mettent la capitale à sac et pillent le palais.',
    hint: 'Épuisez les caisses de blanchiment au point de ne plus solder la garde.',
  ),
  DeathEntry(
    id: 'EM_D2_MAX',
    campaign: CampaignType.empire,
    reason: GameOverReason.gauge2Overflow,
    gaugeIndex: 2,
    isOverflow: true,
    gaugeName: 'Blanchiment',
    title: 'L\'Or Empoisonné',
    description:
        'L\'opulence excessive plonge la cour dans la décadence. Des barons avides s\'unissent pour vous assassiner et se partager le trésor impérial.',
    hint: 'Accumulez des avoirs offshore gargantuesques excitant la cupidité des barons.',
  ),
  DeathEntry(
    id: 'EM_D3_MIN',
    campaign: CampaignType.empire,
    reason: GameOverReason.gauge3Depleted,
    gaugeIndex: 3,
    isOverflow: false,
    gaugeName: 'Impunité',
    title: 'Débâcle des Légions',
    description:
        'L\'armée capitule et la garde royale déserte. Les légions ennemies franchissent les remparts de la cité sans la moindre résistance.',
    hint: 'Laissez votre immunité et vos boucliers judiciaires tomber à zéro.',
  ),
  DeathEntry(
    id: 'EM_D3_MAX',
    campaign: CampaignType.empire,
    reason: GameOverReason.gauge3Overflow,
    gaugeIndex: 3,
    isOverflow: true,
    gaugeName: 'Impunité',
    title: 'Coup d\'État Martial',
    description:
        'La junte militaire s\'empare du pouvoir absolu. Le grand maréchal mène un coup d\'État sanglant et s\'autoproclame empereur sur votre trône.',
    hint: 'Défiez ouvertement la loi jusqu\'à ce que l\'armée prenne le pouvoir par la force.',
  ),
  DeathEntry(
    id: 'EM_D4_MIN',
    campaign: CampaignType.empire,
    reason: GameOverReason.gauge4Depleted,
    gaugeIndex: 4,
    isOverflow: false,
    gaugeName: 'Clan',
    title: 'Le Couperet Populaire',
    description:
        'Insurrection populaire massive. La foule enragée force les grilles du domaine impérial et traîne la dynastie sous le couperet.',
    hint: 'Aliénez totalement le clan et le peuple jusqu\'à l\'insurrection finale.',
  ),
  DeathEntry(
    id: 'EM_D4_MAX',
    campaign: CampaignType.empire,
    reason: GameOverReason.gauge4Overflow,
    gaugeIndex: 4,
    isOverflow: true,
    gaugeName: 'Clan',
    title: 'Dévotion Fanatique',
    description:
        'La dévotion populaire vire au fanatisme mystique hystérique. Une marée humaine déferle dans vos quartiers et vous étouffe dans sa ferveur.',
    hint: 'Exaltez le fanatisme du clan jusqu\'à vous faire dévorer par sa dévotion aveugle.',
  ),
];

const List<DeathEntry> canonicalDeathEntries = [
  ...canonicalStreetDeaths,
  ...canonicalEmpireDeaths,
];

// ==========================================
// Canonical Story Achievements (8 Street, 8 Empire)
// ==========================================

const List<StoryAchievement> canonicalStreetAchievements = [
  StoryAchievement(
    id: 'ACH_ST_FOYER',
    campaign: CampaignType.street,
    flag: 'expulsee_du_foyer',
    title: 'L\'Exil du Foyer',
    description:
        'Expulsée sans ménagement par votre mère, vous jurez de dominer la nuit.',
    hint: 'Affrontez le conflit familial initial de Kimmie.',
  ),
  StoryAchievement(
    id: 'ACH_ST_DANSE',
    campaign: CampaignType.street,
    flag: 'danseuse_active',
    title: 'L\'Arène du Velvet',
    description:
        'Enfilez la tenue de scène et imposez votre aura sur la piste principale.',
    hint: 'Acceptez les projecteurs du Velvet Lounge.',
  ),
  StoryAchievement(
    id: 'ACH_ST_CLE',
    campaign: CampaignType.street,
    flag: 'kimmie_a_la_cle',
    title: 'Clé des Bell Dérobée',
    description:
        'Vous avez dérobé la clé USB contenant tous les secrets de la famille Bell.',
    hint: 'Mettez la main sur la clé de données compromises de Jules Bell.',
  ),
  StoryAchievement(
    id: 'ACH_ST_ALLIANCE',
    campaign: CampaignType.street,
    flag: 'alliance_rain',
    title: 'Pacte des Épines',
    description:
        'Transformez votre rivale Rain en une alliée de circonstance déterminée.',
    hint: 'Concluez un pacte d\'honneur avec Rain.',
  ),
  StoryAchievement(
    id: 'ACH_ST_INCENDIE',
    campaign: CampaignType.street,
    flag: 'club_incendie',
    title: 'Incendie du Velvet',
    description:
        'Le sanctuaire nocturne part en fumée lors du grand affrontement avec les Bell.',
    hint: 'Survivez à la nuit d\'embrasement du Velvet Lounge.',
  ),
  StoryAchievement(
    id: 'ACH_ST_ROY',
    campaign: CampaignType.street,
    flag: 'roy_neutralise',
    title: 'Chute de la Bête',
    description:
        'Le molosse violent des Bell est terrassé avant de faire plus de victimes.',
    hint: 'Neutralisez Roy Bell lors de la fusillade.',
  ),
  StoryAchievement(
    id: 'ACH_ST_JUSTICE',
    campaign: CampaignType.street,
    flag: 'horace_ecroue',
    title: 'Le Patriarche Écroué',
    description:
        'Horace Bell est traîné devant le grand jury fédéral grâce à vos révélations.',
    hint: 'Fournissez les preuves accablantes à l\'inspecteur Davis.',
  ),
  StoryAchievement(
    id: 'ACH_ST_REINE',
    campaign: CampaignType.street,
    flag: 'reine_de_la_nuit',
    title: 'Reine de la Nuit',
    description:
        'Kimmie prend le trône de l\'underworld et règne sans partage sur la nuit.',
    hint: 'Couronnez votre destin nocturne au terme de l\'épilogue.',
  ),
];

const List<StoryAchievement> canonicalEmpireAchievements = [
  StoryAchievement(
    id: 'ACH_EM_CHASSE',
    campaign: CampaignType.empire,
    flag: 'chasse_a_la_cle',
    title: 'La Traque Féroce',
    description:
        'Déclenchez la traque impitoyable de la serveuse détenant les secrets Bell.',
    hint: 'Lancez vos limiers aux trousses de la voleuse de données.',
  ),
  StoryAchievement(
    id: 'ACH_EM_CREME',
    campaign: CampaignType.empire,
    flag: 'creme_toxique_etouffee',
    title: 'Omerta Industrielle',
    description:
        'Le scandale sanitaire de la gamme cosmétique Bell est enterré à tout jamais.',
    hint: 'Étouffez le scandale sanitaire des laboratoires Bell.',
  ),
  StoryAchievement(
    id: 'ACH_EM_SALAZAR',
    campaign: CampaignType.empire,
    flag: 'salazar_elimine',
    title: 'L\'Élimination du Cartel',
    description:
        'Salazar est neutralisé, laissant le cartel Bell sans concurrent sérieux.',
    hint: 'Éliminez Salazar sans compromettre l\'empire.',
  ),
  StoryAchievement(
    id: 'ACH_EM_HOLDING',
    campaign: CampaignType.empire,
    flag: 'nouvelle_holding',
    title: 'Refonte Financière',
    description:
        'Création d\'une holding offshore aux îles Caïmans pour immuniser la fortune.',
    hint: 'Restructurez les flux de capitaux vers les paradis fiscaux.',
  ),
  StoryAchievement(
    id: 'ACH_EM_RASE',
    campaign: CampaignType.empire,
    flag: 'velvet_rase',
    title: 'Cendres & Renaissances',
    description:
        'Le Velvet Lounge est rasé pour ériger la future Tour Bell au cœur de la ville.',
    hint: 'Détruisez le Velvet Lounge au bulldozer pour votre projet immobilier.',
  ),
  StoryAchievement(
    id: 'ACH_EM_DESTITUTION',
    campaign: CampaignType.empire,
    flag: 'horace_destitue',
    title: 'Le Trône Conquis',
    description:
        'Horace Bell est poussé vers la sortie, Mallory prend seule les rênes de l\'empire.',
    hint: 'Évincez Horace du conseil d\'administration.',
  ),
  StoryAchievement(
    id: 'ACH_EM_REGNE',
    campaign: CampaignType.empire,
    flag: 'regne_absolu',
    title: 'Règne Absolu',
    description:
        'Tous les contre-pouvoirs sont pliés : police, juges et rivaux obéissent.',
    hint: 'Verrouillez le pouvoir judiciaire et policier suprême.',
  ),
  StoryAchievement(
    id: 'ACH_EM_DYNASTIE',
    campaign: CampaignType.empire,
    flag: 'dynastie_eternelle',
    title: 'Dynastie Éternelle',
    description:
        'L\'Empire Bell devient un mythe souverain et intouchable pour l\'éternité.',
    hint: 'Scellez l\'hégémonie immortelle de la dynastie Bell.',
  ),
];

const List<StoryAchievement> canonicalStoryAchievements = [
  ...canonicalStreetAchievements,
  ...canonicalEmpireAchievements,
];
