import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yumshare/models/comment.dart';

class CommentRepo {
  final firestore = FirebaseFirestore.instance;

  Future<void> addComment({
    required String recipeId,
    required String userId,
    required String userName,
    required String content,
    String? parentId,
  }) async {
    final ref = firestore.collection('recipes').doc(recipeId).collection('comments').doc();

    await ref.set({
      'recipeId': recipeId,
      'userId': userId,
      'userName': userName,
      'content': content,
      'parentId': parentId,
      'createdAt': FieldValue.serverTimestamp(),
      'likesCount': 0,
    });
  }

  Stream<List<Comment>> getComments(String recipeId) {
    return FirebaseFirestore.instance
        .collection('recipes')
        .doc(recipeId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((d) => Comment.fromMap(d.data(), d.id)).toList());
  }

  Future<void> toggleLike({
    required String recipeId,
    required String commentId,
    required String userId,
    required bool isLiked,
  }) async {
    final ref = firestore.collection('recipes').doc(recipeId).collection('comments').doc(commentId);

    await ref.update({
      'likedBy': isLiked ? FieldValue.arrayRemove([userId]) : FieldValue.arrayUnion([userId]),
      'likesCount': FieldValue.increment(isLiked ? -1 : 1),
    });
  }
}
