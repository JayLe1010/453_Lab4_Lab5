import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_note_saver/di/service_locator.dart';
import 'package:sqflite_note_saver/providers/note_provider.dart';
import 'package:sqflite_note_saver/ui/note_list_screen.dart';

void main() {
  // On Chrome (web), run SQLite in the browser. Notes are kept in the
  // browser's storage, so they are still there after closing the app.
  // On Android/iOS, the normal sqflite plugin is used.
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  setupLocator(); // Set up our dependencies
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteProvider()..fetchNotes(), // Create and fetch initial data
      child: MaterialApp(
        title: 'Sqflite Note Saver',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData.dark().copyWith(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const NoteListScreen(),
      ),
    );
  }
}
