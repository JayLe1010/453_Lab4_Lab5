import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mortgage_app/main.dart';
import 'package:mortgage_app/mortgage.dart';
import 'package:mortgage_app/mortgage_provider.dart';

/// Builds the app the same way main() does, with the given saved data.
Future<void> launchApp(WidgetTester tester) async {
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => MortgageProvider(prefs),
      child: const MortgageApp(),
    ),
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Mortgage default values match the lab sample', () {
    final m = Mortgage();
    expect(m.formattedAmount, '\$100,000.00');
    expect(m.formattedMonthlyPayment(), '\$449.04');
    // The Java sample shows $161,654.66 due to float rounding; doubles give:
    expect(m.formattedTotalPayment(), '\$161,656.09');
  });

  testWidgets('Modify data and return with Done', (tester) async {
    await launchApp(tester);
    expect(find.text('\$449.04'), findsOneWidget);

    await tester.tap(find.text('MODIFY DATA'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('15'));
    await tester.enterText(find.byType(TextField), '200000');
    await tester.tap(find.text('2.25%'));
    await tester.pump();
    await tester.tap(find.text('DONE'));
    await tester.pumpAndSettle();

    expect(find.text('\$200,000.00'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
    expect(find.text('2.25%'), findsOneWidget);
  });

  testWidgets('Inputs are saved and restored after a relaunch',
      (tester) async {
    await launchApp(tester);
    await tester.tap(find.text('MODIFY DATA'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('10'));
    await tester.enterText(find.byType(TextField), '250000');
    await tester.tap(find.text('3.00%'));
    await tester.pump();
    await tester.tap(find.text('DONE'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getDouble('amount'), 250000);
    expect(prefs.getInt('years'), 10);
    expect(prefs.getDouble('rate'), closeTo(0.03, 1e-9));

    // Relaunch: a fresh widget tree and provider read the saved values.
    await tester.pumpWidget(const SizedBox());
    await launchApp(tester);
    expect(find.text('\$250,000.00'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('3%'), findsOneWidget);

    // The input screen shows the same data as in the last launch.
    await tester.tap(find.text('MODIFY DATA'));
    await tester.pumpAndSettle();
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, '250000.00');
    expect(find.text('Interest Rate: 3.00%'), findsOneWidget);
    final group = tester.widget<RadioGroup<int>>(find.byType(RadioGroup<int>));
    expect(group.groupValue, 10);
  });

  testWidgets('Terms checkbox asks for confirmation', (tester) async {
    await launchApp(tester);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.text('ACCEPT'));
    await tester.pumpAndSettle();
    final box = tester.widget<Checkbox>(find.byType(Checkbox));
    expect(box.value, isTrue);
  });
}
