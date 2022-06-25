class Ad {
  String id, user_id;
  String title, description;
  int endTimestamp;
  String mediaUrl;
  String adType;
  String clickUrl;

//<editor-fold desc="Data Methods">

  Ad({
    required this.id,
    required this.user_id,
    required this.title,
    required this.description,
    required this.endTimestamp,
    required this.mediaUrl,
    required this.adType,
    required this.clickUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ad &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          user_id == other.user_id &&
          title == other.title &&
          description == other.description &&
          endTimestamp == other.endTimestamp &&
          mediaUrl == other.mediaUrl &&
          adType == other.adType &&
          clickUrl == other.clickUrl);

  @override
  int get hashCode =>
      id.hashCode ^
      user_id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      endTimestamp.hashCode ^
      mediaUrl.hashCode ^
      adType.hashCode ^
      clickUrl.hashCode;

  @override
  String toString() {
    return 'Ad{' +
        ' id: $id,' +
        ' user_id: $user_id,' +
        ' title: $title,' +
        ' description: $description,' +
        ' endTimestamp: $endTimestamp,' +
        ' mediaUrl: $mediaUrl,' +
        ' adType: $adType,' +
        ' clickUrl: $clickUrl,' +
        '}';
  }

  Ad copyWith({
    String? id,
    String? user_id,
    String? title,
    String? description,
    int? endTimestamp,
    String? mediaUrl,
    String? adType,
    String? clickUrl,
  }) {
    return Ad(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      title: title ?? this.title,
      description: description ?? this.description,
      endTimestamp: endTimestamp ?? this.endTimestamp,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      adType: adType ?? this.adType,
      clickUrl: clickUrl ?? this.clickUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'user_id': this.user_id,
      'title': this.title,
      'description': this.description,
      'endTimestamp': this.endTimestamp,
      'mediaUrl': this.mediaUrl,
      'adType': this.adType,
      'clickUrl': this.clickUrl,
    };
  }

  factory Ad.fromMap(Map<String, dynamic> map) {
    return Ad(
      id: map['id'] as String,
      user_id: map['user_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      endTimestamp: map['endTimestamp'] as int,
      mediaUrl: map['mediaUrl'] as String,
      adType: map['adType'] as String,
      clickUrl: map['clickUrl'] as String,
    );
  }

//</editor-fold>
}