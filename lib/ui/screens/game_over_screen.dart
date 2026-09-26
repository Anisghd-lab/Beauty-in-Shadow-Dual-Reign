import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/storage_service.dart';
import '../../models/game_state.dart';
import '../../providers/game_controller.dart';

/// Screen displayed when a playthrough ends due to gauge depletion or overflow.
///
/// Features a brutal crime-scene neo-noir atmosphere, blood-crimson accents,
/// detailed cause of death, days survived, high-score persistence, and triple navigation actions.
class GameOverScreen extends StatefulWidget {
  /// Explicit [GameState] input (optional; falls back to Provider).
  final GameState? state;

  /// Callback for restarting in the same campaign (optional; falls back to Provider).
  final VoidCallback? onRestartSame;

  /// Callback for switching to the alternate campaign (optional; falls back to Provider).
  final VoidCallback? onSwitchCampaign;

  /// Callback for returning to the main menu (optional; falls back to Navigator.pop).
  final VoidCallback? onReturnToMenu;

  const GameOverScreen({
    super.key,
    this.state,
    this.onRestartSame,
    this.onSwitchCampaign,
    this.onReturnToMenu,
  });

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  bool _recordSaved = false;

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      _saveRecord(widget.state!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_recordSaved) {
      GameController? controller;
      try {
        controller = context.read<GameController?>();
      } catch (_) {
        controller = null;
      }
      final effectiveState =
          widget.state ?? controller?.state ?? GameState.initial();
      _saveRecord(effectiveState);
    }
  }

  void _saveRecord(GameState state) {
    if (_recordSaved) return;
    _recordSaved = true;
    StorageService.instance.saveRecordIfBest(state.campaign, state.dayCount);
  }

  @override
  Widget build(BuildContext context) {
    GameController? controller;
    try {
      controller = context.watch<GameController?>();
    } catch (_) {
      controller = null;
    }

    final effectiveState =
        widget.state ?? controller?.state ?? GameState.initial();
    if (!_recordSaved) {
      _saveRecord(effectiveState);
    }

    final currentCampaign = effectiveState.campaign;
    final otherCampaign = currentCampaign == CampaignType.street
        ? CampaignType.empire
        : CampaignType.street;

    void handleRestartSame() {
      if (widget.onRestartSame != null) {
        widget.onRestartSame!();
      } else {
        controller?.restart(currentCampaign);
      }
    }

    void handleSwitchCampaign() {
      if (widget.onSwitchCampaign != null) {
        widget.onSwitchCampaign!();
      } else {
        controller?.restart(otherCampaign);
      }
    }

    void handleReturnToMenu() {
      if (widget.onReturnToMenu != null) {
        widget.onReturnToMenu!();
      } else {
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.2,
              colors: [
                AppColors.statusDanger.withValues(alpha: 0.18),
                AppColors.obsidian,
              ],
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 1),

                // ==========================================
                // Header & Broken Crown/Skull Icon
                // ==========================================
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.darkSurface,
                      border: Border.all(
                        color: AppColors.statusDanger,
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.statusDanger.withValues(alpha: 0.5),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.statusDanger,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Category / Ominous Header
                Text(
                  'RÈGNE BRISÉ',
                  key: const ValueKey('game_over_category'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    color: AppColors.statusDanger.withValues(alpha: 0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3.0,
                  ),
                ),
                const SizedBox(height: 6),

                // Main Title: "FIN DU RÈGNE DE [Nom du Protagoniste défunt]"
                Text(
                  'FIN DU RÈGNE DE ${effectiveState.protagonist.name.toUpperCase()}',
                  key: const ValueKey('game_over_title'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    color: AppColors.statusDanger,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.2,
                    shadows: [
                      Shadow(
                        color: AppColors.statusDanger.withValues(alpha: 0.6),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Metrics Pill: "DURÉE DU RÈGNE : X JOURS"
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.border,
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      'DURÉE DU RÈGNE : ${effectiveState.dayCount} JOURS',
                      key: const ValueKey('game_over_days'),
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // ==========================================
                // Cause of Death Box
                // ==========================================
                Container(
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.statusDanger.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Trigger Label
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.statusDanger,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatReasonLabel(effectiveState.deathReason),
                            key: const ValueKey('game_over_reason'),
                            style: GoogleFonts.cinzel(
                              color: AppColors.statusDanger,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Death Message Narration
                      Text(
                        effectiveState.deathMessage ??
                            'Votre règne s\'achève dans le sang et le silence.',
                        key: const ValueKey('game_over_message'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AppColors.text,
                          fontSize: 14.0,
                          height: 1.45,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // ==========================================
                // Succession Action Buttons
                // ==========================================

                // Button 1: Transmettre le règne au successeur
                ElevatedButton(
                  key: const ValueKey('btn_restart_same'),
                  onPressed: handleRestartSame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cardSurface,
                    foregroundColor: AppColors.text,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    'TRANSMETTRE LE RÈGNE À ${effectiveState.nextSuccessorName.toUpperCase()}',
                    key: const ValueKey('btn_restart_text'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cinzel(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Button 2: Inverser l'échiquier
                OutlinedButton(
                  key: const ValueKey('btn_switch_campaign'),
                  onPressed: handleSwitchCampaign,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: otherCampaign == CampaignType.street
                        ? AppColors.neonViolet
                        : AppColors.champagneGold,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                      color: (otherCampaign == CampaignType.street
                              ? AppColors.neonViolet
                              : AppColors.champagneGold)
                          .withValues(alpha: 0.8),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.swap_horiz_rounded,
                        size: 18,
                        color: otherCampaign == CampaignType.street
                            ? AppColors.neonViolet
                            : AppColors.champagneGold,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'INVERSER L\'ÉCHIQUIER (${otherCampaign.displayName.toUpperCase()})',
                        style: GoogleFonts.cinzel(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Button 3: Retour au menu principal
                TextButton(
                  key: const ValueKey('btn_return_menu'),
                  onPressed: handleReturnToMenu,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.home_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'RETOUR AU MENU PRINCIPAL',
                        style: GoogleFonts.cinzel(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Converts a [GameOverReason] enum into an atmospheric, formatted title.
  static String _formatReasonLabel(GameOverReason? reason) {
    if (reason == null) return 'CHUTE INÉVITABLE';
    switch (reason) {
      case GameOverReason.gauge1Depleted:
        return 'PERTE D\'AUTORITÉ';
      case GameOverReason.gauge1Overflow:
        return 'NOTORIÉTÉ FATALE';
      case GameOverReason.gauge2Depleted:
        return 'BANQUEROUTE TOTALE';
      case GameOverReason.gauge2Overflow:
        return 'CONVOITISE MORTELLE';
      case GameOverReason.gauge3Depleted:
        return 'PERTE DE CONTRÔLE';
      case GameOverReason.gauge3Overflow:
        return 'INTERVENTION DU SWAT / MUTINERIE';
      case GameOverReason.gauge4Depleted:
        return 'TRAHISON TOTALE';
      case GameOverReason.gauge4Overflow:
        return 'ANARCHIE INTÉRIEURE';
      case GameOverReason.custom:
        return 'FATALITÉ DU DESTIN';
    }
  }
}
