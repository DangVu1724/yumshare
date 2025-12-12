import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yumshare/features/recipe/create_recipe/controllers/create_recipe_controller.dart';

class ImagePickerBox extends StatefulWidget {
  const ImagePickerBox({super.key});

  @override
  State<ImagePickerBox> createState() => _ImagePickerBoxState();
}

class _ImagePickerBoxState extends State<ImagePickerBox> {
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
              if (controller.image.value == null) {
                return const Text("No image selected");
              }
              return Image.file(controller.image.value!, height: 120);
            }),
          ),

          if (controller.image.value != null)
            Positioned(
              right: 12,
              bottom: 12,
              child: GestureDetector(
                onTap: controller.pickImage,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black.withOpacity(0.6),
                  child: Icon(Icons.edit, color: Colors.white, size: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
