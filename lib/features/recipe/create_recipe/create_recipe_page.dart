import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/recipe/create_recipe/providers/ingredient_provider.dart';
import 'package:yumshare/features/recipe/create_recipe/providers/step_provider.dart';
import 'package:yumshare/features/recipe/create_recipe/widgets/build_text_field.dart';
import 'package:yumshare/features/recipe/create_recipe/widgets/image_picker_box.dart';
import 'package:yumshare/features/recipe/create_recipe/widgets/ingredient_item.dart.dart';
import 'package:yumshare/features/recipe/create_recipe/widgets/steps.dart';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cookingTimeController = TextEditingController();
  final ing = Get.put(IngredientController());
  final step = Get.put(StepController());

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
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                width: 70,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 225, 53, 79),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ImagePickerBox(),

                BuildTextField(label: 'Recipe Name', hint: 'Enter recipe name', controller: _nameController),

                BuildTextField(
                  label: 'Description',
                  hint: 'Enter recipe description',
                  controller: _descriptionController,
                  maxLines: 4,
                ),

                BuildTextField(
                  label: 'Cooking Time (minutes)',
                  hint: 'Enter cooking time',
                  controller: _cookingTimeController,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text('Ingredients', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ]),
            ),
          ),
          IngredientItem(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverToBoxAdapter(
              child: ElevatedButton.icon(
                onPressed: () {
                  ing.addIngredient();
                },
                icon: const Icon(Icons.add, color: Colors.pink),
                label: const Text('Add Ingredient', style: TextStyle(fontSize: 14, color: Colors.pink)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 249, 237, 241),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverToBoxAdapter(
              child: Text('Steps', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),
          StepItem(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverToBoxAdapter(
              child: ElevatedButton.icon(
                onPressed: () {
                  step.addStep();
                },
                icon: const Icon(Icons.add, color: Colors.pink),
                label: const Text('Add Ingredient', style: TextStyle(fontSize: 14, color: Colors.pink)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 249, 237, 241),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
