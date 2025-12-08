import 'package:get/get.dart';
import 'package:yumshare/features/auth/services/auth_service.dart';
import 'package:yumshare/routers/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  var isLoading = false.obs;
  RxBool isLoggedIn = false.obs;
  RxBool isSignOut = false.obs;

  Future<void> registerWithEmail({required String name, required String email, required String password}) async {
    try {
      isLoading.value = true;
      await _authService.registerWithEmail(name: name, email: email, password: password);
      Get.toNamed(Routes.login);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithEmail({required String email, required String password}) async {
    try {
      isLoading.value = true;
      await _authService.signInWithEmail(email: email, password: password);
      isLoggedIn.value = true;
    } catch (e) {
      isLoggedIn.value = false;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _authService.signOut();
      isSignOut.value = true;
    } catch (e) {
      isSignOut.value = false;

      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
