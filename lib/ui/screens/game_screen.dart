import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
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
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final state = controller.state;

    // Seamlessly display GameOverScreen when terminal condition is reached
    if (state.isGameOver) {
      return GameOverScreen(
        state: state,
        onRestartSame: () => controller.restart(state.campaign),
        onSwitchCampaign: () {
          final nextCampaign = state.campaign == CampaignType.street
              ? CampaignType.empire
              : CampaignType.street;
          controller.restart(nextCampaign);
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

            const SizedBox(height: 12),

            // 2. Sub-header: Status pill ("JOUR X — CAMPAGNE DE LA RUE / DE L'EMPIRE")
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.35),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  'JOUR ${state.dayCount} — CAMPAGNE $campaignLabel',
                  key: const ValueKey('status_pill_text'),
                  style: GoogleFonts.cinzel(
                    color: accentColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
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
