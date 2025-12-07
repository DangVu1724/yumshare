import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/repository/user_repository.dart';

class ProfileController extends GetxController {
  Rxn<Users> userData = Rxn<Users>();
  var isLoading = false.obs;
  var logger = Logger();

  final userRepo = UserRepository();

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
}
