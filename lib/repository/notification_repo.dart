import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yumshare/models/enums/notification_type.dart';
import 'package:yumshare/models/notifications.dart';

class NotificationRepo {
  final _ref = FirebaseFirestore.instance.collection('notifications');

  Future<void> markAsRead(String notificationId) async {
    await _ref.doc(notificationId).update({'isRead': true});
  }

  Future<void> markAllAsRead(String userId) async {
    final querySnapshot = await _ref.where('userId', isEqualTo: userId).where('isRead', isEqualTo: false).get();

    final batch = FirebaseFirestore.instance.batch();

    for (var doc in querySnapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  Stream<List<Notifications>> streamNotifications(String userId) {
    return _ref
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Notifications.fromMap(doc.data(), doc.id)).toList());
  }

  /// LIKE → tạo 1 notification duy nhất
  Future<void> createLikeNotification({
    required String receiverId,
    required String fromUserId,
    required String recipeId,
    required String fromUserName,
  }) async {
    if (receiverId == fromUserId) return;

    final docId = 'like_${recipeId}_$fromUserId';

    await _ref.doc(docId).set({
      'userId': receiverId,
      'fromUserId': fromUserId,
      'type': NotificationType.like.name,
      'title': 'New like',
      'message': '$fromUserName liked your recipe.',
      'refId': recipeId,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// COMMENT → mỗi comment = 1 notification mới
  Future<void> createCommentNotification({
    required String receiverId,
    required String fromUserId,
    required String recipeId,
    required String fromUserName,
  }) async {
    if (receiverId == fromUserId) return;

    await _ref.add({
      'userId': receiverId,
      'fromUserId': fromUserId,
      'type': NotificationType.comment.name,
      'title': 'New comment',
      'message': '$fromUserName commented on your recipe.',
      'refId': recipeId,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// CREATE RECIPE → gửi cho follower
  Future<void> createNewRecipeNotifications({
    required List<String> receiverIds, // followers
    required String fromUserId,
    required String recipeId,
    required String fromUserName,
  }) async {
    final batch = FirebaseFirestore.instance.batch();

    for (final receiverId in receiverIds) {
      if (receiverId == fromUserId) continue;

      final docRef = _ref.doc(); 

      batch.set(docRef, {
        'userId': receiverId,
        'fromUserId': fromUserId,
        'type': NotificationType.createRecipe.name,
        'title': 'New recipe',
        'message': '$fromUserName shared a new recipe.',
        'refId': recipeId,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  /// FOLLOW → chỉ 1 notification duy nhất
  Future<void> createFollowNotification({
    required String receiverId,
    required String fromUserId,
    required String fromUserName,
  }) async {
    if (receiverId == fromUserId) return;

    final docId = 'follow_$fromUserId';

    await _ref.doc(docId).set({
      'userId': receiverId,
      'fromUserId': fromUserId,
      'type': NotificationType.follow.name,
      'title': 'New follower',
      'message': '$fromUserName started following you.',
      'refId': fromUserId,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
