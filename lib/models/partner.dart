class Partner{
  String id, name, business_name, email, phone, password, image_url;
  int joining_time;

//<editor-fold desc="Data Methods">

  Partner({
    required this.id,
    required this.name,
    required this.business_name,
    required this.email,
    required this.phone,
    required this.password,
    required this.image_url,
    required this.joining_time,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Partner &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          business_name == other.business_name &&
          email == other.email &&
          phone == other.phone &&
          password == other.password &&
          image_url == other.image_url &&
          joining_time == other.joining_time);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      business_name.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      password.hashCode ^
      image_url.hashCode ^
      joining_time.hashCode;

  @override
  String toString() {
    return 'Partner{' +
        ' id: $id,' +
        ' name: $name,' +
        ' business_name: $business_name,' +
        ' email: $email,' +
        ' phone: $phone,' +
        ' password: $password,' +
        ' image_url: $image_url,' +
        ' joining_time: $joining_time,' +
        '}';
  }

  Partner copyWith({
    String? id,
    String? name,
    String? business_name,
    String? email,
    String? phone,
    String? password,
    String? image_url,
    int? joining_time,
  }) {
    return Partner(
      id: id ?? this.id,
      name: name ?? this.name,
      business_name: business_name ?? this.business_name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      image_url: image_url ?? this.image_url,
      joining_time: joining_time ?? this.joining_time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'business_name': this.business_name,
      'email': this.email,
      'phone': this.phone,
      'password': this.password,
      'image_url': this.image_url,
      'joining_time': this.joining_time,
    };
  }

  factory Partner.fromMap(Map<String, dynamic> map) {
    return Partner(
      id: map['id'] as String,
      name: map['name'] as String,
      business_name: map['business_name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      password: map['password'] as String,
      image_url: map['image_url'] as String,
      joining_time: map['joining_time'] as int,
    );
  }

//</editor-fold>
}