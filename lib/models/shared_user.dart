class SharedUser {
  String _id;
  String _name;
  String _userType;

  SharedUser({
    required String id,
    required String name,
    required String userType,
  })  : _id = id,
        _name = name,
        _userType = userType;

  String get userType => _userType;

  set userType(String value) {
    _userType = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}