import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yumshare/features/auth/services/auth_service.dart';
import 'package:yumshare/models/recipes.dart';

class RecipeRepository {
  final firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  Future<List<Recipe>> getMyRecipes() async {
    final userId = _authService.currentUser?.uid;
    final snapshot = await firestore.collection("recipes").where("authorId", isEqualTo: userId).get();

    return snapshot.docs.map((doc) => Recipe.fromMap(doc.data())).toList();
  }
}
