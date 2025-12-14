import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/models/country.dart';

class UserSetupController extends GetxController {
  final RxInt step = 0.obs;

  final RxString country = ''.obs;
  final RxList<String> favoriteFoods = <String>[].obs;
  final RxString cookingLevel = ''.obs;
  final RxList<Country> countries = <Country>[].obs;
  final searchController = TextEditingController();
  final filteredCountries = <Country>[].obs;
  final isLoadingCountry = false.obs;

  final firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchCountryData();
    filteredCountries.assignAll(countries);

    searchController.addListener(() {
      filterCountries(searchController.text);
    });
  }

  Future<void> fetchCountryData() async {
    try {
      isLoadingCountry.value = true;

      final querySnapshot = await firestore.collection('countries').orderBy('name').get();

      final fetchedCountries = querySnapshot.docs.map((doc) => Country.fromMap(doc.data())).toList();

      countries.assignAll(fetchedCountries);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load countries');
    } finally {
      isLoadingCountry.value = false;
    }
  }

  void filterCountries(String query) {
    if (query.isEmpty) {
      filteredCountries.assignAll(countries);
    } else {
      final filtered = countries.where((country) {
        return country.name.toLowerCase().contains(query.toLowerCase()) ||
            country.code.toLowerCase().contains(query.toLowerCase());
      }).toList();
      filteredCountries.assignAll(filtered);
    }
  }

  Future<void> submitSetup({required String country, List<String>? categories, required String cookingLevel}) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await firestore.collection('users').doc(userId).update({
        'country': country,
        'favoriteCategories': categories ?? [],
        'cookingLevel': cookingLevel,
      });
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void selectedCountry(String value) {
    country.value = value;
    next();
  }

  void next() {
    if (step.value < 2) step.value++;
  }

  void back() {
    if (step.value > 0) step.value--;
  }

  double get progress => (step.value + 1) / 3;
}
