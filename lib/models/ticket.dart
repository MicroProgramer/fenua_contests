class Ticket {
  String id;
  int timestamp;
  String user_id;

  Ticket({
    required this.id,
    required this.timestamp,
    required this.user_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'timestamp': this.timestamp,
      'user_id': this.user_id,
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'] as String,
      timestamp: map['timestamp'] as int,
      user_id: map['user_id'] as String,
    );
  }
}
