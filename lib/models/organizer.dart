class Organizer {
  String id;
  String name;
  String image_url;
  String website;

  Organizer({
    required this.id,
    required this.name,
    required this.image_url,
    required this.website,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'image_url': this.image_url,
      'website': this.website,
    };
  }

  factory Organizer.fromMap(Map<String, dynamic> map) {
    return Organizer(
      id: map['id'] as String,
      name: map['name'] as String,
      image_url: map['image_url'] as String,
      website: map['website'] as String,
    );
  }
}