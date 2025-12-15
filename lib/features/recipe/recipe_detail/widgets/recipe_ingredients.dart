import 'package:flutter/material.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

class IngredientItem extends StatelessWidget {
  final int index;
  final String text;

  const IngredientItem({super.key, required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.primary.withOpacity(0.15),
            child: Text("${index + 1}", style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}