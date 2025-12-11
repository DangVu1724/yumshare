import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:yumshare/features/auth/services/auth_service.dart';
import 'package:yumshare/models/users.dart';

class UserRepository {
  final firestore = FirebaseFirestore.instance;
  final _authService = AuthService();
  var logger = Logger();

  Future<Users> fetchUserData() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final userDoc = await firestore.collection("users").doc(userId).get();
    return Users.fromMap(userDoc.data() ?? {});
  }

  Future<void> updateUserFields(Map<String, dynamic> fields) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;

    await firestore.collection('users').doc(uid).update(fields);
  }

  Future<List<Users>> fetchTopUsers({int minRecipes = 10}) async {
    try {
      final snapshot = await firestore
          .collection("users")
          .where("publishedRecipesCount", isGreaterThanOrEqualTo: minRecipes)
          .get();

      final topUsers = snapshot.docs.map((doc) => Users.fromMap(doc.data())).toList()
        ..sort((a, b) => b.publishedRecipesCount.compareTo(a.publishedRecipesCount));

      return topUsers;
    } catch (e) {
      logger.d("Error fetching top users: $e");
      return [];
    }
  }

  Future<void> followUser(String chefId) async {
    final currentId = _authService.currentUser?.uid;

    final chefRef = firestore.collection("users").doc(chefId);
    final currentRef = firestore.collection("users").doc(currentId);

    await chefRef.update({
      "followers": FieldValue.arrayUnion([currentId]),
    });

    await currentRef.update({
      "following": FieldValue.arrayUnion([chefId]),
    });
  }

  Future<void> unfollowUser(String chefId) async {
    final currentId = _authService.currentUser?.uid;

    final chefRef = firestore.collection("users").doc(chefId);
    final currentRef = firestore.collection("users").doc(currentId);

    await chefRef.update({
      "followers": FieldValue.arrayRemove([currentId]),
    });

    await currentRef.update({
      "following": FieldValue.arrayRemove([chefId]),
    });
  }
}
