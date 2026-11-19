import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:notes_app/main.dart';
import 'package:notes_app/notes_provider.dart';

Future<void> pumpApp(WidgetTester tester) async {
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => NotesProvider(prefs),
      child: const NotesApp(),
    ),
  );
}

void main() {
  testWidgets('edit icon updates a note and it survives a restart', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await pumpApp(tester);

    await tester.enterText(find.byKey(const Key('addTitle')), 'Groceries');
    await tester.enterText(find.byKey(const Key('addDescription')), 'Milk');
    await tester.tap(find.text('ADD NOTE'));
    await tester.pumpAndSettle();
    expect(find.text('Groceries'), findsOneWidget);

    // Pen icon sits next to the delete icon.
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    expect(find.text('Edit Note'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('editTitle')), 'Shopping');
    await tester.enterText(
      find.byKey(const Key('editDescription')),
      'Milk and eggs',
    );
    await tester.tap(find.text('SAVE'));
    await tester.pumpAndSettle();

    expect(find.text('Shopping'), findsOneWidget);
    expect(find.text('Milk and eggs'), findsOneWidget);
    expect(find.text('Groceries'), findsNothing);

    // "Restart": build a fresh app from the same saved preferences.
    await tester.pumpWidget(const SizedBox());
    await pumpApp(tester);
    await tester.pumpAndSettle();
    expect(find.text('Shopping'), findsOneWidget);
    expect(find.text('Milk and eggs'), findsOneWidget);
  });

  testWidgets('cancel leaves the note unchanged', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await pumpApp(tester);

    await tester.enterText(find.byKey(const Key('addTitle')), 'Keep me');
    await tester.tap(find.text('ADD NOTE'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('editTitle')), 'Changed');
    await tester.tap(find.text('CANCEL'));
    await tester.pumpAndSettle();

    expect(find.text('Keep me'), findsOneWidget);
    expect(find.text('Changed'), findsNothing);
  });
}
