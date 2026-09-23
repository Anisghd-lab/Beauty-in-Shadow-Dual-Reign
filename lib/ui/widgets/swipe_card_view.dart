import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/card_model.dart';

/// Reusable neo-noir card presentation for Reign-style swipe interaction.
///
/// Dimensions: 320px width x 460px height, 18px border radius.
/// Internal structure:
/// - Top 60%: Portrait container with gradient overlay and asset/icon fallback.
/// - Badge Strip: Speaker identity banner with faction accent styling.
/// - Bottom 40%: Glassmorphic dialogue box displaying the narration.
/// - Choice Badge Overlay: Fades in during card drag to reveal pending decision.
class SwipeCardView extends StatelessWidget {
  /// The narrative card data to present.
  final GameCard card;

  /// Current horizontal drag percentage (-1.0 to 1.0).
  /// Negative = swiping left, Positive = swiping right.
  final double swipePercent;

  /// Width constraint for the card.
  static const double cardWidth = 320.0;

  /// Height constraint for the card.
  static const double cardHeight = 460.0;

  /// Border radius constraint.
  static const double cardRadius = 18.0;

  const SwipeCardView({
    super.key,
    required this.card,
    this.swipePercent = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final factionColor =
        card.isStreet ? AppColors.neonViolet : AppColors.champagneGold;
    final secondaryAccent =
        card.isStreet ? AppColors.cyan : AppColors.empireIvory;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(
          color: AppColors.border,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.65),
            blurRadius: 22,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: factionColor.withValues(alpha: 0.12),
            blurRadius: 18,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardRadius - 1.5),
        child: Stack(
          children: [
            // ==========================================
            // Main Vertical Content Flow
            // ==========================================
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Top Area (60% height: ~276px)
                Expanded(
                  flex: 6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Atmospheric portrait container
                      Container(
                        color: const Color(0xFF1E222D),
                        child: card.speakerAvatar.isNotEmpty
                            ? Image.asset(
                                card.speakerAvatar,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildAvatarFallback(factionColor),
                              )
                            : _buildAvatarFallback(factionColor),
                      ),

                      // Atmospheric gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.cardSurface.withValues(alpha: 0.6),
                              AppColors.cardSurface,
                            ],
                            stops: const [0.4, 0.8, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Middle Badge Strip
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface.withValues(alpha: 0.95),
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: AppColors.border,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Faction accent dot
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: factionColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: factionColor.withValues(alpha: 0.6),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Speaker Name
                      Expanded(
                        child: Text(
                          card.speakerName.toUpperCase(),
                          key: const ValueKey('card_speaker_name'),
                          style: GoogleFonts.cinzel(
                            color: AppColors.text,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Speaker Role
                      Flexible(
                        child: Text(
                          card.speakerRole,
                          key: const ValueKey('card_speaker_role'),
                          style: TextStyle(
                            color: secondaryAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. Bottom Dialogue Box (40% height: ~184px)
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 16.0),
                    alignment: Alignment.center,
                    color: AppColors.darkSurface.withValues(alpha: 0.5),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        card.dialogue,
                        key: const ValueKey('card_dialogue_text'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AppColors.text,
                          fontSize: 14.5,
                          height: 1.45,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ==========================================
            // Left Swipe Choice Badge Overlay
            // ==========================================
            if (swipePercent < -0.05)
              Positioned(
                top: 24,
                left: 18,
                child: Opacity(
                  opacity: (-swipePercent).clamp(0.0, 1.0),
                  child: Transform.rotate(
                    angle: -0.15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.obsidian.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.neonViolet,
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonViolet.withValues(alpha: 0.4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Text(
                        card.leftChoice.text.toUpperCase(),
                        key: const ValueKey('overlay_choice_left'),
                        style: GoogleFonts.cinzel(
                          color: AppColors.neonViolet,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // ==========================================
            // Right Swipe Choice Badge Overlay
            // ==========================================
            if (swipePercent > 0.05)
              Positioned(
                top: 24,
                right: 18,
                child: Opacity(
                  opacity: swipePercent.clamp(0.0, 1.0),
                  child: Transform.rotate(
                    angle: 0.15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.obsidian.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.cyan,
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyan.withValues(alpha: 0.4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Text(
                        card.rightChoice.text.toUpperCase(),
                        key: const ValueKey('overlay_choice_right'),
                        style: GoogleFonts.cinzel(
                          color: AppColors.cyan,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Fallback graphic when an avatar image asset is missing.
  Widget _buildAvatarFallback(Color accentColor) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkSurface,
              border: Border.all(
                color: accentColor.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.2),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Icon(
              card.isStreet ? Icons.person_rounded : Icons.shield_rounded,
              size: 42,
              color: accentColor.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            card.campaign,
            style: GoogleFonts.cinzel(
              color: accentColor.withValues(alpha: 0.5),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 3.0,
            ),
          ),
        ],
      ),
    );
  }
}
