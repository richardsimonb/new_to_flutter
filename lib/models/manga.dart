class Manga {
  final String id;
  final String title;

  const Manga({
    required this.id,
    required this.title,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['id'] as String,
      title: json['attributes']['title']['en'] ?? "No Title",
    );
  }
}
