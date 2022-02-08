import 'package:fenua_contests/models/user_credentials.dart';

class UserInfo extends UserCredentials {
  String first_name, last_name, nickname;
  String age;
  String city;
  bool checked_0, checked_1, checked_2;

  Map<String, dynamic> toMap() {
    return {
      'first_name': this.first_name,
      'last_name': this.last_name,
      'nickname': this.nickname,
      'age': this.age,
      'city': this.city,
      'checked_0': this.checked_0,
      'checked_1': this.checked_1,
      'checked_2': this.checked_2,
      'id': this.id,
      'email': this.email,
      'password': this.password,
      'phone': this.phone,
      'image_url': this.image_url,
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      first_name: map['first_name'] as String,
      last_name: map['last_name'] as String,
      nickname: map['nickname'] as String,
      age: map['age'] as String,
      city: map['city'] as String,
      checked_0: map['checked_0'] as bool,
      checked_1: map['checked_1'] as bool,
      checked_2: map['checked_2'] as bool,
      id: map['id'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      phone: map['phone'] as String,
      image_url: map['image_url'] as String,
    );
  }

  UserInfo({
    required this.first_name,
    required this.last_name,
    required this.nickname,
    required this.age,
    required this.city,
    required this.checked_0,
    required this.checked_1,
    required this.checked_2,
    required String id,
    required String email,
    required String password,
    required String phone,
    required String image_url,
  }) : super(
            id: id,
            email: email,
            password: password,
            phone: phone,
            image_url: image_url);
}
