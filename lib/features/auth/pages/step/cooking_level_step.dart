import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/auth/controllers/setup_controller.dart';
import 'package:yumshare/routers/app_routes.dart';
import 'package:yumshare/utils/themes/text_style.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

class CookingLevelStep extends StatelessWidget {
  const CookingLevelStep({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UserSetupController>();

    final List<Map<String, String>> levels = [
      {"name": "Beginner", "icon": "🍳", "description": "Just starting out, learning basics"},
      {"name": "Amateur", "icon": "👨‍🍳", "description": "Can follow recipes well"},
      {"name": "Intermediate", "icon": "🔥", "description": "Comfortable with most techniques"},
      {"name": "Expert", "icon": "🏆", "description": "Create your own recipes"},
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            const Text('What is your cooking level?', style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Text(
              'Select your cooking experience for personalized recommendations.',
              style: AppTextStyles.small.copyWith(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 8),

            GetBuilder<UserSetupController>(
              builder: (controller) {
                return Text(
                  controller.cookingLevel.value.isNotEmpty
                      ? 'Selected: ${controller.cookingLevel.value}'
                      : 'Choose one level that best describes you',
                  style: TextStyle(
                    fontSize: 14,
                    color: controller.cookingLevel.value.isNotEmpty ? AppColors.primary : Colors.grey.shade500,
                    fontWeight: controller.cookingLevel.value.isNotEmpty ? FontWeight.w600 : FontWeight.normal,
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // GridView cho cooking levels - sử dụng GetBuilder
            GetBuilder<UserSetupController>(
              builder: (controller) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: levels.length,
                  itemBuilder: (context, index) {
                    final level = levels[index];
                    final isSelected = controller.cookingLevel.value == level["name"]!;

                    return GestureDetector(
                      onTap: () {
                        controller.cookingLevel.value = level["name"]!;
                        controller.update();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.grey.shade200,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Icon và tên level
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      // Icon
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade50,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(level["icon"]!, style: const TextStyle(fontSize: 24)),
                                      ),

                                      const SizedBox(height: 12),

                                      // Tên level
                                      Text(
                                        level["name"]!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected ? AppColors.primary : Colors.black,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      // Mô tả ngắn
                                      Text(
                                        level["description"]!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isSelected ? AppColors.primary.withOpacity(0.8) : Colors.grey.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Check mark khi selected
                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 4)],
                                  ),
                                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const Spacer(),

            // Nút điều hướng - sử dụng GetBuilder
            Container(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: GetBuilder<UserSetupController>(
                builder: (controller) {
                  return Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.back,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Back', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: controller.cookingLevel.value.isEmpty
                              ? null
                              : () {
                                  controller.submitSetup(
                                    country: controller.country.value,
                                    cookingLevel: controller.cookingLevel.value,
                                    categories: controller.favoriteFoods,
                                  );
                                  Get.offAllNamed(Routes.h);
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: controller.cookingLevel.value.isEmpty
                                ? Colors.grey.shade300
                                : AppColors.primary,
                            foregroundColor: controller.cookingLevel.value.isEmpty
                                ? Colors.grey.shade600
                                : Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text(
                            controller.cookingLevel.value.isEmpty ? 'Select Level' : 'Finish',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Thêm khoảng cách an toàn cho bottom
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
