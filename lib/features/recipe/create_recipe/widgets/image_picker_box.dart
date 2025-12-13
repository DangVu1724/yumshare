import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/recipe/create_recipe/controllers/create_recipe_controller.dart';

class ImagePickerBox extends StatelessWidget {
  ImagePickerBox({super.key});
  final CreateRecipeController controller = Get.find<CreateRecipeController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.pickImage,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Obx(() {
              final img = controller.image.value;

              if (img == null) {
                return const Center(child: Text("No image selected"));
              }

              // File
              if (img is File) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(img, fit: BoxFit.cover),
                );
              }

              // URL
              if (img is String && img.startsWith("http")) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(img, fit: BoxFit.cover),
                );
              }

              // Base64
              if (img is String) {
                try {
                  final bytes = base64Decode(img);
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(bytes, fit: BoxFit.cover),
                  );
                } catch (_) {
                  return const Center(child: Text("Invalid image format"));
                }
              }

              return const Center(child: Text("Invalid image"));
            }),
          ),

          Obx(
            () => controller.image.value != null
                ? Positioned(
                    right: 12,
                    bottom: 12,
                    child: GestureDetector(
                      onTap: controller.pickImage,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.black.withOpacity(0.6),
                        child: const Icon(Icons.edit, color: Colors.white, size: 18),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
