import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beauty_in_shadow/main.dart';

void main() {
  testWidgets('BeautyInShadowApp boots into MenuScreen smoke test',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const BeautyInShadowApp());
    await tester.pumpAndSettle();

    expect(find.text('LA RUE & LA NUIT'), findsOneWidget);
    expect(find.text('L\'EMPIRE BELL'), findsOneWidget);
    expect(find.text('BEAUTY IN SHADOW: DUAL REIGN'), findsOneWidget);
  });
}
