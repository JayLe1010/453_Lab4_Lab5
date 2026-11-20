import 'package:get_it/get_it.dart';
import 'package:sqflite_note_saver/repository/note_repository.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Guard so calling setupLocator() twice (e.g. in tests) does not throw.
  if (!getIt.isRegistered<NoteRepository>()) {
    getIt.registerLazySingleton(() => NoteRepository());
  }
}
