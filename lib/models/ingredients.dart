import 'dart:convert';
class Ingredients {
  final String ingredientId;
  String description;

  Ingredients({
    required this.ingredientId,
    required this.description,
  });

  Ingredients copyWith({String? ingredientId, String? description}) {
    return Ingredients(
      ingredientId: ingredientId ?? this.ingredientId,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ingredientId': ingredientId,
      'description': description,
    };
  }

  factory Ingredients.fromMap(Map<String, dynamic> map) {
    return Ingredients(
      ingredientId: map['ingredientId'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ingredients.fromJson(String source) => Ingredients.fromMap(json.decode(source) as Map<String, dynamic>);
}
