class Country {
  final String name;
  final String code;
  final String flag;

  Country({
    required this.name,
    required this.code,
    required this.flag,
  });

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      flag: map['flag'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'flag': flag,
    };
  }
}
