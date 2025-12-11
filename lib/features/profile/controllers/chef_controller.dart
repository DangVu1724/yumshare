import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:yumshare/features/auth/services/auth_service.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/repository/recipe_repository.dart';
import 'package:yumshare/repository/user_repository.dart';

class ChefProfileController extends GetxController {
  var chefRecipes = <Recipe>[].obs;
  var isLoading = false.obs;
  var isFollowing = false.obs;

  late final String? userId;

  final logger = Logger();
  final repo = RecipeRepository();
  final userRepo = UserRepository();
  final auth = AuthService();

  @override
  void onInit() {
    super.onInit();
    userId = auth.currentUser?.uid;
  }

  Future<void> loadChefRecipes(List<String> ids) async {
    try {
      isLoading.value = true;
      chefRecipes.value = await repo.getChefRecipeData(ids);
    } catch (e) {
      logger.e("Error loading chef recipes: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkIfFollowing(String chefId) async {
    try {
      final current = await userRepo.fetchUserData();

      final list = current.following;
      isFollowing.value = list.contains(chefId);
    } catch (e) {
      logger.e("Error checking follow status: $e");
    }
  }

  Future<void> followUser(String chefId) async {
    try {
      await userRepo.followUser(chefId);
    } catch (e) {
      logger.e("Error following user: $e");
      rethrow;
    }
  }

  Future<void> unfollowUser(String chefId) async {
    try {
      await userRepo.unfollowUser(chefId);
    } catch (e) {
      logger.e("Error unfollowing user: $e");
      rethrow;
    }
  }

  /// Tự động đổi trạng thái follow + update Firestore
  Future<void> toggleFollow(String chefId) async {
    try {
      if (isFollowing.value) {
        await unfollowUser(chefId);
        isFollowing.value = false;
      } else {
        await followUser(chefId);
        isFollowing.value = true;
      }
    } catch (e) {
      logger.e("Error toggling follow: $e");
    }
  }
}
