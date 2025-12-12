import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/recipe/create_recipe/controllers/create_recipe_controller.dart';

class MultiCategoryChipSelector extends StatefulWidget {
  const MultiCategoryChipSelector({super.key});

  @override
  State<MultiCategoryChipSelector> createState() => _MultiCategoryChipSelectorState();
}

class _MultiCategoryChipSelectorState extends State<MultiCategoryChipSelector> {
  final CreateRecipeController createRecipeController = Get.find<CreateRecipeController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Region", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              items: createRecipeController.regions
                  .map((region) => DropdownMenuItem(value: region, child: Text(region)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  createRecipeController.selectedRegion = value;
                });
              },
              value: createRecipeController.selectedRegion,
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                width: 200,
              ),
              dropdownStyleData: const DropdownStyleData(maxHeight: 200),
              menuItemStyleData: const MenuItemStyleData(height: 40),

              // SEARCH PART
              dropdownSearchData: DropdownSearchData(
                searchController: createRecipeController.textEditingController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Container(
                  height: 50,
                  padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
                  child: TextFormField(
                    controller: createRecipeController.textEditingController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      hintText: 'Search for a region...',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),

                // <-- fix: case-insensitive match
                searchMatchFn: (item, searchValue) {
                  if (searchValue.trim().isEmpty) return true;
                  final itemValue = item.value?.toString().toLowerCase() ?? '';
                  final q = searchValue.toString().toLowerCase();
                  return itemValue.contains(q);
                },
              ),

              // clear search text when menu closes
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  createRecipeController.textEditingController.clear();
                }
              },
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ------------------------ CATEGORY ------------------------ //
        const Text("Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        Wrap(
          spacing: 10,
          children: createRecipeController.categories.map((category) {
            final isSelected = createRecipeController.selectedCategory == category;

            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              selectedColor: Colors.orange,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
              onSelected: (value) {
                setState(() {
                  createRecipeController.selectedCategory = value ? category : null; // Chỉ 1 lựa chọn
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
