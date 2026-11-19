/// One note with a title and a description.
class Note {
  Note({required this.id, required this.title, required this.description});

  final String id;
  String title;
  String description;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
  );
}
