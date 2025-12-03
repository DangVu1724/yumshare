import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CreateRecipePage extends ConsumerStatefulWidget {
  const CreateRecipePage({super.key});

  @override
  ConsumerState<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends ConsumerState<CreateRecipePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cookingTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Recipe'),
        actions: [
          GestureDetector(
            onTap: () {
              // Handle save action
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: 70,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(color: Colors.pinkAccent, borderRadius: BorderRadius.circular(24.0)),
                alignment: Alignment.center,
                child: Text('Save', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImagePickerBox(),
              SizedBox(height: 16.0),
              buildTextField('Name', 'Recipe Title', _nameController, maxLines: 1),
              buildTextField('Description', 'Description', _descriptionController, maxLines: 5),
              buildTextField('Cooking Time', 'e.g., 30 minutes', _cookingTimeController, maxLines: 1),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildTextField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 16.0),
      Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      SizedBox(height: 8.0),
      TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          filled: true,
          hintText: hint,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          fillColor: Colors.grey[200],
          focusColor: Colors.grey[200],
          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(16.0)),
        ),
      ),
    ],
  );
}

class ImagePickerBox extends StatefulWidget {
  const ImagePickerBox({super.key});

  @override
  State<ImagePickerBox> createState() => _ImagePickerBoxState();
}

class _ImagePickerBoxState extends State<ImagePickerBox> {
  File? _image;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        _image = File(file.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickImage, // Ấn vào khung để chọn ảnh
      child: Stack(
        children: [
          // ---------------------- KHUNG + ẢNH ----------------------
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _image == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Tap to select an image', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      ],
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(_image!, fit: BoxFit.cover, width: double.infinity),
                  ),
          ),

          // ---------------------- ICON EDIT ----------------------
          if (_image != null)
            Positioned(
              right: 12,
              bottom: 12,
              child: GestureDetector(
                onTap: pickImage,
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
