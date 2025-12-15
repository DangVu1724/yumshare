import 'package:flutter/material.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final String title;

  const InfoChip({super.key, required this.icon, required this.text, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 250, 233, 238),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(text, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500, fontSize: 13)),
            ],
          ),
          Text(title, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}