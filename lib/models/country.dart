class Country {
  final String name;
  final String code;
  final String flag;
  final String adjective;

  Country({
    required this.name,
    required this.code,
    required this.flag,
    required this.adjective,
  });

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      flag: map['flag'] ?? '',
      adjective: map['adjective'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'flag': flag,
      'adjective': adjective,
    };
  }
}
