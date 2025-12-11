import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/repository/recipe_repository.dart';
import 'package:yumshare/repository/user_repository.dart';

class ProfileController extends GetxController {
  Rxn<Users> userData = Rxn<Users>();

  var isLoading = false.obs;
  var logger = Logger();

  final userRepo = UserRepository();
  final reciepRepo = RecipeRepository();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      final user = await userRepo.fetchUserData();
      userData.value = user;
    } catch (e) {
      logger.d("Error fetching user: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({String? name, String? des, String? fb, String? wa, String? tw, String? photoUrl}) async {
    final current = userData.value;

    if (current == null) return;

    Map<String, dynamic> updateData = {};

    if (name != null && name != current.name) updateData['name'] = name;
    if (des != null && des != current.description) updateData['description'] = des;
    if (fb != null && fb != current.facebook) updateData['facebook'] = fb;
    if (wa != null && wa != current.whatsapp) updateData['whatsapp'] = wa;
    if (tw != null && tw != current.twitter) updateData['twitter'] = tw;
    if (photoUrl != null && photoUrl != current.photoUrl) updateData['photoUrl'] = photoUrl;

    if (updateData.isNotEmpty) {
      await userRepo.updateUserFields(updateData);
      await fetchUserData();
    }
  }

  Future<void> openLink(String? url) async {
    if (url == null || url.isEmpty) {
      Get.snackbar("Link not available", "User did not provide this information");
      return;
    }

    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Error", "Cannot open this link");
      }
    } catch (e) {
      Get.snackbar("Error", "Invalid Link Format");
    }
  }
}
