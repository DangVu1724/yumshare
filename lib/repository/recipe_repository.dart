import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yumshare/features/auth/services/auth_service.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/models/users.dart';

class RecipeRepository {
  final firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  Future<List<Recipe>> getMyRecipes() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return [];

    final userDoc = await firestore.collection("users").doc(userId).get();

    if (!userDoc.exists) return [];

    final data = userDoc.data()!;
    final myRecipesIds = List<String>.from(data["myRecipes"] ?? []);

    if (myRecipesIds.isEmpty) return [];

    // Firestore giới hạn whereIn ≤ 10 phần tử → chia nhỏ nếu cần
    List<Recipe> allRecipes = [];

    final chunks = <List<String>>[];
    for (var i = 0; i < myRecipesIds.length; i += 10) {
      chunks.add(myRecipesIds.sublist(i, i + 10 > myRecipesIds.length ? myRecipesIds.length : i + 10));
    }

    for (var chunk in chunks) {
      final snapshot = await firestore.collection("recipes").where(FieldPath.documentId, whereIn: chunk).get();

      allRecipes.addAll(snapshot.docs.map((doc) => Recipe.fromMap(doc.data())));
    }

    return allRecipes;
  }

  Future<Map<String, Users>> fetchRecipesAuthors() async {
    final recipes = await getMyRecipes();
    final authorIds = recipes.map((e) => e.authorId).toSet().toList();
    if (authorIds.isEmpty) return {};

    final userSnapshot = await firestore.collection("users").where(FieldPath.documentId, whereIn: authorIds).get();

    final Map<String, Users> authors = {for (var doc in userSnapshot.docs) doc.id: Users.fromMap(doc.data())};
    return authors;
  }

  Future<List<Recipe>> getMyFavoriteRecipes() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return [];

    final userDoc = await firestore.collection("users").doc(userId).get();

    if (!userDoc.exists) return [];

    final data = userDoc.data()!;
    final favoriteIds = List<String>.from(data["favoriteRecipes"] ?? []);

    if (favoriteIds.isEmpty) return [];

    // Firestore giới hạn whereIn ≤ 10 phần tử → chia nhỏ nếu cần
    List<Recipe> allRecipes = [];

    final chunks = <List<String>>[];
    for (var i = 0; i < favoriteIds.length; i += 10) {
      chunks.add(favoriteIds.sublist(i, i + 10 > favoriteIds.length ? favoriteIds.length : i + 10));
    }

    for (var chunk in chunks) {
      final snapshot = await firestore.collection("recipes").where(FieldPath.documentId, whereIn: chunk).get();

      allRecipes.addAll(snapshot.docs.map((doc) => Recipe.fromMap(doc.data())));
    }

    return allRecipes;
  }

  Future<bool> toggleFavouriteRecipe(String recipeId) async {
    final userId = _authService.currentUser?.uid;

    final userRef = firestore.collection('users').doc(userId);
    final snapshot = await userRef.get();
    final user = Users.fromMap(snapshot.data()!);
    final favorites = [...user.favoriteRecipes];

    bool isNowFavorite;

    if (favorites.contains(recipeId)) {
      favorites.remove(recipeId);
      isNowFavorite = false;
    } else {
      favorites.add(recipeId);
      isNowFavorite = true;
    }

    await userRef.update({"favoriteRecipes": favorites});

    return isNowFavorite;
  }

  Future<Recipe?> findRecipeById(String id) async {
    final doc = await firestore.collection('recipes').doc(id).get();

    if (!doc.exists) return null;

    return Recipe.fromMap(doc.data()!);
  }

  Future<List<Recipe>> fetchAllRecipes() async {
    final snapshot = await firestore.collection('recipes').where('isShared', isEqualTo: true).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Recipe.fromMap({...data, 'id': doc.id});
    }).toList();
  }

}
