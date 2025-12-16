import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yumshare/features/auth/services/auth_service.dart';
import 'package:yumshare/features/discover/controllers/discover_controller.dart';
import 'package:yumshare/features/discover/controllers/search_controller.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/features/profile/controllers/profile_controller.dart';
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
      Get.toNamed(Routes.setup);
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
      Get.delete<DiscoverController>();
      Get.delete<DiscoverSearchController>();
      Get.delete<HomeController>();
      Get.delete<ProfileController>();
      Get.delete<AuthController>();
      isSignOut.value = true;
    } catch (e) {
      isSignOut.value = false;

      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> seedCountriesCollection() async {
    final firestore = FirebaseFirestore.instance;

    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/independent?status=true'));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch countries');
    }

    final List data = jsonDecode(response.body);

    final batch = firestore.batch();

    for (final country in data) {
      final String? code = country['cca2'];
      if (code == null) continue;

      final String name = country['name']?['common'] ?? '';
      if (name.isEmpty) continue;

      final String flag = country['flags']?['png'] ?? country['flags']?['svg'] ?? '';

      if (flag.isEmpty) continue;

      final String adjective = country['demonyms']?['eng']?['m'] ?? country['demonyms']?['eng']?['f'] ?? name;

      final docRef = firestore.collection('countries').doc(code);

      batch.set(docRef, {"code": code, "name": name, "flag": flag, "adjective": adjective});
    }

    await batch.commit();
  }
}
