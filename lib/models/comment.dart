import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String recipeId;
  final String userId;
  final String userName;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? parentId; // null = comment gốc, != null = reply
  int likesCount;
  final List<String> likedBy;

  Comment({
    required this.id,
    required this.recipeId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.parentId,
    this.likesCount = 0,
    List<String>? likedBy,
  }) : likedBy = likedBy ?? [];

  factory Comment.fromMap(Map<String, dynamic> map, String id) {
    return Comment(
      id: id,
      recipeId: map['recipeId'],
      userId: map['userId'],
      content: map['content'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
      parentId: map['parentId'],
      likesCount: map['likesCount'] ?? 0,
      userName: map['userName'],
      likedBy: List<String>.from(map['likedBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'userId': userId,
      'userName': userName,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'parentId': parentId,
      'likesCount': likesCount,
      'likedBy': likedBy,
    };
  }
}
