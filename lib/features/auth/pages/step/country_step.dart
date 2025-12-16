import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:yumshare/features/auth/controllers/setup_controller.dart';
import 'package:yumshare/utils/themes/app_colors.dart';
import 'package:yumshare/utils/themes/text_style.dart';

class CountryStep extends StatelessWidget {
  const CountryStep({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UserSetupController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

             Text('Which country are you from?', style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            const Text(
              'Please select your country of residence to personalize your experience.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // 👇 SEARCH BAR
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Iconsax.search_normal, color: Colors.grey.shade500, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: ctrl.searchController,
                      onChanged: (value) => ctrl.filterCountries(value),
                      decoration: InputDecoration(
                        hintText: 'Search country...',
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  // Obx(() {
                  //   if (ctrl.searchController.text.isNotEmpty) {
                  //     return IconButton(
                  //       icon: Icon(Icons.close_rounded, color: Colors.grey.shade500, size: 20),
                  //       onPressed: () {
                  //         ctrl.searchController.clear();
                  //         ctrl.filterCountries('');
                  //       },
                  //     );
                  //   }
                  //   return const SizedBox(width: 8);
                  // }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 👇 LIST
            Expanded(
              child: Obx(() {
                if (ctrl.isLoadingCountry.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Hiển thị thông báo khi không tìm thấy kết quả
                if (ctrl.filteredCountries.isEmpty && ctrl.searchController.text.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'No countries found',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        Text('Try searching with a different keyword', style: TextStyle(color: Colors.grey.shade500)),
                      ],
                    ),
                  );
                }

                return ClipRect(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),

                    itemCount: ctrl.filteredCountries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final country = ctrl.filteredCountries[index];

                      return Obx(() {
                        final isSelected = ctrl.country.value == country.name;

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: Material(
                            color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                ctrl.country.value = country.name;
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.network(
                                        country.flag,
                                        width: 32,
                                        height: 20,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 32,
                                          height: 20,
                                          color: Colors.grey.shade200,
                                          child: const Icon(Icons.flag, size: 12, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(country.code, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                                    const SizedBox(width: 16),

                                    Text(
                                      country.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: isSelected ? AppColors.primary : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            // 👇 NEXT BUTTON
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: ctrl.country.value.isNotEmpty
                        ? AppColors.primary
                        : Colors.grey.shade300, // Màu xám khi chưa chọn
                    foregroundColor: ctrl.country.value.isNotEmpty
                        ? Colors.white
                        : Colors.grey.shade600, // Text màu xám khi chưa chọn
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    animationDuration: const Duration(milliseconds: 200),
                    enableFeedback: true,
                  ),
                  onPressed: ctrl.country.value.isEmpty ? null : ctrl.next,
                  child: Text(
                    ctrl.country.value.isEmpty ? 'Select a Country' : 'Next',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom > 0 ? 8 : 0),
          ],
        ),
      ),
    );
  }
}
