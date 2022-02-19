class Links {
  String game_rules, help, privacy_policy, terms_conditions;

  Links({
    required this.game_rules,
    required this.help,
    required this.privacy_policy,
    required this.terms_conditions,
  });

  Map<String, dynamic> toMap() {
    return {
      'game_rules': this.game_rules,
      'help': this.help,
      'privacy_policy': this.privacy_policy,
      'terms_conditions': this.terms_conditions,
    };
  }

  factory Links.fromMap(Map<String, dynamic> map) {
    return Links(
      game_rules: map['game_rules'] as String,
      help: map['help'] as String,
      privacy_policy: map['privacy_policy'] as String,
      terms_conditions: map['terms_conditions'] as String,
    );
  }
}