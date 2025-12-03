import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Ingredients {
  final String ingredientId;
  final String name;
  final double quantity;
  final String unit;
  final String description;

  Ingredients({
    required this.ingredientId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.description,
  });

  Ingredients copyWith({String? ingredientId, String? name, double? quantity, String? unit, String? description}) {
    return Ingredients(
      ingredientId: ingredientId ?? this.ingredientId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ingredientId': ingredientId,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'description': description,
    };
  }

  factory Ingredients.fromMap(Map<String, dynamic> map) {
    return Ingredients(
      ingredientId: map['ingredientId'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as double,
      unit: map['unit'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ingredients.fromJson(String source) => Ingredients.fromMap(json.decode(source) as Map<String, dynamic>);
}
