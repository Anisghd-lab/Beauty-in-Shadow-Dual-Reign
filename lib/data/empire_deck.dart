import '../models/card_model.dart';

/// The calibrated complete narrative card deck for Mallory Bell in the Royal Empire campaign (EM_001 to EM_050).
///
/// Gauges:
/// - Gauge 1: Prestige (Image publique de luxe, réputation aristocratique)
/// - Gauge 2: Blanchiment (Volume des flux financiers clandestins intégrés)
/// - Gauge 3: Impunité (Bouclier judiciaire, corruption de l'État et des médias)
/// - Gauge 4: Clan (Unité dynastique, respect du patriarche et des frères Bell)
///
/// Narrative Arcs across 5 Chapters:
/// - Ch. 1 (EM_001-EM_010): Le Trône de Marbre & L'Argent Sale.
/// - Ch. 2 (EM_011-EM_020): Gestion de Crise & Bad Buzz.
/// - Ch. 3 (EM_021-EM_030): Trahison Interne & Racket des Cartels.
/// - Ch. 4 (EM_031-EM_040): La Guerre Judiciaire & Le Démantèlement.
/// - Ch. 5 (EM_041-EM_050): L'Hégémonie Absolue & Le Triomphe.
final List<GameCard> initialEmpireDeck = [
  // =========================================================================
  // CHAPTER 1: Le Trône de Marbre & L'Argent Sale (EM_001 - EM_010)
  // =========================================================================

  // EM_001: Directeur Financier (audit des capitaux sales de départ)
  const GameCard(
    id: 'EM_001',
    campaign: 'EMPIRE',
    speakerName: 'Directeur Financier',
    speakerRole: 'Cabinet d\'audit Bell',
    speakerAvatar: 'assets/images/characters/empire/cfo.png',
    dialogue:
        'Madame Bell, les fonds de départ proviennent de sociétés écrans des clubs de nuit. Les inspecteurs du fisc demandent les livres de comptes originaux.',
    leftChoice: ChoiceImpact(
      text: 'Créer des filiales',
      deltaGauge1: -10,
      deltaGauge2: 15,
      deltaGauge3: -15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Payer l\'amende',
      deltaGauge1: 10,
      deltaGauge2: -15,
      deltaGauge3: 10,
    ),
  ),

  // EM_002: Horace Bell (injection de 2M en cash des clubs)
  const GameCard(
    id: 'EM_002',
    campaign: 'EMPIRE',
    speakerName: 'Horace Bell',
    speakerRole: 'Patriarche de la dynastie',
    speakerAvatar: 'assets/images/characters/empire/horace.png',
    dialogue:
        'Nos clubs de strip-tease ont dégagé deux millions de dollars non déclarés ce mois-ci. Injecte-les sans délai dans le budget cosmétique.',
    leftChoice: ChoiceImpact(
      text: 'Injecter le cash',
      deltaGauge2: 15,
      deltaGauge3: -10,
      deltaGauge4: 10,
      setFlags: ['cash_injecte'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Refuser l\'argent',
      deltaGauge1: 10,
      deltaGauge2: -10,
      deltaGauge4: -10,
    ),
  ),

  // EM_003: Chimiste en Chef (crème toxique inflammable)
  const GameCard(
    id: 'EM_003',
    campaign: 'EMPIRE',
    speakerName: 'Chimiste en Chef',
    speakerRole: 'Laboratoire R&D Bell',
    speakerAvatar: 'assets/images/characters/empire/chemist.png',
    dialogue:
        'La nouvelle formule de notre crème miracle est instable et hautement inflammable au contact de l\'air. Trois laborantins ont été gravement brûlés ce matin !',
    leftChoice: ChoiceImpact(
      text: 'Étouffer l\'affaire',
      deltaGauge1: -15,
      deltaGauge3: -10,
      deltaGauge4: 15,
      setFlags: ['creme_toxique_etouffee'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Rappeler les lots',
      deltaGauge1: 10,
      deltaGauge2: -15,
      deltaGauge4: -15,
    ),
  ),

  // EM_004: Roy Bell (passage à tabac d'un journaliste)
  const GameCard(
    id: 'EM_004',
    campaign: 'EMPIRE',
    speakerName: 'Roy Bell',
    speakerRole: 'Frère aîné & Bras armé',
    speakerAvatar: 'assets/images/characters/empire/roy.png',
    dialogue:
        'Un fouineur du Daily News prenait des photos de nos quais de livraison maritime. Je lui ai brisé les deux genoux dans un parking.',
    leftChoice: ChoiceImpact(
      text: 'Couvrir ses arrières',
      deltaGauge1: -10,
      deltaGauge3: -15,
      deltaGauge4: 15,
      setFlags: ['roy_couvert'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Le livrer aux flics',
      deltaGauge1: 10,
      deltaGauge3: 10,
      deltaGauge4: -15,
    ),
  ),

  // EM_005: Interview TV en direct (arrogance vs victime)
  const GameCard(
    id: 'EM_005',
    campaign: 'EMPIRE',
    speakerName: 'Journaliste TV',
    speakerRole: 'Édition spéciale en direct',
    speakerAvatar: 'assets/images/characters/empire/tv_anchor.png',
    dialogue:
        'Madame Bell, des fuites anonymes affirment que Bell Cosmetics n\'est qu\'une gigantesque machine à blanchir pour la pègre locale. Que répondez-vous ?',
    leftChoice: ChoiceImpact(
      text: 'Arrogance glaciale',
      deltaGauge1: -10,
      deltaGauge3: 10,
      deltaGauge4: 15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Jouer la victime',
      deltaGauge1: 10,
      deltaGauge3: -10,
      deltaGauge4: -10,
    ),
  ),

  // EM_006: Procureur Miller (pot-de-vin pour suspendre un mandat)
  const GameCard(
    id: 'EM_006',
    campaign: 'EMPIRE',
    speakerName: 'Procureur Miller',
    speakerRole: 'Palais de Justice',
    speakerAvatar: 'assets/images/characters/empire/prosecutor_miller.png',
    dialogue:
        'Un mandat fédéral vise vos entrepôts de transit portuaire. Ma campagne de réélection a un besoin urgent d\'un demi-million en dons discrets.',
    leftChoice: ChoiceImpact(
      text: 'Acheter le magistrat',
      deltaGauge2: -15,
      deltaGauge3: 10,
      deltaGauge4: 5,
      setFlags: ['procureur_achete'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Chantage familial',
      deltaGauge1: -10,
      deltaGauge3: -15,
      deltaGauge4: 15,
    ),
  ),

  // EM_007: Le Gérant du Club (fronde menée par Kimmie)
  const GameCard(
    id: 'EM_007',
    campaign: 'EMPIRE',
    speakerName: 'Le Gérant du Club',
    speakerRole: 'Émissaire du Velvet Lounge',
    speakerAvatar: 'assets/images/characters/empire/club_delegate.png',
    dialogue:
        'Madame, une employée nommée Kimmie mène une fronde parmi les danseuses du Velvet Lounge. Les transferts d\'argent liquide vers vos comptes sont totalement bloqués !',
    leftChoice: ChoiceImpact(
      text: 'Envoyer les gros bras',
      deltaGauge1: -15,
      deltaGauge2: 10,
      deltaGauge4: 15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Négocier en secret',
      deltaGauge1: 10,
      deltaGauge2: -15,
      deltaGauge4: -10,
    ),
  ),

  // EM_008: Jules Bell (tamponner un conteneur suspect)
  const GameCard(
    id: 'EM_008',
    campaign: 'EMPIRE',
    speakerName: 'Jules Bell',
    speakerRole: 'Frère cadet & Logistique',
    speakerAvatar: 'assets/images/characters/empire/jules.png',
    dialogue:
        'Un cargo chargé de précurseurs chimiques non déclarés est retenu par les douanes du port autonome. Signe l\'autorisation présidentielle prioritaire.',
    leftChoice: ChoiceImpact(
      text: 'Signer l\'ordre',
      deltaGauge2: 10,
      deltaGauge3: -10,
      deltaGauge4: 15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Bloquer le cargo',
      deltaGauge1: 10,
      deltaGauge2: -10,
      deltaGauge4: -10,
    ),
  ),

  // EM_009: Horace Bell (exigence de céder des parts aux fils)
  const GameCard(
    id: 'EM_009',
    campaign: 'EMPIRE',
    speakerName: 'Horace Bell',
    speakerRole: 'Patriarche de la dynastie',
    speakerAvatar: 'assets/images/characters/empire/horace.png',
    dialogue:
        'Tu as bien travaillé, Mallory. Mais Bell Cosmetics doit demeurer sous le contrôle de la descendance mâle. Cède 40% de tes actions à tes deux frères.',
    leftChoice: ChoiceImpact(
      text: 'Céder les parts',
      deltaGauge1: -10,
      deltaGauge2: -15,
      deltaGauge4: 15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Verrouiller statuts',
      deltaGauge1: 10,
      deltaGauge3: 10,
      deltaGauge4: -15,
    ),
  ),

  // EM_010: Raid fiscal fédéral (effacement magnétique vs accueil légal)
  const GameCard(
    id: 'EM_010',
    campaign: 'EMPIRE',
    speakerName: 'Raid fiscal fédéral',
    speakerRole: 'Agents IRS & Fédéraux',
    speakerAvatar: 'assets/images/characters/empire/federal_raid.png',
    dialogue:
        'Agents fédéraux ! Tous les serveurs informatiques et disques durs de Bell Cosmetics sont saisis sous mandat judiciaire immédiat.',
    leftChoice: ChoiceImpact(
      text: 'Effacement magnétique',
      deltaGauge1: -15,
      deltaGauge2: 10,
      deltaGauge3: -15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Assaut d\'avocats',
      deltaGauge1: 10,
      deltaGauge2: -15,
      deltaGauge3: 10,
    ),
  ),

  // =========================================================================
  // CHAPTER 2: Gestion de Crise & Bad Buzz (EM_011 - EM_020)
  // =========================================================================

  // EM_011: Roy Bell (Retour ensanglanté du Velvet Lounge)
  const GameCard(
    id: 'EM_011',
    campaign: 'EMPIRE',
    speakerName: 'Roy Bell',
    speakerRole: 'Frère aîné incontrôlable',
    speakerAvatar: 'assets/images/characters/empire/roy_bloody.png',
    dialogue:
        'Mallory, cette traînée de Kimmie m\'a subtilisé la clé USB dorée au club. Fais boucler le quartier avant que la presse ne la récupère !',
    leftChoice: ChoiceImpact(
      text: 'Boucler le quartier',
      deltaGauge1: -15,
      deltaGauge2: 10,
      deltaGauge3: -10,
      deltaGauge4: 15,
      setFlags: ['chasse_a_la_cle'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Sévir contre Roy',
      deltaGauge1: 10,
      deltaGauge2: -10,
      deltaGauge3: 10,
      deltaGauge4: -15,
    ),
  ),

  // EM_012: Rain (Chantage par messagerie chiffrée)
  const GameCard(
    id: 'EM_012',
    campaign: 'EMPIRE',
    speakerName: 'Rain',
    speakerRole: 'Danseuse maîtresse-chanteuse',
    speakerAvatar: 'assets/images/characters/empire/rain_blackmail.png',
    dialogue:
        'Mme Bell, je sais exactement ce que contient la clé de Roy. 200 000\$ sur mon compte suisse ou j\'envoie la formule aux journalistes du Times.',
    leftChoice: ChoiceImpact(
      text: 'Payer la rançon',
      deltaGauge1: -10,
      deltaGauge2: -15,
      deltaGauge3: 10,
      deltaGauge4: 15,
      setFlags: ['rain_achetee'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Lui envoyer Silas',
      deltaGauge1: -10,
      deltaGauge2: 15,
      deltaGauge3: -15,
      deltaGauge4: 10,
      setFlags: ['silas_depeche'],
    ),
  ),

  // EM_013: Directrice Marketing (Bad buzz sur les cosmétiques)
  const GameCard(
    id: 'EM_013',
    campaign: 'EMPIRE',
    speakerName: 'Directrice Marketing',
    speakerRole: 'Gestion de crise réputationnelle',
    speakerAvatar: 'assets/images/characters/empire/pr_director.png',
    dialogue:
        'Des influenceurs dénoncent des brûlures chimiques après l\'essai du sérum Bell Éclat. Le mot-clé #PoisonBell explose sur les réseaux !',
    leftChoice: ChoiceImpact(
      text: 'Inonder de cadeaux VIP',
      deltaGauge1: 10,
      deltaGauge2: -10,
      deltaGauge3: 10,
      deltaGauge4: -10,
    ),
    rightChoice: ChoiceImpact(
      text: 'Attaquer en diffamation',
      deltaGauge1: -10,
      deltaGauge2: 10,
      deltaGauge3: 10,
      deltaGauge4: 15,
    ),
  ),

  // EM_014: Commissaire de District (Pot-de-vin d'éloignement)
  const GameCard(
    id: 'EM_014',
    campaign: 'EMPIRE',
    speakerName: 'Commissaire de District',
    speakerRole: 'Haut fonctionnaire stipendié',
    speakerAvatar: 'assets/images/characters/empire/police_commissioner.png',
    dialogue:
        'Le détective Davis a réuni des preuves accablantes sur vos filiales maritimes. Pour un demi-million, je le mute à trois cents kilomètres.',
    leftChoice: ChoiceImpact(
      text: 'Financer la mutation',
      deltaGauge1: -10,
      deltaGauge2: -15,
      deltaGauge3: 10,
      deltaGauge4: 15,
      setFlags: ['davis_mute'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Le discréditer publiquement',
      deltaGauge1: 10,
      deltaGauge2: 10,
      deltaGauge3: -15,
      deltaGauge4: -15,
    ),
  ),

  // EM_015: Jules Bell (Panique aux entrepôts portuaires)
  const GameCard(
    id: 'EM_015',
    campaign: 'EMPIRE',
    speakerName: 'Jules Bell',
    speakerRole: 'Frère cadet terrorisé',
    speakerAvatar: 'assets/images/characters/empire/jules_scared.png',
    dialogue:
        'Les douanes fouillent nos cuves de stockage au port ! Si j\'ouvre les vannes, 500 000 litres d\'alcool frelaté s\'écoulent dans la baie !',
    leftChoice: ChoiceImpact(
      text: 'Vider dans la baie',
      deltaGauge1: -15,
      deltaGauge2: 15,
      deltaGauge3: -10,
      deltaGauge4: 10,
      setFlags: ['pollution_port'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Subir la saisie',
      deltaGauge1: 10,
      deltaGauge2: -15,
      deltaGauge3: 10,
      deltaGauge4: -10,
    ),
  ),

  // EM_016: Conseil d'Administration (Motion de défiance)
  const GameCard(
    id: 'EM_016',
    campaign: 'EMPIRE',
    speakerName: 'Conseil d\'Administration',
    speakerRole: 'Actionnaires historiques',
    speakerAvatar: 'assets/images/characters/empire/board_members.png',
    dialogue:
        'L\'action Bell plonge de 18% ce matin. Horace Bell demande votre révocation immédiate au profit de son fils Jules !',
    leftChoice: ChoiceImpact(
      text: 'Purger les mutins',
      deltaGauge1: 10,
      deltaGauge2: -15,
      deltaGauge3: 10,
      deltaGauge4: -15,
      setFlags: ['purge_actionnaires'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Distribuer des bonus',
      deltaGauge1: -15,
      deltaGauge2: 15,
      deltaGauge3: -10,
      deltaGauge4: 10,
    ),
  ),

  // EM_017: Banquier Privé Suisse (Gel des comptes)
  const GameCard(
    id: 'EM_017',
    campaign: 'EMPIRE',
    speakerName: 'Banquier Suisse',
    speakerRole: 'Gestionnaire de trust Zurich',
    speakerAvatar: 'assets/images/characters/empire/swiss_banker.png',
    dialogue:
        'Les autorités américaines demandent le blocage préventif de vos comptes à Zurich. Nous pouvons transférer 30 millions aux Caïmans avant minuit.',
    leftChoice: ChoiceImpact(
      text: 'Virer vers les îles',
      deltaGauge1: -15,
      deltaGauge2: 15,
      deltaGauge3: -10,
      deltaGauge4: 10,
      setFlags: ['fonds_caimans'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Bloquer et négocier',
      deltaGauge1: 10,
      deltaGauge2: -15,
      deltaGauge3: 10,
      deltaGauge4: -15,
    ),
  ),

  // EM_018: Horace Bell (Accident cardiaque simulé)
  const GameCard(
    id: 'EM_018',
    campaign: 'EMPIRE',
    speakerName: 'Horace Bell',
    speakerRole: 'Patriarche manipulateur',
    speakerAvatar: 'assets/images/characters/empire/horace_hospital.png',
    dialogue:
        'Mon cœur vacille, Mallory... Si tu respectes cette dynastie, cède immédiatement la gérance des filiales de nuit à tes frères sur mon lit d\'hôpital.',
    leftChoice: ChoiceImpact(
      text: 'Signer par devoir',
      deltaGauge1: -10,
      deltaGauge2: 10,
      deltaGauge3: -15,
      deltaGauge4: 15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Refuser net',
      deltaGauge1: 10,
      deltaGauge2: -10,
      deltaGauge3: 10,
      deltaGauge4: -15,
      setFlags: ['rupture_horace'],
    ),
  ),

  // EM_019: Journaliste d'investigation (Dossier explosif)
  const GameCard(
    id: 'EM_019',
    campaign: 'EMPIRE',
    speakerName: 'Journaliste du Times',
    speakerRole: 'Presse métropolitaine',
    speakerAvatar: 'assets/images/characters/empire/investigative_reporter.png',
    dialogue:
        'Madame Bell, j\'ai obtenu les bordereaux de commande originaux des composants toxiques. Une interview exclusive ou mon papier paraît demain.',
    leftChoice: ChoiceImpact(
      text: 'Racheter le journal',
      deltaGauge1: 10,
      deltaGauge2: -15,
      deltaGauge3: 10,
      deltaGauge4: 10,
      setFlags: ['journal_achete'],
    ),
    rightChoice: ChoiceImpact(
      text: 'L\'intimider au manoir',
      deltaGauge1: -15,
      deltaGauge2: 15,
      deltaGauge3: -10,
      deltaGauge4: 10,
    ),
  ),

  // EM_020: Alerte incendie au Velvet Lounge
  const GameCard(
    id: 'EM_020',
    campaign: 'EMPIRE',
    speakerName: 'Ligne d\'urgence',
    speakerRole: 'Poste de commandement Bell',
    speakerAvatar: 'assets/images/characters/empire/crisis_hotline.png',
    dialogue:
        'Madame ! Roy a incendié le Velvet Lounge dans une rage aveugle ! Des explosions retentissent et les télévisions diffusent les images en direct !',
    leftChoice: ChoiceImpact(
      text: 'Dénoncer un attentat',
      deltaGauge1: 10,
      deltaGauge2: -10,
      deltaGauge3: 10,
      deltaGauge4: -15,
      setFlags: ['incendie_maquille'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Couvrir les dégâts',
      deltaGauge1: -15,
      deltaGauge2: 10,
      deltaGauge3: -15,
      deltaGauge4: 15,
    ),
  ),

  // =========================================================================
  // CHAPTER 3: Trahison Interne & Racket des Cartels (EM_021 - EM_030)
  // =========================================================================

  // EM_021: Don Salazar (Visite inopinée au manoir)
  const GameCard(
    id: 'EM_021',
    campaign: 'EMPIRE',
    speakerName: 'Don Salazar',
    speakerRole: 'Parrain du Cartel Sud',
    speakerAvatar: 'assets/images/characters/empire/salazar.png',
    dialogue:
        'Le brasier de vos clubs a consumé huit millions de notre marchandise entreposée en sous-sol. Payez en liquide ou vos cargos ne passeront plus.',
    leftChoice: ChoiceImpact(
      text: 'Payer le tribut',
      deltaGauge1: -20,
      deltaGauge2: 20,
      deltaGauge3: -15,
      deltaGauge4: 15,
      setFlags: ['tribut_salazar'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Menacer du FBI',
      deltaGauge1: 20,
      deltaGauge2: -20,
      deltaGauge3: 20,
      deltaGauge4: -20,
    ),
  ),

  // EM_022: Maître d'Hôtel Silas (Tentative d'empoisonnement)
  const GameCard(
    id: 'EM_022',
    campaign: 'EMPIRE',
    speakerName: 'Silas',
    speakerRole: 'Chef de sécurité du manoir',
    speakerAvatar: 'assets/images/characters/empire/silas.png',
    dialogue:
        'Madame, nous avons détecté de la strychnine dans votre carafe de digestif. Les flacons proviennent de la suite privée de votre frère Roy.',
    leftChoice: ChoiceImpact(
      text: 'Faire embastiller Roy',
      deltaGauge1: 15,
      deltaGauge2: -10,
      deltaGauge3: 20,
      deltaGauge4: -20,
      setFlags: ['roy_enferme'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Étouffer l\'affaire',
      deltaGauge1: -15,
      deltaGauge2: 15,
      deltaGauge3: -20,
      deltaGauge4: 20,
    ),
  ),

  // EM_023: Roy Bell (En cavale armée)
  const GameCard(
    id: 'EM_023',
    campaign: 'EMPIRE',
    speakerName: 'Roy Bell',
    speakerRole: 'Frère paria traqué',
    speakerAvatar: 'assets/images/characters/empire/roy_fugitive.png',
    dialogue:
        'Tu m\'as déchu de mon héritage, Mallory ! Je vends la liste de nos clients corrompus au procureur si tu ne me verses pas cinq millions d\'or !',
    leftChoice: ChoiceImpact(
      text: 'Négocier sa reddition',
      deltaGauge1: -10,
      deltaGauge2: -20,
      deltaGauge3: 15,
      deltaGauge4: 20,
    ),
    rightChoice: ChoiceImpact(
      text: 'Lâcher les tueurs',
      deltaGauge1: -20,
      deltaGauge2: 20,
      deltaGauge3: -20,
      deltaGauge4: 20,
      setFlags: ['traque_roy'],
    ),
  ),

  // EM_024: Juge Vandermeer (Dîner d'influence)
  const GameCard(
    id: 'EM_024',
    campaign: 'EMPIRE',
    speakerName: 'Juge Vandermeer',
    speakerRole: 'Haute Cour de Justice',
    speakerAvatar: 'assets/images/characters/empire/judge_vandermeer.png',
    dialogue:
        'Le dossier d\'extorsion de Bell arrive dans ma chambre. Pour déclarer un non-lieu immédiat, ma fondation réclame une donation substantielle.',
    leftChoice: ChoiceImpact(
      text: 'Subventionner le juge',
      deltaGauge1: 15,
      deltaGauge2: -20,
      deltaGauge3: 15,
      deltaGauge4: -10,
      setFlags: ['juge_acquis'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Dossier de chantage',
      deltaGauge1: -15,
      deltaGauge2: 10,
      deltaGauge3: -20,
      deltaGauge4: 20,
    ),
  ),

  // EM_025: Jules Bell (Trahison sous écoute)
  const GameCard(
    id: 'EM_025',
    campaign: 'EMPIRE',
    speakerName: 'Jules Bell',
    speakerRole: 'Maillon faible des Bell',
    speakerAvatar: 'assets/images/characters/empire/jules_wire.png',
    dialogue:
        'Jules portait un émetteur fédéral sous sa doublure de costume. Il a déjà divulgué les numéros des conteneurs suspects aux agents du FBI !',
    leftChoice: ChoiceImpact(
      text: 'L\'exiler sous escorte',
      deltaGauge1: 15,
      deltaGauge2: -15,
      deltaGauge3: 15,
      deltaGauge4: -15,
      setFlags: ['jules_exile'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Reprogrammer le réseau',
      deltaGauge1: -10,
      deltaGauge2: 20,
      deltaGauge3: -15,
      deltaGauge4: 10,
    ),
  ),

  // EM_026: Détective Davis (Perquisition au siège Bell)
  const GameCard(
    id: 'EM_026',
    campaign: 'EMPIRE',
    speakerName: 'Détective Davis',
    speakerRole: 'Enquêteur incorruptible',
    speakerAvatar: 'assets/images/characters/empire/detective_davis.png',
    dialogue:
        'Madame Bell, Kimmie nous a remis les doubles des registres bancaires du club. Vous disposez de 48 heures avant votre mise en examen.',
    leftChoice: ChoiceImpact(
      text: 'Riposte judiciaire',
      deltaGauge1: 20,
      deltaGauge2: -10,
      deltaGauge3: 15,
      deltaGauge4: -15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Négocier un compromis',
      deltaGauge1: -20,
      deltaGauge2: 20,
      deltaGauge3: -20,
      deltaGauge4: 15,
    ),
  ),

  // EM_027: L'Archiviste du Clan (Secrets du patriarche)
  const GameCard(
    id: 'EM_027',
    campaign: 'EMPIRE',
    speakerName: 'L\'Archiviste',
    speakerRole: 'Mémoire secrète du Clan',
    speakerAvatar: 'assets/images/characters/empire/clan_archivist.png',
    dialogue:
        'Les titres de propriété d\'origine et les preuves des premiers forfaits d\'Horace reposent dans cette cassette blindée en titane.',
    leftChoice: ChoiceImpact(
      text: 'Brûler les archives',
      deltaGauge1: 15,
      deltaGauge2: 15,
      deltaGauge3: 20,
      deltaGauge4: -15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Garder pour pression',
      deltaGauge1: -15,
      deltaGauge2: -10,
      deltaGauge3: -15,
      deltaGauge4: 20,
      setFlags: ['dossiers_horace'],
    ),
  ),

  // EM_028: Agence de notation financière (Alerte spéculative)
  const GameCard(
    id: 'EM_028',
    campaign: 'EMPIRE',
    speakerName: 'Analyste Financier',
    speakerRole: 'Wall Street',
    speakerAvatar: 'assets/images/characters/empire/wall_street.png',
    dialogue:
        'Sans certification immédiate des comptes, la note d\'endettement de Bell Cosmetics s\'effondre au statut d\'obligation pourrie.',
    leftChoice: ChoiceImpact(
      text: 'Injecter l\'or noir',
      deltaGauge1: 20,
      deltaGauge2: 20,
      deltaGauge3: -20,
      deltaGauge4: -10,
    ),
    rightChoice: ChoiceImpact(
      text: 'Accepter la purge',
      deltaGauge1: -20,
      deltaGauge2: -15,
      deltaGauge3: 20,
      deltaGauge4: 15,
    ),
  ),

  // EM_029: Horace Bell (Tentative de destitution)
  const GameCard(
    id: 'EM_029',
    campaign: 'EMPIRE',
    speakerName: 'Horace Bell',
    speakerRole: 'Patriarche furieux',
    speakerAvatar: 'assets/images/characters/empire/horace_wrath.png',
    dialogue:
        'Tu as fait coffrer Roy et banni Jules ! Tu détruis mon œuvre séculaire ! Je convoque les journalistes pour te déshériter sur le champ !',
    leftChoice: ChoiceImpact(
      text: 'Faire interdire le père',
      deltaGauge1: 15,
      deltaGauge2: -15,
      deltaGauge3: 20,
      deltaGauge4: -20,
      setFlags: ['horace_destitue'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Capituler sur l\'honneur',
      deltaGauge1: -20,
      deltaGauge2: 15,
      deltaGauge3: -10,
      deltaGauge4: 20,
    ),
  ),

  // EM_030: Coupure des flux bancaires internationaux
  const GameCard(
    id: 'EM_030',
    campaign: 'EMPIRE',
    speakerName: 'Réseau SWIFT',
    speakerRole: 'Tempête bancaire',
    speakerAvatar: 'assets/images/characters/empire/swift_ban.png',
    dialogue:
        'Le réseau SWIFT bloque tous les virements en devises du groupe. Quarante millions sont gelés entre New York et Genève.',
    leftChoice: ChoiceImpact(
      text: 'Basculer en crypto',
      deltaGauge1: -15,
      deltaGauge2: 20,
      deltaGauge3: -20,
      deltaGauge4: 15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Payer l\'amende fédérale',
      deltaGauge1: 20,
      deltaGauge2: -20,
      deltaGauge3: 20,
      deltaGauge4: -15,
    ),
  ),

  // =========================================================================
  // CHAPTER 4: La Guerre Judiciaire & Le Démantèlement (EM_031 - EM_040)
  // =========================================================================

  // EM_031: Tribunal Fédéral de District
  const GameCard(
    id: 'EM_031',
    campaign: 'EMPIRE',
    speakerName: 'Le Président du Tribunal',
    speakerRole: 'Cour de Justice Fédérale',
    speakerAvatar: 'assets/images/characters/empire/federal_judge.png',
    dialogue:
        'Madame Mallory Bell, vous êtes inculpée pour blanchiment aggravé en bande organisée, corruption d\'agents et complicité d\'incendie criminel.',
    leftChoice: ChoiceImpact(
      text: 'Plaider non coupable',
      deltaGauge1: 15,
      deltaGauge2: -20,
      deltaGauge3: 20,
      deltaGauge4: -15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Négocier un plaidoyer',
      deltaGauge1: -20,
      deltaGauge2: 20,
      deltaGauge3: -15,
      deltaGauge4: 15,
    ),
  ),

  // EM_032: Confrontation avec Kimmie
  const GameCard(
    id: 'EM_032',
    campaign: 'EMPIRE',
    speakerName: 'Kimmie',
    speakerRole: 'Témoin-clé de l\'accusation',
    speakerAvatar: 'assets/images/characters/empire/kimmie_witness.png',
    dialogue:
        'Kimmie s\'avance à la barre avec un dossier scellé. Son témoignage peut anéantir quarante ans de règne en quelques phrases.',
    leftChoice: ChoiceImpact(
      text: 'Déstabiliser son récit',
      deltaGauge1: 15,
      deltaGauge2: -10,
      deltaGauge3: 20,
      deltaGauge4: -15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Tenter de la corrompre',
      deltaGauge1: -20,
      deltaGauge2: -20,
      deltaGauge3: -15,
      deltaGauge4: 20,
    ),
  ),

  // EM_033: Roy Bell (Mort sous les balles du FBI)
  const GameCard(
    id: 'EM_033',
    campaign: 'EMPIRE',
    speakerName: 'Silas',
    speakerRole: 'Chef de la sécurité',
    speakerAvatar: 'assets/images/characters/empire/silas.png',
    dialogue:
        'Roy a ouvert le feu sur les marshals fédéraux dans un hangar portuaire. Il a succombé à ses blessures sur le macadam.',
    leftChoice: ChoiceImpact(
      text: 'Obsèques d\'apparat',
      deltaGauge1: 15,
      deltaGauge2: -15,
      deltaGauge3: -20,
      deltaGauge4: 20,
      setFlags: ['martyre_roy'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Renier publiquement',
      deltaGauge1: -15,
      deltaGauge2: 15,
      deltaGauge3: 15,
      deltaGauge4: -20,
    ),
  ),

  // EM_034: Procureur Miller (Volte-face du magistrat)
  const GameCard(
    id: 'EM_034',
    campaign: 'EMPIRE',
    speakerName: 'Procureur Miller',
    speakerRole: 'Magistrat aux abois',
    speakerAvatar: 'assets/images/characters/empire/prosecutor_miller.png',
    dialogue:
        'Le vent tourne, Mallory ! Si je ne vous incarcère pas, je coule avec vous. Livrez-moi votre père Horace et je vous épargne la détention.',
    leftChoice: ChoiceImpact(
      text: 'Livrer Horace',
      deltaGauge1: 20,
      deltaGauge2: -15,
      deltaGauge3: 15,
      deltaGauge4: -20,
      setFlags: ['horace_ecroue'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Faire chanter Miller',
      deltaGauge1: -20,
      deltaGauge2: 20,
      deltaGauge3: -20,
      deltaGauge4: 20,
    ),
  ),

  // EM_035: Arrestation d'Horace Bell
  const GameCard(
    id: 'EM_035',
    campaign: 'EMPIRE',
    speakerName: 'Horace sous menottes',
    speakerRole: 'Chute du Patriarche',
    speakerAvatar: 'assets/images/characters/empire/horace_arrested.png',
    dialogue:
        'Menotté sous les flashs des reporters, Horace me jette avec haine : "Tu n\'es pas ma fille, tu es le fossoyeur de notre lignée !"',
    leftChoice: ChoiceImpact(
      text: 'Sourire impérial',
      deltaGauge1: 15,
      deltaGauge2: -10,
      deltaGauge3: 15,
      deltaGauge4: -20,
    ),
    rightChoice: ChoiceImpact(
      text: 'Détourner le regard',
      deltaGauge1: -15,
      deltaGauge2: 10,
      deltaGauge3: -15,
      deltaGauge4: 20,
    ),
  ),

  // EM_036: Saisie conservatoire des usines Bell
  const GameCard(
    id: 'EM_036',
    campaign: 'EMPIRE',
    speakerName: 'Mandataire Judiciaire',
    speakerRole: 'Liquidation provisoire',
    speakerAvatar: 'assets/images/characters/empire/liquidator.png',
    dialogue:
        'Les scellés fédéraux sont posés sur l\'usine mère de formulation. Douze cents ouvriers sont renvoyés chez eux jusqu\'à nouvel ordre.',
    leftChoice: ChoiceImpact(
      text: 'Délocaliser l\'outil',
      deltaGauge1: -20,
      deltaGauge2: 20,
      deltaGauge3: -15,
      deltaGauge4: 20,
    ),
    rightChoice: ChoiceImpact(
      text: 'Payer la caution record',
      deltaGauge1: 15,
      deltaGauge2: -20,
      deltaGauge3: 20,
      deltaGauge4: -15,
    ),
  ),

  // EM_037: Don Salazar (Dernière sommation)
  const GameCard(
    id: 'EM_037',
    campaign: 'EMPIRE',
    speakerName: 'Don Salazar',
    speakerRole: 'Cartel impitoyable',
    speakerAvatar: 'assets/images/characters/empire/salazar.png',
    dialogue:
        'Sans Horace pour garantir les dettes, vous êtes nue face à nos armes. Cédez la majorité des parts ou votre villa brûlera cette nuit.',
    leftChoice: ChoiceImpact(
      text: 'Éliminer Salazar',
      deltaGauge1: -20,
      deltaGauge2: 20,
      deltaGauge3: -20,
      deltaGauge4: 20,
      setFlags: ['salazar_elimine'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Céder les cabarets',
      deltaGauge1: 20,
      deltaGauge2: -20,
      deltaGauge3: 20,
      deltaGauge4: -20,
    ),
  ),

  // EM_038: Avocat d'affaires New-Yorkais (Restructuration)
  const GameCard(
    id: 'EM_038',
    campaign: 'EMPIRE',
    speakerName: 'Maître Sterling',
    speakerRole: 'Juriste de Wall Street',
    speakerAvatar: 'assets/images/characters/empire/corporate_lawyer.png',
    dialogue:
        'Nous pouvons dissoudre la holding familiale compromise et loger tous les actifs dans une entité immaculée prête pour le NASDAQ.',
    leftChoice: ChoiceImpact(
      text: 'Créer la nouvelle entité',
      deltaGauge1: 15,
      deltaGauge2: -20,
      deltaGauge3: 20,
      deltaGauge4: -20,
      setFlags: ['nouvelle_holding'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Défendre le blason',
      deltaGauge1: -20,
      deltaGauge2: 15,
      deltaGauge3: -15,
      deltaGauge4: 20,
    ),
  ),

  // EM_039: Campagne médiatique de rédemption
  const GameCard(
    id: 'EM_039',
    campaign: 'EMPIRE',
    speakerName: 'Attaché de Presse',
    speakerRole: 'Stratège en communication',
    speakerAvatar: 'assets/images/characters/empire/pr_officer.png',
    dialogue:
        'Le magazine Forbes prépare sa couverture : "Mallory Bell, la dirigeante qui a purgé le crime pour bâtir un colosse cosmétique éthique."',
    leftChoice: ChoiceImpact(
      text: 'Revendiquer la victoire',
      deltaGauge1: 15,
      deltaGauge2: -15,
      deltaGauge3: 15,
      deltaGauge4: -15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Discrétion stratégique',
      deltaGauge1: 15,
      deltaGauge2: 15,
      deltaGauge3: 20,
      deltaGauge4: 10,
    ),
  ),

  // EM_040: Nuit de délibération du Grand Jury
  const GameCard(
    id: 'EM_040',
    campaign: 'EMPIRE',
    speakerName: 'Salle d\'attente dorée',
    speakerRole: 'Veille du verdict',
    speakerAvatar: 'assets/images/characters/empire/boardroom_night.png',
    dialogue:
        'Les jurés se retirent. Seuls deux chefs mineurs pèsent encore dans la balance. Le sceptre de la dynastie va tomber ou triompher.',
    leftChoice: ChoiceImpact(
      text: 'Pression en coulisses',
      deltaGauge1: -15,
      deltaGauge2: 20,
      deltaGauge3: 15,
      deltaGauge4: 10,
    ),
    rightChoice: ChoiceImpact(
      text: 'Attendre en souveraine',
      deltaGauge1: 15,
      deltaGauge2: -15,
      deltaGauge3: 15,
      deltaGauge4: -10,
    ),
  ),

  // =========================================================================
  // CHAPTER 5: L'Hégémonie Absolue & Le Triomphe (EM_041 - EM_050)
  // =========================================================================

  // EM_041: L'Acquittement de Mallory Bell
  const GameCard(
    id: 'EM_041',
    campaign: 'EMPIRE',
    speakerName: 'Le Greffier Fédéral',
    speakerRole: 'Prononcé du jugement',
    speakerAvatar: 'assets/images/characters/empire/acquittal.png',
    dialogue:
        'La cour prononce l\'abandon sans condition de toutes les poursuites pénales contre Mallory Bell. Vous quittez ce tribunal libre et réhabilitée.',
    leftChoice: ChoiceImpact(
      text: 'Déclaration triomphale',
      deltaGauge1: 15,
      deltaGauge2: -15,
      deltaGauge3: 15,
      deltaGauge4: -10,
    ),
    rightChoice: ChoiceImpact(
      text: 'Partir en silence',
      deltaGauge1: 20,
      deltaGauge2: 20,
      deltaGauge3: 20,
      deltaGauge4: 10,
    ),
  ),

  // EM_042: Épuration totale du conseil
  const GameCard(
    id: 'EM_042',
    campaign: 'EMPIRE',
    speakerName: 'Conseil d\'Administration',
    speakerRole: 'Derniers courtisans d\'Horace',
    speakerAvatar: 'assets/images/characters/empire/board_purge.png',
    dialogue:
        'Les anciens partisans d\'Horace attendent leur sort autour de la table en acajou. Leurs lettres de révocation sont prêtes à être paraphées.',
    leftChoice: ChoiceImpact(
      text: 'Épuration impitoyable',
      deltaGauge1: 15,
      deltaGauge2: -10,
      deltaGauge3: 20,
      deltaGauge4: -20,
      setFlags: ['epuration_terminee'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Les soumettre par la dette',
      deltaGauge1: -15,
      deltaGauge2: 20,
      deltaGauge3: 15,
      deltaGauge4: 15,
    ),
  ),

  // EM_043: Lancement de 'MALLORY NOIR'
  const GameCard(
    id: 'EM_043',
    campaign: 'EMPIRE',
    speakerName: 'Chef de Marque Luxe',
    speakerRole: 'Division Haute Parfumerie',
    speakerAvatar: 'assets/images/characters/empire/perfume_launch.png',
    dialogue:
        'Le nouveau parfum "Mallory Noir" est en rupture mondiale à Paris, Tokyo et Dubaï. Les marges nettes dépassent quatre-vingt-dix pour cent.',
    leftChoice: ChoiceImpact(
      text: 'Gala impérial',
      deltaGauge1: 15,
      deltaGauge2: 20,
      deltaGauge3: 10,
      deltaGauge4: -15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Capitaliser en secret',
      deltaGauge1: 15,
      deltaGauge2: 20,
      deltaGauge3: 20,
      deltaGauge4: 10,
    ),
  ),

  // EM_044: Visite à Horace Bell au pénitencier
  const GameCard(
    id: 'EM_044',
    campaign: 'EMPIRE',
    speakerName: 'Horace Bell',
    speakerRole: 'Détenu n° 88412',
    speakerAvatar: 'assets/images/characters/empire/horace_prison.png',
    dialogue:
        'Horace, vieilli et tremblant sous l\'uniforme pénitentiaire : "Tu as tout pris... Mon nom, mes usines, mes milliards..."',
    leftChoice: ChoiceImpact(
      text: '"Mon empire désormais"',
      deltaGauge1: 15,
      deltaGauge2: 10,
      deltaGauge3: 20,
      deltaGauge4: -20,
    ),
    rightChoice: ChoiceImpact(
      text: '"Tu l\'as mérité"',
      deltaGauge1: 20,
      deltaGauge2: -10,
      deltaGauge3: 15,
      deltaGauge4: -15,
    ),
  ),

  // EM_045: Décret de rachat du Velvet Lounge
  const GameCard(
    id: 'EM_045',
    campaign: 'EMPIRE',
    speakerName: 'Commissaire-Priseur',
    speakerRole: 'Enchères publiques',
    speakerAvatar: 'assets/images/characters/empire/auctioneer.png',
    dialogue:
        'Le terrain calciné de l\'ancien Velvet Lounge est vendu aux enchères judiciaires. Vous pouvez raser ces ruines pour ériger la Tour Mallory.',
    leftChoice: ChoiceImpact(
      text: 'Raser les ruines',
      deltaGauge1: 15,
      deltaGauge2: -15,
      deltaGauge3: 15,
      deltaGauge4: 20,
      setFlags: ['velvet_rase'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Bâtir la Tour Mallory',
      deltaGauge1: 15,
      deltaGauge2: 20,
      deltaGauge3: 10,
      deltaGauge4: -10,
    ),
  ),

  // EM_046: Alliance avec le cartel de l'Est
  const GameCard(
    id: 'EM_046',
    campaign: 'EMPIRE',
    speakerName: 'Consortium d\'Asie',
    speakerRole: 'Partenaires maritimes discrets',
    speakerAvatar: 'assets/images/characters/empire/asian_consortium.png',
    dialogue:
        'Notre flotte de porte-conteneurs propose de fluidifier vos exportations asiatiques sans la moindre interférence douanière.',
    leftChoice: ChoiceImpact(
      text: 'Signer l\'alliance',
      deltaGauge1: -15,
      deltaGauge2: 20,
      deltaGauge3: 20,
      deltaGauge4: -15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Refuser l\'emprise',
      deltaGauge1: 15,
      deltaGauge2: -20,
      deltaGauge3: 15,
      deltaGauge4: 15,
    ),
  ),

  // EM_047: Dîner avec le Gouverneur de l'État
  const GameCard(
    id: 'EM_047',
    campaign: 'EMPIRE',
    speakerName: 'Le Gouverneur',
    speakerRole: 'Pouvoir exécutif',
    speakerAvatar: 'assets/images/characters/empire/governor.png',
    dialogue:
        'Le Gouverneur porte un toast : "Madame Bell, votre fondation et vos investissements sont désormais la colonne vertébrale de cet État."',
    leftChoice: ChoiceImpact(
      text: 'Mainmise politique',
      deltaGauge1: 15,
      deltaGauge2: -15,
      deltaGauge3: 15,
      deltaGauge4: -15,
      setFlags: ['controle_politique'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Exonérations fiscales',
      deltaGauge1: 15,
      deltaGauge2: 20,
      deltaGauge3: 20,
      deltaGauge4: 10,
    ),
  ),

  // EM_048: Jules Bell (Pénitent repentant)
  const GameCard(
    id: 'EM_048',
    campaign: 'EMPIRE',
    speakerName: 'Jules Bell',
    speakerRole: 'Frère brisé',
    speakerAvatar: 'assets/images/characters/empire/jules_begging.png',
    dialogue:
        'Jules réapparaît au manoir, amaigri et tremblant : "Mallory... Accorde-moi un poste subalterne aux docks... Je n\'ai plus rien au monde."',
    leftChoice: ChoiceImpact(
      text: 'Garder sous contrôle',
      deltaGauge1: -10,
      deltaGauge2: 15,
      deltaGauge3: -10,
      deltaGauge4: 20,
    ),
    rightChoice: ChoiceImpact(
      text: 'Bannir définitivement',
      deltaGauge1: 15,
      deltaGauge2: -10,
      deltaGauge3: 15,
      deltaGauge4: -20,
    ),
  ),

  // EM_049: Le Sommet Mondial du Luxe
  const GameCard(
    id: 'EM_049',
    campaign: 'EMPIRE',
    speakerName: 'Président du Sommet',
    speakerRole: 'Consécration internationale',
    speakerAvatar: 'assets/images/characters/empire/luxury_summit.png',
    dialogue:
        'À Genève, vous recevez le prix de Dirigeante Mondiale de l\'Année. Les plus puissants capitaines d\'industrie s\'inclinent devant vous.',
    leftChoice: ChoiceImpact(
      text: 'Discours d\'airain',
      deltaGauge1: 15,
      deltaGauge2: 15,
      deltaGauge3: 20,
      deltaGauge4: -15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Savourer en reine',
      deltaGauge1: 15,
      deltaGauge2: 20,
      deltaGauge3: 15,
      deltaGauge4: 10,
    ),
  ),

  // EM_050: La Dynastie Éternelle (Épilogue)
  const GameCard(
    id: 'EM_050',
    campaign: 'EMPIRE',
    speakerName: 'Mallory Bell',
    speakerRole: 'Impératrice absolue',
    speakerAvatar: 'assets/images/characters/empire/mallory_sovereign.png',
    dialogue:
        'Depuis la verrière sommitale dominant l\'océan, je contemple mon domaine. Plus personne n\'osera défier mon nom. L\'Ombre et la Beauté m\'appartiennent.',
    leftChoice: ChoiceImpact(
      text: 'Règne sans partage',
      deltaGauge1: 15,
      deltaGauge2: 20,
      deltaGauge3: 15,
      deltaGauge4: -20,
      setFlags: ['regne_absolu'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Dynastie éternelle',
      deltaGauge1: 15,
      deltaGauge2: 20,
      deltaGauge3: 15,
      deltaGauge4: 20,
      setFlags: ['dynastie_eternelle'],
    ),
  ),
];
