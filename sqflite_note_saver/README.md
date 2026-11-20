# Code Lab 5 – Sqflite Note Saver with Edit (Flutter)

The note app from *MVVM, Repository, Singleton Pattern, and SQLite with
Flutter* (sqflite + Provider + get_it), modified so the user can edit notes.

## What was added

1. **Edit (pen) icon next to the delete icon.** Each note's card shows
   `Icons.edit` beside `Icons.delete`. Tapping the pen opens `AddNoteScreen`
   with the **Title** and **Description** inputs filled with that note's
   current values. The button reads **Update Note**; pressing it calls
   `NoteProvider.updateNote` → `NoteRepository.updateNote` →
   `DBHelper.updateNote`, which runs an SQL `UPDATE` on the note's `id`.
2. **Notes survive a restart.** Every note is stored in the SQLite file
   `notes.db`. When the app starts, `NoteProvider()..fetchNotes()` reads all
   notes back, including updated ones.

## Files (same layout as the code lab)

```
lib/
├── data/db_helper.dart          # Singleton DBHelper: CRUD on notes.db
├── data/note_model.dart         # Note model with toMap / fromMap
├── repository/note_repository.dart
├── providers/note_provider.dart # ViewModel (ChangeNotifier)
├── ui/note_list_screen.dart     # List with edit (pen) + delete icons
├── ui/add_note_screen.dart      # Add or edit a note
├── di/service_locator.dart      # get_it setup
└── main.dart
test/widget_test.dart            # add → edit → restart → delete, on real SQLite
```

## Run

### In Chrome

```sh
flutter pub get
flutter run -d chrome --web-port=8080
```

On the web, sqflite runs through `sqflite_common_ffi_web` (set up in
`main.dart`; it uses `web/sqlite3.wasm` and `web/sqflite_sw.js`). Notes are
kept in Chrome's storage for `localhost:8080`. **Always use the same
`--web-port`**: browser storage belongs to one port, so a different port shows
an empty list.

### On Android / iOS

```sh
flutter run
```

### Tests

```sh
flutter test
```
