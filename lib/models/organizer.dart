class Organizer {
  String id;
  String name;
  String image_url;

  Organizer({
    required this.id,
    required this.name,
    required this.image_url,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'image_url': this.image_url,
    };
  }

  factory Organizer.fromMap(Map<String, dynamic> map) {
    return Organizer(
      id: map['id'] as String,
      name: map['name'] as String,
      image_url: map['image_url'] as String,
    );
  }
}