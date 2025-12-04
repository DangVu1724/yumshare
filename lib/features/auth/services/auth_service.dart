import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yumshare/models/users.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------------- Register ----------------
  Future<Users> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Tạo user trên Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user == null) {
        throw Exception("User creation failed");
      }

      // Tạo Users object và lưu vào Firestore
      final userModel = Users(
        userId: user.uid,
        name: name,
        email: email,
        myRecipes: [],
        favoriteRecipes: [],
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Firebase Auth error");
    } catch (e) {
      throw Exception("Unknown error: $e");
    }
  }

  // ---------------- Sign In ----------------
  Future<Users> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Login Firebase Auth
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user == null) {
        throw Exception("Login failed");
      }

      // Lấy thông tin Users từ Firestore
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists || doc.data() == null) {
        throw Exception("User data not found in Firestore");
      }

      return Users.fromMap(doc.data()!);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Firebase Auth error");
    } catch (e) {
      throw Exception("Unknown error: $e");
    }
  }

  // ---------------- Sign Out ----------------
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Error signing out: $e");
    }
  }

  // ---------------- Current User ----------------
  User? get currentUser => _auth.currentUser;
}
