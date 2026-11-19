# Lab 5 – Notes App with Edit (Flutter)

A notes app that lets the user add, **edit**, and delete notes. Notes are
saved with SharedPreferences, so they survive closing and reopening the app.

## Edit feature

- Each note shows a **pen icon** (`Icons.edit`) next to the **delete icon**.
- Tapping the pen opens an **Edit Note** dialog with the Title and Description
  inputs filled with the note's current values.
- **SAVE** updates the note; **CANCEL** leaves it unchanged.
- Every add, edit, and delete is written to SharedPreferences right away, so
  after closing and rerunning the app all notes, including updated ones, are
  shown.

## Files

- `lib/note.dart` – the `Note` model (id, title, description) with JSON helpers
- `lib/notes_provider.dart` – Provider (`ChangeNotifier`) that holds the notes and saves them with SharedPreferences (`addNote`, `updateNote`, `deleteNote`)
- `lib/main.dart` – app entry point; loads SharedPreferences and creates the Provider
- `lib/screens/notes_screen.dart` – notes list, add form, edit/delete icons, and the `EditNoteDialog`
- `test/widget_test.dart` – widget tests for editing, cancelling, and reloading after a restart

## Run

```sh
cd notes_app
flutter pub get
flutter run
flutter test
```
