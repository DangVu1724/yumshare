import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/auth/controllers/setup_controller.dart';
import 'package:yumshare/features/auth/pages/step/cooking_level_step.dart';
import 'package:yumshare/features/auth/pages/step/country_step.dart';
import 'package:yumshare/features/auth/pages/step/food_step.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

class UserSetupPage extends StatefulWidget {
  const UserSetupPage({super.key});

  @override
  State<UserSetupPage> createState() => _UserSetupPageState();
}

class _UserSetupPageState extends State<UserSetupPage> {
  final ctrl = Get.put(UserSetupController());
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    ever<int>(ctrl.step, (index) {
      pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(16),
                child: LinearProgressIndicator(
                  value: ctrl.progress,
                  minHeight: 12,
                  color: AppColors.primary,
                  backgroundColor: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  ctrl.step.value = index;
                },
                children: const [CountryStep(), FoodStep(), CookingLevelStep()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
