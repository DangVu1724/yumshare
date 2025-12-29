import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Notifications {
  final String id;
  final String userId;
  final String fromUserId;
  final String type;
  final String refId;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  Notifications({
    required this.id,
    required this.userId,
    required this.fromUserId,
    required this.type,
    required this.refId,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  Notifications copyWith({
    String? id,
    String? userId,
    String? fromUserId,
    String? type,
    String? refId,
    String? title,
    String? message,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return Notifications(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fromUserId: fromUserId ?? this.fromUserId,
      type: type ?? this.type,
      refId: refId ?? this.refId,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'fromUserId': fromUserId,
      'type': type,
      'refId': refId,
      'title': title,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
    };
  }

  factory Notifications.fromMap(Map<String, dynamic> map, String id) {
    final createdAtRaw = map['createdAt'];

    return Notifications(
      id: id,
      userId: map['userId'] ?? '',
      fromUserId: map['fromUserId'] ?? '',
      type: map['type'] ?? '',
      refId: map['refId'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      createdAt: createdAtRaw is Timestamp
          ? createdAtRaw.toDate()
          : createdAtRaw is int
          ? DateTime.fromMillisecondsSinceEpoch(createdAtRaw)
          : DateTime.now(),
      isRead: map['isRead'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notifications.fromJson(String source) {
    final map = json.decode(source) as Map<String, dynamic>;
    return Notifications.fromMap(map, map['id'] as String);
  }

  @override
  String toString() {
    return 'Notifications(userId: $userId, fromUserId: $fromUserId, type: $type, refId: $refId, title: $title, message: $message, createdAt: $createdAt, isRead: $isRead)';
  }

  @override
  bool operator ==(covariant Notifications other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.fromUserId == fromUserId &&
        other.type == type &&
        other.refId == refId &&
        other.title == title &&
        other.message == message &&
        other.createdAt == createdAt &&
        other.isRead == isRead;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        fromUserId.hashCode ^
        type.hashCode ^
        refId.hashCode ^
        title.hashCode ^
        message.hashCode ^
        createdAt.hashCode ^
        isRead.hashCode;
  }
}
