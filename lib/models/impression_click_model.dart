class ImpressionClickModel {
  String id, user_id;
  int timestamp;

//<editor-fold desc="Data Methods">

  ImpressionClickModel({
    required this.id,
    required this.user_id,
    required this.timestamp,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImpressionClickModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          user_id == other.user_id &&
          timestamp == other.timestamp);

  @override
  int get hashCode => id.hashCode ^ user_id.hashCode ^ timestamp.hashCode;

  @override
  String toString() {
    return 'ImpressionClickModel{' + ' id: $id,' + ' user_id: $user_id,' + ' timestamp: $timestamp,' + '}';
  }

  ImpressionClickModel copyWith({
    String? id,
    String? user_id,
    int? timestamp,
  }) {
    return ImpressionClickModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'user_id': this.user_id,
      'timestamp': this.timestamp,
    };
  }

  factory ImpressionClickModel.fromMap(Map<String, dynamic> map) {
    return ImpressionClickModel(
      id: map['id'] as String,
      user_id: map['user_id'] as String,
      timestamp: map['timestamp'] as int,
    );
  }

//</editor-fold>
}