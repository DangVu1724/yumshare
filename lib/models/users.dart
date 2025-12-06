// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Users {
  final String userId;
  final String name;
  final String email;
  final List<String> myRecipes;
  final List<String> favoriteRecipes;
  final String? photoUrl;

  Users({
    required this.userId,
    required this.name,
    required this.email,
    required this.myRecipes,
    required this.favoriteRecipes,
    this.photoUrl,
  });

  Users copyWith({
    String? userId,
    String? name,
    String? email,
    List<String>? myRecipes,
    List<String>? favoriteRecipes,
    String? photoUrl,
  }) {
    return Users(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      myRecipes: myRecipes ?? this.myRecipes,
      favoriteRecipes: favoriteRecipes ?? this.favoriteRecipes,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'email': email,
      'myRecipes': myRecipes,
      'favoriteRecipes': favoriteRecipes,
      'photoUrl': photoUrl,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      myRecipes: (map['myRecipes'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      favoriteRecipes: (map['favoriteRecipes'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) => Users.fromMap(json.decode(source) as Map<String, dynamic>);
}
