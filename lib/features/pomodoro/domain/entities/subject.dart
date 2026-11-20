/// A study subject/category. Stored in the existing `Tags` table.
class Subject {
  const Subject({this.id, required this.name, required this.colorHex});

  final int? id;
  final String name;
  final String colorHex;

  Subject copyWith({int? id, String? name, String? colorHex}) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
    );
  }
}
