import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:beauty_in_shadow/core/constants/app_colors.dart';
import 'package:beauty_in_shadow/models/card_model.dart';
import 'package:beauty_in_shadow/models/game_state.dart';
import 'package:beauty_in_shadow/providers/game_controller.dart';
import 'package:beauty_in_shadow/ui/widgets/gauge_bar.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  const testCard = GameCard(
    id: 'test_card_01',
    campaign: 'STREET',
    speakerName: 'Tester',
    speakerRole: 'Role',
    speakerAvatar: 'assets/test.png',
    dialogue: 'Test dialogue',
    leftChoice: ChoiceImpact(
      text: 'Option Gauche',
      deltaGauge1: 25, // Large positive impact (|25| >= 20) -> Green, 8px
      deltaGauge2: -10, // Mild negative impact (|-10| < 20) -> Red, 5px
      deltaGauge3: 0, // No impact -> Hidden
      deltaGauge4: -30, // Large negative impact -> Red, 8px
    ),
    rightChoice: ChoiceImpact(
      text: 'Option Droite',
      deltaGauge1: -15, // Mild negative
      deltaGauge2: 20, // Large positive
      deltaGauge3: 10, // Mild positive
      deltaGauge4: 0, // No impact
    ),
  );

  group('GaugeBar - Street Campaign Rendering', () {
    testWidgets('Renders all 4 Street labels and icons', (tester) async {
      final state = GameState(
        campaign: CampaignType.street,
        gauge1: 50,
        gauge2: 50,
        gauge3: 50,
        gauge4: 50,
      );

      await tester.pumpWidget(
        buildTestableWidget(
          GaugeBar(
            state: state,
            currentCard: testCard,
            swipePreview: SwipeDirection.none,
          ),
        ),
      );

      // Verify labels
      expect(find.text('Dignité'), findsOneWidget);
      expect(find.text('Cash'), findsOneWidget);
      expect(find.text('Club'), findsOneWidget);
      expect(find.text('Discrétion'), findsOneWidget);

      // Verify icons
      expect(find.byIcon(Icons.psychology), findsOneWidget);
      expect(find.byIcon(Icons.attach_money), findsOneWidget);
      expect(find.byIcon(Icons.stars), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Verify percentages
      expect(find.text('50%'), findsNWidgets(4));
    });
  });

  group('GaugeBar - Empire Campaign Rendering', () {
    testWidgets('Renders all 4 Empire labels and icons', (tester) async {
      final state = GameState(
        campaign: CampaignType.empire,
        gauge1: 60,
        gauge2: 40,
        gauge3: 85,
        gauge4: 15,
      );

      await tester.pumpWidget(
        buildTestableWidget(
          GaugeBar(
            state: state,
            swipePreview: SwipeDirection.none,
          ),
        ),
      );

      // Verify labels
      expect(find.text('Prestige'), findsOneWidget);
      expect(find.text('Blanchiment'), findsOneWidget);
      expect(find.text('Impunité'), findsOneWidget);
      expect(find.text('Clan'), findsOneWidget);

      // Verify icons
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
      expect(find.byIcon(Icons.account_balance), findsOneWidget);
      expect(find.byIcon(Icons.gavel), findsOneWidget);
      expect(find.byIcon(Icons.shield), findsOneWidget);

      // Verify percentages
      expect(find.text('60%'), findsOneWidget);
      expect(find.text('40%'), findsOneWidget);
      expect(find.text('85%'), findsOneWidget);
      expect(find.text('15%'), findsOneWidget);
    });
  });

  group('GaugeBar - Value Color Thresholds', () {
    testWidgets('Applies correct colors for danger, warning and good thresholds', (tester) async {
      final state = GameState(
        campaign: CampaignType.street,
        gauge1: 15, // <= 20% -> Danger Red
        gauge2: 50, // 21%..79% -> Normal Green
        gauge3: 85, // >= 80% -> Warning Yellow
        gauge4: 20, // <= 20% -> Danger Red
      );

      await tester.pumpWidget(
        buildTestableWidget(
          GaugeBar(state: state),
        ),
      );

      // Inspect CircularProgressIndicators
      final indicators = tester
          .widgetList<CircularProgressIndicator>(find.byType(CircularProgressIndicator))
          .toList();
      expect(indicators.length, 4);

      // Gauge 1 (15%): Danger Red
      final color1 = (indicators[0].valueColor as AlwaysStoppedAnimation<Color>).value;
      expect(color1, AppColors.statusDanger);

      // Gauge 2 (50%): Normal Green
      final color2 = (indicators[1].valueColor as AlwaysStoppedAnimation<Color>).value;
      expect(color2, AppColors.statusGood);

      // Gauge 3 (85%): Warning Yellow
      final color3 = (indicators[2].valueColor as AlwaysStoppedAnimation<Color>).value;
      expect(color3, AppColors.statusWarning);

      // Gauge 4 (20%): Danger Red
      final color4 = (indicators[3].valueColor as AlwaysStoppedAnimation<Color>).value;
      expect(color4, AppColors.statusDanger);
    });
  });

  group('GaugeBar - Dynamic Preview Dots (Reigns Mechanic)', () {
    testWidgets('Dots are hidden when swipePreview is none', (tester) async {
      final state = GameState(campaign: CampaignType.street);

      await tester.pumpWidget(
        buildTestableWidget(
          GaugeBar(
            state: state,
            currentCard: testCard,
            swipePreview: SwipeDirection.none,
          ),
        ),
      );

      // AnimatedOpacities for dots should be 0.0
      final opacities = tester
          .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
          .toList();
      expect(opacities.length, 4);
      for (final op in opacities) {
        expect(op.opacity, 0.0);
      }
    });

    testWidgets('Left swipe shows green dot for positive, red for negative, none for zero',
        (tester) async {
      final state = GameState(campaign: CampaignType.street);

      // Left choice:
      // deltaGauge1: +25 (Large positive -> Green, 8px)
      // deltaGauge2: -10 (Mild negative -> Red, 5px)
      // deltaGauge3: 0   (Zero -> Hidden)
      // deltaGauge4: -30 (Large negative -> Red, 8px)
      await tester.pumpWidget(
        buildTestableWidget(
          GaugeBar(
            state: state,
            currentCard: testCard,
            swipePreview: SwipeDirection.left,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check opacities
      final opacities = tester
          .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
          .toList();
      expect(opacities[0].opacity, 1.0); // Gauge 1 (+25)
      expect(opacities[1].opacity, 1.0); // Gauge 2 (-10)
      expect(opacities[2].opacity, 0.0); // Gauge 3 (0)
      expect(opacities[3].opacity, 1.0); // Gauge 4 (-30)

      // Check colors and container sizes
      final container1 = tester.widget<AnimatedContainer>(find.byKey(const ValueKey('preview_dot_1')));
      final decor1 = container1.decoration as BoxDecoration;
      expect(decor1.color, AppColors.statusGood); // Green for positive
      expect(container1.constraints?.maxWidth, 8.0); // Large dot

      final container2 = tester.widget<AnimatedContainer>(find.byKey(const ValueKey('preview_dot_2')));
      final decor2 = container2.decoration as BoxDecoration;
      expect(decor2.color, AppColors.statusDanger); // Red for negative
      expect(container2.constraints?.maxWidth, 5.0); // Mild dot

      final container4 = tester.widget<AnimatedContainer>(find.byKey(const ValueKey('preview_dot_4')));
      final decor4 = container4.decoration as BoxDecoration;
      expect(decor4.color, AppColors.statusDanger); // Red for negative
      expect(container4.constraints?.maxWidth, 8.0); // Large dot
    });

    testWidgets('Right swipe updates preview indicators accurately', (tester) async {
      final state = GameState(campaign: CampaignType.street);

      // Right choice:
      // deltaGauge1: -15 (Mild negative -> Red, 5px)
      // deltaGauge2: +20 (Large positive -> Green, 8px)
      // deltaGauge3: +10 (Mild positive -> Green, 5px)
      // deltaGauge4: 0   (Zero -> Hidden)
      await tester.pumpWidget(
        buildTestableWidget(
          GaugeBar(
            state: state,
            currentCard: testCard,
            swipePreview: SwipeDirection.right,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final opacities = tester
          .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
          .toList();
      expect(opacities[0].opacity, 1.0); // Gauge 1
      expect(opacities[1].opacity, 1.0); // Gauge 2
      expect(opacities[2].opacity, 1.0); // Gauge 3
      expect(opacities[3].opacity, 0.0); // Gauge 4 is 0

      // Gauge 2 (+20): Green, 8px
      final container2 = tester.widget<AnimatedContainer>(find.byKey(const ValueKey('preview_dot_2')));
      final decor2 = container2.decoration as BoxDecoration;
      expect(decor2.color, AppColors.statusGood);
      expect(container2.constraints?.maxWidth, 8.0);

      // Gauge 3 (+10): Green, 5px
      final container3 = tester.widget<AnimatedContainer>(find.byKey(const ValueKey('preview_dot_3')));
      final decor3 = container3.decoration as BoxDecoration;
      expect(decor3.color, AppColors.statusGood);
      expect(container3.constraints?.maxWidth, 5.0);
    });
  });

  group('GaugeBar - Provider Integration', () {
    testWidgets('Consumes GameController from Provider context automatically', (tester) async {
      const empireTestCard = GameCard(
        id: 'empire_test_01',
        campaign: 'EMPIRE',
        speakerName: 'Lord Test',
        speakerRole: 'Noblesse',
        speakerAvatar: 'assets/test.png',
        dialogue: 'Audience impériale',
        leftChoice: ChoiceImpact(text: 'Option A', deltaGauge1: 25),
        rightChoice: ChoiceImpact(text: 'Option B', deltaGauge1: -10),
      );

      final controller = GameController(
        initialState: GameState(
          campaign: CampaignType.empire,
          gauge1: 77,
          gauge2: 33,
          gauge3: 55,
          gauge4: 90,
        ),
        deck: [empireTestCard],
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<GameController>.value(
          value: controller,
          child: buildTestableWidget(
            const GaugeBar(),
          ),
        ),
      );

      expect(find.text('Prestige'), findsOneWidget);
      expect(find.text('77%'), findsOneWidget);
      expect(find.text('33%'), findsOneWidget);
      expect(find.text('55%'), findsOneWidget);
      expect(find.text('90%'), findsOneWidget);

      // Update preview in controller and verify widget reacts
      controller.setSwipePreview(SwipeDirection.left);
      await tester.pumpAndSettle();

      // Dot for gauge 1 (+25) should now be visible
      final container1 = tester.widget<AnimatedContainer>(find.byKey(const ValueKey('preview_dot_1')));
      final decor1 = container1.decoration as BoxDecoration;
      expect(decor1.color, AppColors.statusGood);
    });
  });
}
