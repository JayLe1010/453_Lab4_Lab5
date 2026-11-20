import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_note_saver/data/note_model.dart';
import 'package:sqflite_note_saver/providers/note_provider.dart';

/// Screen for adding a new note, or editing an existing one.
/// When [note] is given (from the edit/pen icon), the title and
/// description inputs start with that note's current values.
class AddNoteScreen extends StatefulWidget {
  final Note? note;

  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    // Pre-fill the inputs with the existing note when editing.
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.note?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final note = Note(
        id: widget.note?.id, // keep the same id when editing
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      // Use the provider to save the note
      final provider = context.read<NoteProvider>();
      if (widget.note == null) {
        await provider.addNote(note);
      } else {
        await provider.updateNote(note);
      }
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Note' : 'Add Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key('titleField'),
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('descriptionField'),
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveNote,
                  child: Text(_isEditing ? 'Update Note' : 'Save Note'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
