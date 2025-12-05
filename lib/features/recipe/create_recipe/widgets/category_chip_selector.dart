import 'package:flutter/material.dart';

class MultiCategoryChipSelector extends StatefulWidget {
  const MultiCategoryChipSelector({super.key});

  @override
  State<MultiCategoryChipSelector> createState() => _MultiCategoryChipSelectorState();
}

class _MultiCategoryChipSelectorState extends State<MultiCategoryChipSelector> {
  // Regions – Vùng miền / Quốc gia
  final List<String> regions = ["Vietnamese", "Korean", "Japanese", "Chinese", "Thai", "European", "American"];

  // Categories – Loại món
  final List<String> categories = [
    // Nhóm món chính
    "Cơm",
    "Món nước", // Phở, Bún, Miến, Mì… gom chung
    "Món khô", // Bún trộn, Mì trộn, Phở trộn…
    // Chế biến
    "Chiên",
    "Xào",
    "Nướng",
    "Hấp",
    "Luộc",
    "Kho",

    // Món phụ
    "Canh",
    "Soup",
    "Salad",

    // Món ăn vặt
    "Ăn vặt",
    "Bánh ngọt",
    "Bánh mặn",

    // Tráng miệng
    "Tráng miệng",

    // Đồ uống
    "Đồ uống",
  ];

  List<String> selectedRegions = [];
  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ------------------------ REGION ------------------------ //
        const Text("Region", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        Wrap(
          spacing: 10,
          children: regions.map((region) {
            final isSelected = selectedRegions.contains(region);

            return ChoiceChip(
              label: Text(region),
              selected: isSelected,
              selectedColor: Colors.orange,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
              onSelected: (value) {
                setState(() {
                  if (value) {
                    selectedRegions.add(region);
                  } else {
                    selectedRegions.remove(region);
                  }
                });
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        // ------------------------ CATEGORY ------------------------ //
        const Text("Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        Wrap(
          spacing: 10,
          children: categories.map((category) {
            final isSelected = selectedCategories.contains(category);

            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              selectedColor: Colors.orange,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
              onSelected: (value) {
                setState(() {
                  if (value) {
                    selectedCategories.add(category);
                  } else {
                    selectedCategories.remove(category);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
