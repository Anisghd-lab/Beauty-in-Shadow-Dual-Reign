import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/codex_service.dart';
import '../../core/services/storage_service.dart';
import '../../data/empire_deck.dart';
import '../../data/street_deck.dart';
import '../../models/game_state.dart';
import '../../providers/game_controller.dart';
import 'codex_screen.dart';
import 'game_screen.dart';

/// Campaign Selection Menu screen displaying the dual identities of the game:
/// - Street Syndicate (Kimmie - Survie Urbaine)
/// - Royal Empire (Mallory Bell - Dynastie & Crime)
///
/// Features high-contrast neo-noir visual aesthetics, persistent high-score badges,
/// a central metallic divider with the game crest, and campaign launch navigation.
class MenuScreen extends StatefulWidget {
  final StorageService? storageService;

  const MenuScreen({super.key, this.storageService});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final StorageService _storage;
  int _streetRecord = 0;
  int _empireRecord = 0;

  @override
  void initState() {
    super.initState();
    _storage = widget.storageService ?? StorageService.instance;
    _loadRecords();
    AudioService.instance.init();
    CodexService.instance.init();
  }

  Future<void> _loadRecords() async {
    final street = await _storage.getBestDays(CampaignType.street);
    final empire = await _storage.getBestDays(CampaignType.empire);
    if (mounted) {
      setState(() {
        _streetRecord = street;
        _empireRecord = empire;
      });
    }
  }

  void _launchCampaign(CampaignType campaign) {
    AudioService.instance.playClickSfx();
    final deck = campaign == CampaignType.street
        ? [...initialStreetDeck, ...initialEmpireDeck]
        : [...initialEmpireDeck, ...initialStreetDeck];

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<GameController>(
          create: (_) => GameController(
            initialState: GameState.initial(campaign: campaign),
            deck: deck,
          ),
          child: const GameScreen(),
        ),
      ),
    ).then((_) {
      _loadRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Section: Street Syndicate (Kimmie)
                Expanded(
                  child: _CampaignPanel(
                    key: const ValueKey('campaign_street'),
                    title: 'LA RUE & LA NUIT',
                    subtitle: 'Kimmie — Survie Urbaine',
                    description: '4 Jauges : Dignité, Cash, Réputation, Discrétion.',
                    recordText: 'RECORD : $_streetRecord JOURS',
                    primaryAccent: AppColors.neonViolet,
                    secondaryAccent: AppColors.cyan,
                    gradientColors: [
                      const Color(0xFF160E28),
                      const Color(0xFF0F121C),
                      AppColors.obsidian,
                    ],
                    icon: Icons.nightlife_rounded,
                    badgeKey: const ValueKey('badge_street'),
                    ctaText: 'INFILTRER LES BAS-FONDS',
                    onTap: () => _launchCampaign(CampaignType.street),
                  ),
                ),

                // Central Divider with razor-thin metallic diagonal slash and crest
                const _CentralDivider(),

                // Bottom Section: Royal Empire (Mallory Bell)
                Expanded(
                  child: _CampaignPanel(
                    key: const ValueKey('campaign_empire'),
                    title: 'L\'EMPIRE BELL',
                    subtitle: 'Mallory Bell — Dynastie & Crime',
                    description: '4 Jauges : Prestige, Blanchiment, Impunité, Clan.',
                    recordText: 'RECORD : $_empireRecord JOURS',
                    primaryAccent: AppColors.champagneGold,
                    secondaryAccent: AppColors.deepBlood,
                    gradientColors: [
                      const Color(0xFF1C150A),
                      const Color(0xFF170A0F),
                      AppColors.obsidian,
                    ],
                    icon: Icons.account_balance_rounded,
                    badgeKey: const ValueKey('badge_empire'),
                    ctaText: 'PRENDRE LE CONTRÔLE',
                    onTap: () => _launchCampaign(CampaignType.empire),
                  ),
                ),
              ],
            ),

            // Sleek Archives / Codex icon button in top left corner (opposite audio toggle)
            Positioned(
              top: 10,
              left: 12,
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  key: const ValueKey('btn_open_codex'),
                  icon: const Icon(
                    Icons.auto_stories_rounded,
                    color: AppColors.champagneGold,
                    size: 22,
                  ),
                  tooltip: 'Archives / Le Grimoire des Ombres',
                  onPressed: () {
                    AudioService.instance.playClickSfx();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CodexScreen(),
                      ),
                    ).then((_) {
                      _loadRecords();
                    });
                  },
                ),
              ),
            ),

            // Sleek neon audio toggle in top right corner
            Positioned(
              top: 10,
              right: 12,
              child: ListenableBuilder(
                listenable: AudioService.instance,
                builder: (context, _) {
                  final isMuted = AudioService.instance.isMuted;
                  return Material(
                    color: Colors.transparent,
                    child: IconButton(
                      key: const ValueKey('btn_audio_toggle'),
                      icon: Icon(
                        isMuted ? Icons.volume_off : Icons.volume_up,
                        color: isMuted
                            ? AppColors.textSecondary
                            : AppColors.cyan,
                        size: 22,
                      ),
                      tooltip: isMuted ? 'Activer le son' : 'Couper le son',
                      onPressed: () => AudioService.instance.toggleMute(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// An interactive campaign panel card occupying half the split-screen.
class _CampaignPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String recordText;
  final Color primaryAccent;
  final Color secondaryAccent;
  final List<Color> gradientColors;
  final IconData icon;
  final Key badgeKey;
  final String ctaText;
  final VoidCallback onTap;

  const _CampaignPanel({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.recordText,
    required this.primaryAccent,
    required this.secondaryAccent,
    required this.gradientColors,
    required this.icon,
    required this.badgeKey,
    required this.ctaText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: primaryAccent.withValues(alpha: 0.15),
      highlightColor: primaryAccent.withValues(alpha: 0.08),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          border: Border.all(
            color: primaryAccent.withValues(alpha: 0.25),
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top Row: Character Subtitle & Record Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 16, color: primaryAccent),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            color: primaryAccent,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  key: badgeKey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: secondaryAccent.withValues(alpha: 0.6),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: secondaryAccent.withValues(alpha: 0.2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Text(
                    recordText,
                    style: GoogleFonts.inter(
                      color: secondaryAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Campaign Title
            Text(
              title,
              style: GoogleFonts.cinzel(
                color: AppColors.text,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.2,
                shadows: [
                  Shadow(
                    color: primaryAccent.withValues(alpha: 0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Gauges Description
            Text(
              description,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 14),

            // Tactile CTA Pill
            Row(
              children: [
                Text(
                  ctaText,
                  style: GoogleFonts.cinzel(
                    color: primaryAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: primaryAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Central metallic divider with razor-thin diagonal slash and center crest.
class _CentralDivider extends StatelessWidget {
  const _CentralDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Razor-thin metallic diagonal slash line
          Positioned.fill(
            child: CustomPaint(
              painter: _MetallicSlashPainter(),
            ),
          ),

          // Central Crest Pill: "BEAUTY IN SHADOW: DUAL REIGN"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.obsidian,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.border,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.85),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.neonViolet,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'BEAUTY IN SHADOW: DUAL REIGN',
                  style: GoogleFonts.cinzel(
                    color: AppColors.text,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.champagneGold,
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

/// Draws a razor-thin metallic diagonal slash across the central divider.
class _MetallicSlashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          AppColors.neonViolet,
          AppColors.cyan,
          AppColors.border,
          AppColors.champagneGold,
          AppColors.deepBlood,
        ],
        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height * 0.75)
      ..lineTo(size.width, size.height * 0.25);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
