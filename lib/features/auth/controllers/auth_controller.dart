import 'package:get/get.dart';
import 'package:yumshare/features/auth/pages/login_page.dart';
import 'package:yumshare/features/auth/services/auth_service.dart';
import 'package:yumshare/home.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  var isLoading = false.obs;

  Future<void> registerWithEmail({required String name, required String email, required String password}) async {
    try {
      isLoading.value = true;
      await _authService.registerWithEmail(name: name, email: email, password: password);
      Get.off(() => const LoginPage());
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
      Get.off(() => HomePage());
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _authService.signOut();
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
