class UserInfo {
  String first_name, last_name, nickname;
  int age;
  String city;

  UserInfo({
    required this.first_name,
    required this.last_name,
    required this.nickname,
    required this.age,
    required this.city,
  });

  Map<String, dynamic> toMap() {
    return {
      'first_name': this.first_name,
      'last_name': this.last_name,
      'nickname': this.nickname,
      'age': this.age,
      'city': this.city,
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      first_name: map['first_name'] as String,
      last_name: map['last_name'] as String,
      nickname: map['nickname'] as String,
      age: map['age'] as int,
      city: map['city'] as String,
    );
  }
}