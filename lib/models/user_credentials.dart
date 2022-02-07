class UserCredentials{
  String id, email, password, phone, image_url;

  UserCredentials({
    required this.id,
    required this.email,
    required this.password,
    required this.phone,
    required this.image_url,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'email': this.email,
      'password': this.password,
      'phone': this.phone,
      'image_url': this.image_url,
    };
  }

  factory UserCredentials.fromMap(Map<String, dynamic> map) {
    return UserCredentials(
      id: map['id'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      phone: map['phone'] as String,
      image_url: map['image_url'] as String,
    );
  }
}