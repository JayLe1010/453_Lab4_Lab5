import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'note.dart';

/// Holds the notes and saves every change to SharedPreferences,
/// so the notes (including edited ones) come back after a restart.
class NotesProvider extends ChangeNotifier {
  NotesProvider(this._prefs) {
    _load();
  }

  static const String storageKey = 'notes';

  final SharedPreferences _prefs;
  final List<Note> _notes = [];

  List<Note> get notes => List.unmodifiable(_notes);

  void _load() {
    final saved = _prefs.getString(storageKey);
    if (saved == null) return;
    final list = jsonDecode(saved) as List<dynamic>;
    _notes.addAll(list.map((e) => Note.fromJson(e as Map<String, dynamic>)));
  }

  Future<void> _save() async {
    await _prefs.setString(
      storageKey,
      jsonEncode(_notes.map((n) => n.toJson()).toList()),
    );
  }

  Future<void> addNote(String title, String description) async {
    _notes.add(
      Note(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        description: description,
      ),
    );
    notifyListeners();
    await _save();
  }

  /// Updates the title and description of an existing note.
  Future<void> updateNote(String id, String title, String description) async {
    final note = _notes.firstWhere((n) => n.id == id);
    note.title = title;
    note.description = description;
    notifyListeners();
    await _save();
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
    await _save();
  }
}
