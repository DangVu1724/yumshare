import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final String userId;
  final int value; // 1..5
  final DateTime createdAt;

  Rating({
    required this.userId,
    required this.value,
    required this.createdAt,
  });

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      userId: map['userId'],
      value: map['value'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'value': value,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
