import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/recipe/create_recipe/widgets/ingredient_item.dart.dart';
import 'package:yumshare/models/recipes.dart';
import 'package:yumshare/features/recipe/create_recipe/controllers/create_recipe_controller.dart';
import 'package:yumshare/features/recipe/create_recipe/controllers/ingredient_provider.dart';
import 'package:yumshare/features/recipe/create_recipe/controllers/step_provider.dart';
import 'package:yumshare/features/recipe/create_recipe/widgets/build_text_field.dart';
import 'package:yumshare/features/recipe/create_recipe/widgets/category_chip_selector.dart';
import 'package:yumshare/features/recipe/create_recipe/widgets/image_picker_box.dart';
import 'package:yumshare/features/recipe/create_recipe/widgets/steps.dart';

class EditRecipePage extends StatefulWidget {
  final Recipe recipe;
  const EditRecipePage({super.key, required this.recipe});

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cookingTimeController = TextEditingController();
  final TextEditingController _servingController = TextEditingController();

  final ing = Get.put(IngredientController());
  final step = Get.put(StepController());
  final CreateRecipeController createRecipeController = Get.find<CreateRecipeController>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.recipe.name;
    _descriptionController.text = widget.recipe.description;
    _cookingTimeController.text = widget.recipe.cookingTime.toString();
    _servingController.text = widget.recipe.servingPeople.toString();

    ing.ingredients.assignAll(widget.recipe.ingredients);
    if (widget.recipe.steps.isNotEmpty) {
      step.loadSteps(widget.recipe.steps);
    } else {
      for (int i = 0; i < 3; i++) {
        step.addStep("Step ${i + 1}");
      }
    }

    createRecipeController.selectedRegion = widget.recipe.regions;
    createRecipeController.selectedCategory = widget.recipe.category;

    if (widget.recipe.imageUrl != null && widget.recipe.imageUrl!.isNotEmpty) {
      createRecipeController.image.value = widget.recipe.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Edit Recipe"),
        actions: [
          // Sử dụng Obx để theo dõi isUpdating
          Obx(() {
            final isUpdating = createRecipeController.isUpdating.value;

            return Container(
              margin: const EdgeInsets.only(right: 12),
              child: isUpdating
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      child: const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        try {
                          createRecipeController.isUpdating.value = true;

                          String? base64Image = widget.recipe.imageUrl ?? "";
                          if (createRecipeController.image.value != null &&
                              createRecipeController.image.value != widget.recipe.imageUrl) {
                            base64Image = await createRecipeController.convertImageToBase64();
                          }

                          bool hasChanged =
                              _nameController.text.trim() != widget.recipe.name ||
                              _descriptionController.text.trim() != widget.recipe.description ||
                              (double.tryParse(_cookingTimeController.text) ?? 0) != widget.recipe.cookingTime ||
                              (int.tryParse(_servingController.text) ?? 1) != widget.recipe.servingPeople ||
                              createRecipeController.selectedRegion != widget.recipe.regions ||
                              createRecipeController.selectedCategory != widget.recipe.category ||
                              base64Image != widget.recipe.imageUrl ||
                              !listEquals(ing.ingredients, widget.recipe.ingredients) ||
                              !listEquals(step.steps, widget.recipe.steps);

                          if (!hasChanged) {
                            Get.snackbar(
                              "No changes",
                              "You haven't made any changes",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          await createRecipeController.updateRecipe(
                            widget.recipe.id,
                            name: _nameController.text.trim(),
                            description: _descriptionController.text.trim(),
                            cookingTime: double.tryParse(_cookingTimeController.text) ?? 0,
                            region: createRecipeController.selectedRegion,
                            category: createRecipeController.selectedCategory,
                            ingredients: ing.ingredients,
                            steps: step.steps,
                            people: int.tryParse(_servingController.text) ?? 1,
                            imageUrl: base64Image,
                          );


                          Get.snackbar(
                            "Success",
                            "Recipe updated successfully",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            duration: Duration(seconds: 3),
                          );

                          await Future.delayed(Duration(milliseconds: 500));
                          Get.back(result: true);
                        } catch (e) {
                          Get.snackbar(
                            "Error",
                            "Failed to update recipe: ${e.toString()}",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } finally {
                          createRecipeController.isUpdating.value = false;
                          print("===== End Save =====");
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      ),
                      child: const Text("Save", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
            );
          }),
        ],
      ),

      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ImagePickerBox(),

                BuildTextField(
                  label: 'Recipe Name',
                  hint: 'Enter recipe name',
                  controller: _nameController,
                  type: TextInputType.text,
                ),
                BuildTextField(
                  label: 'Description',
                  hint: 'Enter recipe description',
                  controller: _descriptionController,
                  maxLines: 4,
                  type: TextInputType.text,
                ),
                BuildTextField(
                  label: 'Cooking Time (minutes)',
                  hint: 'Enter cooking time',
                  controller: _cookingTimeController,
                  type: TextInputType.number,
                ),
                BuildTextField(
                  label: 'Number of servings',
                  hint: 'Enter servings',
                  controller: _servingController,
                  type: TextInputType.number,
                ),

                const SizedBox(height: 10),
                MultiCategoryChipSelector(),

                const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  child: Text("Ingredients", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ]),
            ),
          ),

          IngredientItem(),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverToBoxAdapter(
              child: ElevatedButton.icon(
                onPressed: ing.addIngredient,
                icon: const Icon(Icons.add, color: Colors.pink),
                label: const Text('Add Ingredient', style: TextStyle(color: Colors.pink)),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverToBoxAdapter(
              child: const Text("Steps", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),

          StepItem(),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverToBoxAdapter(
              child: ElevatedButton.icon(
                onPressed: step.addStep,
                icon: const Icon(Icons.add, color: Colors.pink),
                label: const Text('Add Step', style: TextStyle(color: Colors.pink)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
