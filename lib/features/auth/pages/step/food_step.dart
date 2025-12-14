import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/auth/controllers/setup_controller.dart';
import 'package:yumshare/utils/themes/text_style.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

class FoodStep extends StatelessWidget {
  const FoodStep({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UserSetupController>();
    
    final List<Map<String, String>> categories = [
      {
        "name": "Beef", 
        "image": "assets/images/category/Beef.jpg",
        "description": "Steaks, burgers, roasts"
      },
      {
        "name": "Chicken", 
        "image": "assets/images/category/Chicken.jpg",
        "description": "Grilled, fried, roasted"
      },
      {
        "name": "Dessert", 
        "image": "assets/images/category/Dessert.jpg",
        "description": "Sweet treats & pastries"
      },
      {
        "name": "Lamb", 
        "image": "assets/images/category/Lamb.jpg",
        "description": "Chops, stews, racks"
      },
      {
        "name": "Miscellaneous", 
        "image": "assets/images/category/Miscellaneous.jpg",
        "description": "Various unique dishes"
      },
      {
        "name": "Pasta", 
        "image": "assets/images/category/Pasta.jpg",
        "description": "Noodles & sauces"
      },
      {
        "name": "Pork", 
        "image": "assets/images/category/Pork.jpg",
        "description": "Chops, ribs, bacon"
      },
      {
        "name": "Seafood", 
        "image": "assets/images/category/Seafood.jpg",
        "description": "Fish, shrimp, shellfish"
      },
      {
        "name": "Side", 
        "image": "assets/images/category/Side.jpg",
        "description": "Salads, vegetables, rice"
      },
      {
        "name": "Starter", 
        "image": "assets/images/category/Starter.jpg",
        "description": "Appetizers & snacks"
      },
      {
        "name": "Vegan", 
        "image": "assets/images/category/Vegan.jpg",
        "description": "100% plant-based"
      },
      {
        "name": "Vegetarian", 
        "image": "assets/images/category/Vegetarian.jpg",
        "description": "No meat, with dairy/eggs"
      },
      {
        "name": "Breakfast", 
        "image": "assets/images/category/Breakfast.jpg",
        "description": "Morning meals"
      },
      {
        "name": "Goat", 
        "image": "assets/images/category/Goat.jpg",
        "description": "Curries, stews, roasts"
      },
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            
            const Text(
              'What are your favorite foods?', 
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 8),
            Text(
              'Select your food preferences for better recommendations.',
              style: AppTextStyles.small.copyWith(color: Colors.grey.shade600),
            ),
            
            const SizedBox(height: 8),
            
            // Counter hiển thị số lượng đã chọn - Dùng Obx ở đây
            Obx(() {
              final selectedCount = ctrl.favoriteFoods.length;
              return Text(
                selectedCount > 0 
                  ? '$selectedCount selected' 
                  : 'Select any categories you like',
                style: TextStyle(
                  fontSize: 14,
                  color: selectedCount > 0 ? AppColors.primary : Colors.grey.shade500,
                  fontWeight: selectedCount > 0 ? FontWeight.w600 : FontWeight.normal,
                ),
              );
            }),

            const SizedBox(height: 24),

            // GridView không cần wrap trong Obx
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  
                  // Sử dụng Obx chỉ cho mỗi item card để reactive
                  return Obx(() {
                    final isSelected = ctrl.favoriteFoods.contains(category["name"]!);

                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          ctrl.favoriteFoods.remove(category["name"]!);
                        } else {
                          ctrl.favoriteFoods.add(category["name"]!);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? AppColors.primary.withOpacity(0.05)
                            : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected 
                              ? AppColors.primary
                              : Colors.grey.shade200,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Hình ảnh
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  child: Image.asset(
                                    category["image"]!,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 100,
                                        color: Colors.grey.shade200,
                                        child: const Icon(
                                          Icons.fastfood,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                
                                // Nội dung text
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Tên category
                                      Text(
                                        category["name"]!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected 
                                            ? AppColors.primary 
                                            : Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      
                                      const SizedBox(height: 4),
                                      
                                      // Mô tả
                                      Text(
                                        category["description"]!,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                          height: 1.4,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.3),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),

            // Nút điều hướng
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: ctrl.back,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: Obx(() => ElevatedButton(
                      onPressed: ctrl.next,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: ctrl.favoriteFoods.isEmpty
                            ? Colors.grey.shade300
                            : AppColors.primary,
                        foregroundColor: ctrl.favoriteFoods.isEmpty
                            ? Colors.grey.shade600
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        ctrl.favoriteFoods.isEmpty ? 'Skip' : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}