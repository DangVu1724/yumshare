import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yumshare/features/auth/services/auth_service.dart';
import 'package:yumshare/models/users.dart';

class UserRepository {
  final firestore = FirebaseFirestore.instance;
  final _authService = AuthService();

  Future<Users> fetchUserData() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final userDoc = await firestore.collection("users").doc(userId).get();
    return Users.fromMap(userDoc.data() ?? {});
  }
}
