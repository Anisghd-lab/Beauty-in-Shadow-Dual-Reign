import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/card_model.dart';
import '../../models/game_state.dart';
import '../../providers/game_controller.dart';

/// Representation of a single HUD gauge metric's visual configuration.
class _GaugeConfig {
  final int index;
  final String label;
  final IconData icon;
  final int value;
  final int delta;

  const _GaugeConfig({
    required this.index,
    required this.label,
    required this.icon,
    required this.value,
    required this.delta,
  });
}

/// The 4-gauge HUD bar displaying faction-specific meters and real-time
/// Reigns-style swipe impact preview indicators.
class GaugeBar extends StatelessWidget {
  /// Explicit [GameState] input (optional; falls back to [GameController] via Provider).
  final GameState? state;

  /// Active card (optional; used to inspect pending choices during swipe drag).
  final GameCard? currentCard;

  /// Current swipe direction preview (optional; none, left, or right).
  final SwipeDirection? swipePreview;

  const GaugeBar({
    super.key,
    this.state,
    this.currentCard,
    this.swipePreview,
  });

  @override
  Widget build(BuildContext context) {
    // Attempt to read from Provider if parameters are not explicitly passed
    GameController? controller;
    try {
      controller = context.watch<GameController?>();
    } catch (_) {
      controller = null;
    }

    final effectiveState = state ?? controller?.state ?? GameState.initial();
    final effectiveCard = currentCard ?? controller?.currentCard;
    final effectiveSwipe =
        swipePreview ?? controller?.swipePreview ?? SwipeDirection.none;

    // Inspect pending choice impact based on active card and swipe direction
    ChoiceImpact? activeChoice;
    if (effectiveCard != null) {
      if (effectiveSwipe == SwipeDirection.left) {
        activeChoice = effectiveCard.leftChoice;
      } else if (effectiveSwipe == SwipeDirection.right) {
        activeChoice = effectiveCard.rightChoice;
      }
    }

    final configs = _getConfigsForCampaign(effectiveState, activeChoice);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: configs.map(_buildGaugeItem).toList(),
        ),
      ),
    );
  }

  /// Builds the 4 gauge configurations based on the active campaign.
  List<_GaugeConfig> _getConfigsForCampaign(
    GameState state,
    ChoiceImpact? choice,
  ) {
    if (state.campaign == CampaignType.street) {
      return [
        _GaugeConfig(
          index: 1,
          label: 'Dignité',
          icon: Icons.psychology,
          value: state.gauge1,
          delta: choice?.deltaGauge1 ?? 0,
        ),
        _GaugeConfig(
          index: 2,
          label: 'Cash',
          icon: Icons.attach_money,
          value: state.gauge2,
          delta: choice?.deltaGauge2 ?? 0,
        ),
        _GaugeConfig(
          index: 3,
          label: 'Club',
          icon: Icons.stars,
          value: state.gauge3,
          delta: choice?.deltaGauge3 ?? 0,
        ),
        _GaugeConfig(
          index: 4,
          label: 'Discrétion',
          icon: Icons.visibility_off,
          value: state.gauge4,
          delta: choice?.deltaGauge4 ?? 0,
        ),
      ];
    } else {
      return [
        _GaugeConfig(
          index: 1,
          label: 'Prestige',
          icon: Icons.auto_awesome,
          value: state.gauge1,
          delta: choice?.deltaGauge1 ?? 0,
        ),
        _GaugeConfig(
          index: 2,
          label: 'Blanchiment',
          icon: Icons.account_balance,
          value: state.gauge2,
          delta: choice?.deltaGauge2 ?? 0,
        ),
        _GaugeConfig(
          index: 3,
          label: 'Impunité',
          icon: Icons.gavel,
          value: state.gauge3,
          delta: choice?.deltaGauge3 ?? 0,
        ),
        _GaugeConfig(
          index: 4,
          label: 'Clan',
          icon: Icons.shield,
          value: state.gauge4,
          delta: choice?.deltaGauge4 ?? 0,
        ),
      ];
    }
  }

  /// Renders a single gauge item with preview dot, circular track, icon, percentage, and label.
  Widget _buildGaugeItem(_GaugeConfig config) {
    final gaugeColor = _getGaugeColor(config.value);

    return Semantics(
      label: '${config.label}: ${config.value}%',
      child: Column(
        key: ValueKey('gauge_item_${config.index}'),
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Dynamic Reign-style preview indicator dot
          _buildPreviewDot(config.delta, config.index),
          const SizedBox(height: 2),

          // 2. Circular progress gauge with centered icon
          SizedBox(
            width: 44,
            height: 44,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: (config.value / 100.0).clamp(0.0, 1.0),
                  strokeWidth: 3.5,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(gaugeColor),
                ),
                Icon(
                  config.icon,
                  size: 20,
                  color: gaugeColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // 3. Percentage numeric indicator
          Text(
            '${config.value}%',
            key: ValueKey('gauge_value_${config.index}'),
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 1),

          // 4. Compact metric label
          Text(
            config.label,
            key: ValueKey('gauge_label_${config.index}'),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Renders the preview dot appearing above the gauge during card tilting.
  Widget _buildPreviewDot(int delta, int gaugeIndex) {
    final isVisible = delta != 0;
    final isPositive = delta > 0;
    final color = isPositive ? AppColors.statusGood : AppColors.statusDanger;

    // Scale dot size dynamically: larger diameter (8px) for high impact, standard (5px) for mild
    final double dotSize = delta.abs() >= 20 ? 8.0 : 5.0;

    return SizedBox(
      height: 10,
      child: Center(
        child: AnimatedOpacity(
          opacity: isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 180),
          child: AnimatedContainer(
            key: ValueKey('preview_dot_$gaugeIndex'),
            duration: const Duration(milliseconds: 180),
            width: isVisible ? dotSize : 0.0,
            height: isVisible ? dotSize : 0.0,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: isVisible
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.6),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  /// Color logic:
  /// - Danger Red if <= 20%
  /// - Warning Yellow if >= 80%
  /// - Good Green between 21% and 79%
  static Color _getGaugeColor(int value) {
    if (value <= 20) {
      return AppColors.statusDanger;
    } else if (value >= 80) {
      return AppColors.statusWarning;
    } else {
      return AppColors.statusGood;
    }
  }
}
