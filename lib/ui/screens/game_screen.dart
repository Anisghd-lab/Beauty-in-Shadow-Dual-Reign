import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/audio_service.dart';
import '../../models/game_state.dart';
import '../../providers/game_controller.dart';
import '../widgets/gauge_bar.dart';
import '../widgets/swipe_card_view.dart';
import 'game_over_screen.dart';

/// The core gameplay screen of Beauty in Shadow - Dual Reign.
///
/// Features:
/// - Top: Interactive 4-gauge HUD bar with real-time swipe preview dots.
/// - Sub-header: Minimalist campaign & day progression pill.
/// - Center: Gesture-driven [CardSwiper] with tilt-reactive choice badges.
/// - Bottom: Tactile fallback buttons allowing discrete taps instead of swipes.
/// - Game Over: Seamless transition to [GameOverScreen] upon terminal status.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final CardSwiperController _swiperController = CardSwiperController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          final campaign = context.read<GameController>().state.campaign;
          AudioService.instance.playBgm(campaign);
        } catch (_) {}
      }
    });
  }

  @override
  void dispose() {
    _swiperController.dispose();
    AudioService.instance.stopBgm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final state = controller.state;

    // Seamlessly display GameOverScreen when terminal condition is reached
    if (state.isGameOver) {
      AudioService.instance.stopBgm();
      return GameOverScreen(
        state: state,
        onRestartSame: () {
          AudioService.instance.playBgm(state.campaign);
          controller.restart(state.campaign);
        },
        onSwitchCampaign: () {
          final nextCampaign = state.campaign == CampaignType.street
              ? CampaignType.empire
              : CampaignType.street;
          AudioService.instance.playBgm(nextCampaign);
          controller.restart(nextCampaign);
        },
        onReturnToMenu: () {
          AudioService.instance.stopBgm();
          Navigator.of(context).pop();
        },
      );
    }

    final currentCard = controller.currentCard;
    final isStreet = state.campaign == CampaignType.street;
    final campaignLabel = isStreet ? 'DE LA RUE' : 'DE L\'EMPIRE';
    final accentColor = isStreet ? AppColors.neonViolet : AppColors.champagneGold;

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top HUD Bar (Gauges bound to real-time swipe preview)
            const GaugeBar(),

            const SizedBox(height: 8),

            // 2. Persistent Protagonist Header Bar ("VOUS INCARNEZ : [NAME]" with "RÈGNE N°[reignNumber]")
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                key: const ValueKey('protagonist_banner'),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 7.0),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.35),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Protagonist Avatar / Emblem
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E222D),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: accentColor,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Icon(
                        isStreet
                            ? Icons.person_rounded
                            : Icons.military_tech_rounded,
                        size: 18,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Protagonist Name & Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'VOUS INCARNEZ : ${state.protagonist.name.toUpperCase()}',
                                  key: const ValueKey('protagonist_name_text'),
                                  style: GoogleFonts.cinzel(
                                    color: AppColors.text,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.0,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                key: const ValueKey('protagonist_reign_pill'),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: accentColor.withValues(alpha: 0.4),
                                    width: 1.0,
                                  ),
                                ),
                                child: Text(
                                  'RÈGNE N°${state.protagonist.reignNumber}',
                                  style: GoogleFonts.cinzel(
                                    color: accentColor,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${state.protagonist.title} — ${state.reignText}',
                            key: const ValueKey('protagonist_title_text'),
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondary,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.4,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 3. Sub-header: Status pill ("JOUR X — CAMPAGNE DE LA RUE / DE L'EMPIRE") + Audio Toggle
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.35),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'JOUR ${state.dayCount} — CAMPAGNE $campaignLabel',
                      key: const ValueKey('status_pill_text'),
                      style: GoogleFonts.cinzel(
                        color: accentColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ListenableBuilder(
                      listenable: AudioService.instance,
                      builder: (context, _) {
                        final isMuted = AudioService.instance.isMuted;
                        return InkWell(
                          key: const ValueKey('btn_game_mute_toggle'),
                          onTap: () => AudioService.instance.toggleMute(),
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              isMuted ? Icons.volume_off : Icons.volume_up,
                              size: 14,
                              color: isMuted
                                  ? AppColors.textSecondary
                                  : accentColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 3. Center Stage: Card Swiper
            Expanded(
              child: currentCard == null
                  ? Center(
                      child: Text(
                        'Aucune carte active',
                        style: GoogleFonts.cinzel(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : Center(
                      child: SizedBox(
                        width: SwipeCardView.cardWidth,
                        height: SwipeCardView.cardHeight,
                        child: CardSwiper(
                          key: ValueKey('swiper_${currentCard.id}_${state.dayCount}'),
                          controller: _swiperController,
                          cardsCount: 1,
                          numberOfCardsDisplayed: 1,
                          isLoop: false,
                          allowedSwipeDirection: const AllowedSwipeDirection.only(
                            left: true,
                            right: true,
                          ),
                          onSwipeDirectionChange:
                              (horizontalDirection, verticalDirection) {
                            if (horizontalDirection ==
                                CardSwiperDirection.left) {
                              controller.setSwipePreview(SwipeDirection.left);
                            } else if (horizontalDirection ==
                                CardSwiperDirection.right) {
                              controller.setSwipePreview(SwipeDirection.right);
                            } else {
                              controller.setSwipePreview(SwipeDirection.none);
                            }
                          },
                          onSwipe: (previousIndex, currentIndex, direction) {
                            if (direction == CardSwiperDirection.left) {
                              controller.onChoiceSelected(false);
                              return true;
                            } else if (direction ==
                                CardSwiperDirection.right) {
                              controller.onChoiceSelected(true);
                              return true;
                            }
                            return false;
                          },
                          cardBuilder: (
                            context,
                            index,
                            horizontalOffsetPercentage,
                            verticalOffsetPercentage,
                          ) {
                            final percent = (horizontalOffsetPercentage / 100.0)
                                .clamp(-1.0, 1.0);
                            return SwipeCardView(
                              card: currentCard,
                              swipePercent: percent,
                            );
                          },
                        ),
                      ),
                    ),
            ),

            // 4. Bottom Fallback Tactile Bar (Tap instead of swipe)
            if (currentCard != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: Row(
                  children: [
                    // Left Choice Button
                    Expanded(
                      child: OutlinedButton(
                        key: const ValueKey('btn_choice_left'),
                        onPressed: () => controller.onChoiceSelected(false),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.cardSurface,
                          foregroundColor: AppColors.neonViolet,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                          side: const BorderSide(
                            color: AppColors.border,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_back_rounded, size: 15),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                currentCard.leftChoice.text,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Right Choice Button
                    Expanded(
                      child: OutlinedButton(
                        key: const ValueKey('btn_choice_right'),
                        onPressed: () => controller.onChoiceSelected(true),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.cardSurface,
                          foregroundColor: AppColors.cyan,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                          side: const BorderSide(
                            color: AppColors.border,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                currentCard.rightChoice.text,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward_rounded, size: 15),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
