import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/game_state.dart';
import '../../providers/game_controller.dart';

/// Screen displayed when a playthrough ends due to gauge depletion or overflow.
///
/// Features a brutal crime-scene neo-noir atmosphere, blood-crimson accents,
/// detailed cause of death, days survived, and dual restart actions.
class GameOverScreen extends StatelessWidget {
  /// Explicit [GameState] input (optional; falls back to Provider).
  final GameState? state;

  /// Callback for restarting in the same campaign (optional; falls back to Provider).
  final VoidCallback? onRestartSame;

  /// Callback for switching to the alternate campaign (optional; falls back to Provider).
  final VoidCallback? onSwitchCampaign;

  const GameOverScreen({
    super.key,
    this.state,
    this.onRestartSame,
    this.onSwitchCampaign,
  });

  @override
  Widget build(BuildContext context) {
    GameController? controller;
    try {
      controller = context.watch<GameController?>();
    } catch (_) {
      controller = null;
    }

    final effectiveState = state ?? controller?.state ?? GameState.initial();
    final currentCampaign = effectiveState.campaign;
    final otherCampaign = currentCampaign == CampaignType.street
        ? CampaignType.empire
        : CampaignType.street;

    void handleRestartSame() {
      if (onRestartSame != null) {
        onRestartSame!();
      } else {
        controller?.restart(currentCampaign);
      }
    }

    void handleSwitchCampaign() {
      if (onSwitchCampaign != null) {
        onSwitchCampaign!();
      } else {
        controller?.restart(otherCampaign);
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 1),

                // ==========================================
                // Header & Broken Crown/Skull Icon
                // ==========================================
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
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
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.statusDanger,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Main Title: "RÈGNE BRISÉ"
                Text(
                  'RÈGNE BRISÉ',
                  key: const ValueKey('game_over_title'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    color: AppColors.statusDanger,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4.0,
                    shadows: [
                      Shadow(
                        color: AppColors.statusDanger.withValues(alpha: 0.6),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Metrics Pill: "JOURS SURVÉCUS : X"
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.border,
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      'JOURS SURVÉCUS : ${effectiveState.dayCount}',
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
                  padding: const EdgeInsets.all(20.0),
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
                      const SizedBox(height: 14),

                      // Death Message Narration
                      Text(
                        effectiveState.deathMessage ??
                            'Votre règne s\'achève dans le sang et le silence.',
                        key: const ValueKey('game_over_message'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AppColors.text,
                          fontSize: 14.5,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 3),

                // ==========================================
                // Succession Action Buttons
                // ==========================================

                // Button 1: Recommencer ce camp
                ElevatedButton(
                  key: const ValueKey('btn_restart_same'),
                  onPressed: handleRestartSame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cardSurface,
                    foregroundColor: AppColors.text,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                    'RECOMMENCER CE CAMP',
                    style: GoogleFonts.cinzel(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Button 2: Inverser l'échiquier
                OutlinedButton(
                  key: const ValueKey('btn_switch_campaign'),
                  onPressed: handleSwitchCampaign,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: otherCampaign == CampaignType.street
                        ? AppColors.neonViolet
                        : AppColors.champagneGold,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                          fontSize: 12.5,
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
