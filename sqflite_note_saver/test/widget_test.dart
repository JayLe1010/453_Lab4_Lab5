import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:sqflite_note_saver/data/db_helper.dart';
import 'package:sqflite_note_saver/di/service_locator.dart';
import 'package:sqflite_note_saver/main.dart';

void main() {
  // Run the real SQLite database on the desktop for tests.
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  setupLocator();

  // Lets real database I/O finish, then lets the UI settle.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
  }

  setUp(() async {
    await DBHelper().close();
    await databaseFactory.deleteDatabase(
      join(await getDatabasesPath(), 'notes.db'),
    );
  });

  testWidgets('pen icon edits a note, and it is still there after restart', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await settle(tester);
    expect(find.text('No notes yet. Tap + to add one!'), findsOneWidget);

    // Add a note.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('titleField')), 'Groceries');
    await tester.enterText(find.byKey(const Key('descriptionField')), 'Milk');
    await tester.tap(find.text('Save Note'));
    await settle(tester);
    expect(find.text('Groceries'), findsOneWidget);

    // The pen icon is next to the delete icon.
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);

    // Tap the pen: the inputs open filled with the note's values.
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    expect(find.text('Edit Note'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Groceries'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Milk'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('titleField')), 'Shopping');
    await tester.enterText(
      find.byKey(const Key('descriptionField')),
      'Milk and eggs',
    );
    await tester.tap(find.text('Update Note'));
    await settle(tester);

    expect(find.text('Shopping'), findsOneWidget);
    expect(find.text('Milk and eggs'), findsOneWidget);
    expect(find.text('Groceries'), findsNothing);

    // "Close" the app: remove it and close the database connection.
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(() => DBHelper().close());

    // "Rerun" the app: notes are loaded again from notes.db.
    await tester.pumpWidget(const MyApp());
    await settle(tester);
    expect(find.text('Shopping'), findsOneWidget);
    expect(find.text('Milk and eggs'), findsOneWidget);

    // Delete still works.
    await tester.tap(find.byIcon(Icons.delete));
    await settle(tester);
    expect(find.text('Shopping'), findsNothing);

    await tester.runAsync(() => DBHelper().close());
  });
}
