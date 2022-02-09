class Contest{
  String id;
  String name;
  List<String> images;
  String description;
  int start_timestamp;
  int end_timestamp;
  String winner_id;
  String organizer_id;

  Contest({
    required this.id,
    required this.name,
    required this.images,
    required this.description,
    required this.start_timestamp,
    required this.end_timestamp,
    required this.winner_id,
    required this.organizer_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'images': this.images,
      'description': this.description,
      'start_timestamp': this.start_timestamp,
      'end_timestamp': this.end_timestamp,
      'winner_id': this.winner_id,
      'organizer_id': this.organizer_id,
    };
  }

  factory Contest.fromMap(Map<String, dynamic> map) {
    return Contest(
      id: map['id'] as String,
      name: map['name'] as String,
      images: map['images'] as List<String>,
      description: map['description'] as String,
      start_timestamp: map['start_timestamp'] as int,
      end_timestamp: map['end_timestamp'] as int,
      winner_id: map['winner_id'] as String,
      organizer_id: map['organizer_id'] as String,
    );
  }
}