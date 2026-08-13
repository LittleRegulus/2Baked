import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_baked/app.dart';
import 'package:two_baked/app_controller.dart';
import 'package:two_baked/common_widgets.dart';
import 'package:two_baked/content.dart';
import 'package:two_baked/models.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows the responsive timer experience', (tester) async {
    final controller = AppController();
    await tester.pumpWidget(TwoBakedApp(controller: controller));
    await tester.pump();

    expect(find.text('2BAKED'), findsOneWidget);
    expect(find.text('YOUR SESSION COPILOT IS WAKING UP'), findsOneWidget);
    expect(find.text('START SESSION'), findsNothing);

    await tester.pump(const Duration(milliseconds: 3500));
    await tester.pumpAndSettle();

    expect(find.text('Dial in your dab.'), findsOneWidget);
    expect(find.text('START SESSION'), findsOneWidget);
    expect(find.text('Daily driver'), findsWidgets);
  });

  test('preset and session entries round-trip through JSON maps', () {
    final preset = TimerPreset.fromJson(defaultPresets.first.toJson());
    expect(preset.name, 'Low & slow');
    expect(preset.totalSeconds, 90);

    final original = SessionEntry(
      timestamp: DateTime(2026, 8, 10, 19, 30),
      presetName: preset.name,
      heatSeconds: preset.heatSeconds,
      coolSeconds: preset.coolSeconds,
      gear: 'Quartz banger',
    );
    final restored = SessionEntry.fromJson(original.toJson());
    expect(restored.timestamp, original.timestamp);
    expect(restored.gear, 'Quartz banger');
  });

  test('duration formatting remains clock-like', () {
    expect(formatDuration(0), '00:00');
    expect(formatDuration(65), '01:05');
  });

  test('fact library contains fifty entries', () {
    expect(facts, hasLength(50));
  });

  test('hype voice pack includes the requested stoner energy', () {
    expect(
      hypeStartPrompts,
      contains('Get ready to get high as fuck. 2Baked is on the clock!'),
    );
    expect(hypePrompts.any((phrase) => phrase.contains('Wazzup')), isTrue);
  });
}
