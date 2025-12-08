// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String userId;
  final String name;
  final String email;
  final List<String> myRecipes;
  final List<String> favoriteRecipes;
  final List<String> followers;
  final List<String> following;
  final DateTime? createdAt;
  final String? description;
  final String? address;
  final String? facebook;
  final String? whatsapp;
  final String? twitter;
  final String? photoUrl;

  Users({
    required this.userId,
    required this.name,
    required this.email,
    required this.myRecipes,
    required this.favoriteRecipes,
    this.photoUrl,
    this.followers = const [],
    this.following = const [],
    this.address,
    this.description,
    this.facebook,
    this.twitter,
    this.whatsapp,
    required this.createdAt,
  });

  Users copyWith({
    String? userId,
    String? name,
    String? email,
    List<String>? myRecipes,
    List<String>? favoriteRecipes,
    List<String>? followers,
    List<String>? following,
    DateTime? createdAt,
    String? description,
    String? address,
    String? facebook,
    String? whatsapp,
    String? twitter,
    String? photoUrl,
  }) {
    return Users(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      myRecipes: myRecipes ?? this.myRecipes,
      favoriteRecipes: favoriteRecipes ?? this.favoriteRecipes,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      address: address ?? this.address,
      facebook: facebook ?? this.facebook,
      whatsapp: whatsapp ?? this.whatsapp,
      twitter: twitter ?? this.twitter,
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
      'followers': followers,
      'following': following,
      'description': description,
      'address': address,
      'facebook': facebook,
      'whatsapp': whatsapp,
      'twitter': twitter,
      'photoUrl': photoUrl,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      myRecipes: (map['myRecipes'] as List<dynamic>? ?? []).cast<String>(),
      favoriteRecipes: (map['favoriteRecipes'] as List<dynamic>? ?? []).cast<String>(),
      followers: (map['followers'] as List<dynamic>? ?? []).cast<String>(),
      following: (map['following'] as List<dynamic>? ?? []).cast<String>(),

      description: map['description'],
      address: map['address'],
      facebook: map['facebook'],
      whatsapp: map['whatsapp'],
      twitter: map['twitter'],
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) => Users.fromMap(json.decode(source) as Map<String, dynamic>);
}
