import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/codex_service.dart';
import '../../models/codex_entry.dart';
import '../../models/game_state.dart';

/// The Archives & Codex Screen ("Le Grimoire des Ombres").
///
/// Allows players to inspect their legacy across both campaigns:
/// - Canonical deaths (8 per campaign = 16 total) with chiaroscuro unlocked lore or redacted dossiers.
/// - Narrative story achievements linked to critical card choices and flags.
/// - Lifetime decisions, streak records, and overall completion progress.
class CodexScreen extends StatefulWidget {
  final CodexService? codexService;

  const CodexScreen({super.key, this.codexService});

  @override
  State<CodexScreen> createState() => _CodexScreenState();
}

class _CodexScreenState extends State<CodexScreen>
    with SingleTickerProviderStateMixin {
  late final CodexService _codex;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _codex = widget.codexService ?? CodexService.instance;
    _codex.init();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isStreetTab = _tabController.index == 0;
    final primaryAccent =
        isStreetTab ? AppColors.neonViolet : AppColors.champagneGold;
    final secondaryAccent =
        isStreetTab ? AppColors.cyan : AppColors.deepBlood;

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _codex,
          builder: (context, _) {
            final unlockedDeaths = _codex.getUnlockedDeathCount();
            final totalDeaths = _codex.getTotalDeathCount();
            final deathPercent = totalDeaths == 0
                ? 0
                : ((unlockedDeaths / totalDeaths) * 100).toInt();

            return Column(
              children: [
                // Top App Bar
                _buildTopAppBar(primaryAccent),

                // Global Progress Header Card
                _buildProgressHeader(
                  unlockedDeaths: unlockedDeaths,
                  totalDeaths: totalDeaths,
                  deathPercent: deathPercent,
                  primaryAccent: primaryAccent,
                  secondaryAccent: secondaryAccent,
                ),

                const SizedBox(height: 8),

                // Styled Dual Faction Tab Bar
                _buildTabBar(primaryAccent),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _CampaignCodexView(
                        key: const ValueKey('view_codex_street'),
                        campaign: CampaignType.street,
                        codex: _codex,
                        primaryAccent: AppColors.neonViolet,
                        secondaryAccent: AppColors.cyan,
                      ),
                      _CampaignCodexView(
                        key: const ValueKey('view_codex_empire'),
                        campaign: CampaignType.empire,
                        codex: _codex,
                        primaryAccent: AppColors.champagneGold,
                        secondaryAccent: AppColors.deepBlood,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopAppBar(Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        children: [
          IconButton(
            key: const ValueKey('btn_codex_back'),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.text,
              size: 20,
            ),
            tooltip: 'Retour',
            onPressed: () {
              AudioService.instance.playClickSfx();
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'LE GRIMOIRE DES OMBRES',
                  style: GoogleFonts.cinzel(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                  ),
                ),
                Text(
                  'Archives secrètes • Destins & Conquêtes',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkSurface,
              border: Border.all(
                color: accentColor.withValues(alpha: 0.5),
                width: 1.0,
              ),
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              size: 18,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader({
    required int unlockedDeaths,
    required int totalDeaths,
    required int deathPercent,
    required Color primaryAccent,
    required Color secondaryAccent,
  }) {
    final unlockedAch = _codex.getUnlockedAchievementCount();
    final totalAch = _codex.getTotalAchievementCount();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: primaryAccent.withValues(alpha: 0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FINS DÉCOUVERTES : $unlockedDeaths / $totalDeaths',
                key: const ValueKey('codex_progress_text'),
                style: GoogleFonts.cinzel(
                  color: AppColors.text,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: primaryAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: primaryAccent.withValues(alpha: 0.6),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  '$deathPercent%',
                  style: GoogleFonts.inter(
                    color: primaryAccent,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Visual Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              key: const ValueKey('codex_progress_bar'),
              height: 8,
              width: double.infinity,
              color: AppColors.darkSurface,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: totalDeaths == 0
                    ? 0.0
                    : (unlockedDeaths / totalDeaths).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryAccent, secondaryAccent],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Lifetime Stats Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatPill(
                label: 'DÉCISIONS',
                value: '${_codex.totalDecisions}',
                icon: Icons.touch_app_rounded,
                color: AppColors.cyan,
              ),
              _StatPill(
                label: 'SURVIE RUE',
                value: '${_codex.getHighestStreak(CampaignType.street)} J',
                icon: Icons.nightlife_rounded,
                color: AppColors.neonViolet,
              ),
              _StatPill(
                label: 'SURVIE EMPIRE',
                value: '${_codex.getHighestStreak(CampaignType.empire)} J',
                icon: Icons.account_balance_rounded,
                color: AppColors.champagneGold,
              ),
              _StatPill(
                label: 'SECRETS',
                value: '$unlockedAch/$totalAch',
                icon: Icons.military_tech_rounded,
                color: AppColors.statusGood,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(Color accentColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: accentColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.8),
            width: 1.2,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.text,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: GoogleFonts.cinzel(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
        tabs: const [
          Tab(
            key: ValueKey('tab_street'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.nightlife_rounded, size: 16),
                SizedBox(width: 8),
                Text('L\'Ombre de la Rue'),
              ],
            ),
          ),
          Tab(
            key: ValueKey('tab_empire'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance_rounded, size: 16),
                SizedBox(width: 8),
                Text('Les Secrets de l\'Empire'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 3),
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.textMuted,
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            color: AppColors.text,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

/// Scrollable view presenting the canonical deaths and story achievements of a campaign.
class _CampaignCodexView extends StatelessWidget {
  final CampaignType campaign;
  final CodexService codex;
  final Color primaryAccent;
  final Color secondaryAccent;

  const _CampaignCodexView({
    super.key,
    required this.campaign,
    required this.codex,
    required this.primaryAccent,
    required this.secondaryAccent,
  });

  @override
  Widget build(BuildContext context) {
    final deaths = codex.getDeaths(campaign);
    final achievements = codex.getAchievements(campaign);
    final unlockedDeathsCount = codex.getUnlockedDeathCount(campaign);
    final unlockedAchCount = codex.getUnlockedAchievementCount(campaign);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      children: [
        // ==========================================
        // Canonical Deaths Section Header
        // ==========================================
        _SectionHeader(
          title: 'FINS CANONIQUES ($unlockedDeathsCount/${deaths.length})',
          subtitle:
              'Les 8 trépas inéluctables dictés par les jauges d\'influence',
          accentColor: primaryAccent,
          icon: Icons.dangerous_rounded,
        ),
        const SizedBox(height: 10),

        // Canonical Deaths Cards
        for (final death in deaths) ...[
          _DeathCard(
            key: ValueKey('death_card_${death.id}'),
            entry: death,
            primaryAccent: primaryAccent,
            secondaryAccent: secondaryAccent,
          ),
          const SizedBox(height: 10),
        ],

        const SizedBox(height: 16),

        // ==========================================
        // Story Achievements Section Header
        // ==========================================
        _SectionHeader(
          title: 'FAITS D\'ARMES & SECRETS ($unlockedAchCount/${achievements.length})',
          subtitle: 'Moments clés gravés dans l\'histoire de la cité',
          accentColor: secondaryAccent,
          icon: Icons.military_tech_rounded,
        ),
        const SizedBox(height: 10),

        // Story Achievements Cards
        for (final ach in achievements) ...[
          _AchievementCard(
            key: ValueKey('ach_card_${ach.id}'),
            achievement: ach,
            primaryAccent: primaryAccent,
            secondaryAccent: secondaryAccent,
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accentColor;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: accentColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.cinzel(
                  color: AppColors.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Renders an unlocked canonical death or a redacted dossier if locked.
class _DeathCard extends StatelessWidget {
  final DeathEntry entry;
  final Color primaryAccent;
  final Color secondaryAccent;

  const _DeathCard({
    super.key,
    required this.entry,
    required this.primaryAccent,
    required this.secondaryAccent,
  });

  @override
  Widget build(BuildContext context) {
    if (entry.isUnlocked) {
      return _buildUnlockedCard();
    } else {
      return _buildLockedCard();
    }
  }

  Widget _buildUnlockedCard() {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (entry.isOverflow ? primaryAccent : secondaryAccent)
              .withValues(alpha: 0.7),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gauge Badge & Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: (entry.isOverflow ? primaryAccent : secondaryAccent)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: (entry.isOverflow ? primaryAccent : secondaryAccent)
                        .withValues(alpha: 0.6),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  '${entry.gaugeName.toUpperCase()} [${entry.isOverflow ? 'MAX' : 'MIN'}]',
                  style: GoogleFonts.inter(
                    color: entry.isOverflow ? primaryAccent : secondaryAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 13,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Subi ${entry.deathCount} fois',
                    style: GoogleFonts.inter(
                      color: AppColors.textMuted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Title
          Text(
            entry.title,
            style: GoogleFonts.cinzel(
              color: AppColors.text,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),

          const SizedBox(height: 6),

          // Lore Narration
          Text(
            entry.description,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 10),

          // Footer info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Record sur ce destin : ${entry.lastDaysSurvived ?? 0} jours',
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (entry.unlockedAt != null)
                Text(
                  'Découvert le ${entry.unlockedAt!.day.toString().padLeft(2, '0')}/${entry.unlockedAt!.month.toString().padLeft(2, '0')}/${entry.unlockedAt!.year}',
                  style: GoogleFonts.inter(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLockedCard() {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: AppColors.statusDanger.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.statusDanger.withValues(alpha: 0.4),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_rounded,
                      size: 11,
                      color: AppColors.statusDanger,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'DOSSIER CLASSÉ',
                      style: GoogleFonts.cinzel(
                        color: AppColors.statusDanger,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'DESTIN : ${entry.gaugeName.toUpperCase()}',
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Redacted Title placeholder
          Text(
            'DESTIN NON DÉCOUVERT [${entry.gaugeName.toUpperCase()} ${entry.isOverflow ? '100' : '0'}]',
            style: GoogleFonts.cinzel(
              color: AppColors.textMuted,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),

          const SizedBox(height: 6),

          // Subtle clue / hint
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.search_rounded,
                size: 13,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Indice : ${entry.hint}',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                    fontSize: 11.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Renders a story achievement card with unlock status.
class _AchievementCard extends StatelessWidget {
  final StoryAchievement achievement;
  final Color primaryAccent;
  final Color secondaryAccent;

  const _AchievementCard({
    super.key,
    required this.achievement,
    required this.primaryAccent,
    required this.secondaryAccent,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.isUnlocked;

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.cardSurface : AppColors.darkSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isUnlocked
              ? primaryAccent.withValues(alpha: 0.5)
              : AppColors.border,
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked
                  ? primaryAccent.withValues(alpha: 0.15)
                  : AppColors.obsidian,
              border: Border.all(
                color: isUnlocked
                    ? primaryAccent.withValues(alpha: 0.6)
                    : AppColors.border,
                width: 1.0,
              ),
            ),
            child: Icon(
              isUnlocked
                  ? Icons.workspace_premium_rounded
                  : Icons.lock_outline_rounded,
              size: 18,
              color: isUnlocked ? primaryAccent : AppColors.textMuted,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isUnlocked
                            ? achievement.title
                            : 'FAIT D\'ARME NON DÉCOUVERT',
                        style: GoogleFonts.cinzel(
                          color: isUnlocked
                              ? AppColors.text
                              : AppColors.textMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    if (isUnlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.statusGood.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.statusGood.withValues(alpha: 0.5),
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          'ACCOMPLI',
                          style: GoogleFonts.inter(
                            color: AppColors.statusGood,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isUnlocked
                      ? achievement.description
                      : 'Indice : ${achievement.hint}',
                  style: GoogleFonts.inter(
                    color: isUnlocked
                        ? AppColors.textSecondary
                        : AppColors.textMuted,
                    fontSize: 11.5,
                    fontStyle:
                        isUnlocked ? FontStyle.normal : FontStyle.italic,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
