import 'package:flutter/material.dart';
import 'package:sqflite_note_saver/data/note_model.dart';
import 'package:sqflite_note_saver/di/service_locator.dart';
import 'package:sqflite_note_saver/repository/note_repository.dart';

class NoteProvider extends ChangeNotifier {
  final NoteRepository _repository = getIt<NoteRepository>();
  List<Note> _notes = [];
  bool _isLoading = false;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  Future<void> fetchNotes() async {
    _isLoading = true;
    notifyListeners(); // Notify UI to show a loading indicator
    _notes = await _repository.getNotes();
    _isLoading = false;
    notifyListeners(); // Notify UI with the new data
  }

  Future<void> addNote(Note note) async {
    await _repository.insertNote(note);
    await fetchNotes(); // Refresh the list
  }

  // Called when the user saves changes made after tapping the edit (pen) icon.
  Future<void> updateNote(Note note) async {
    await _repository.updateNote(note);
    await fetchNotes(); // Refresh the list
  }

  Future<void> deleteNote(int id) async {
    await _repository.deleteNote(id);
    await fetchNotes(); // Refresh the list
  }
}
