import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/models/recipte_step.dart';

class StepController extends GetxController {
  var steps = <RecipeStep>[].obs;
  final Map<int, TextEditingController> controllers = {}; 

  @override
  void onInit() {
    super.onInit();

    // khởi tạo 3 step mặc định
    for (int i = 0; i < 3; i++) {
      addStep("Step ${i + 1}");
    }
  }

  void addStep([String? description]) {
    final step = RecipeStep(
      stepNumber: steps.length + 1,
      description: description ?? "Step ${steps.length + 1}",
    );
    steps.add(step);

    controllers[steps.length - 1] =
        TextEditingController(text: step.description);
  }

  void removeStep(int index) {
    if (steps.length <= 1) return; // luôn ít nhất 1 step
    steps.removeAt(index);
    controllers[index]?.dispose();
    controllers.remove(index);

    // cập nhật lại stepNumber và controllers
    for (int i = 0; i < steps.length; i++) {
      steps[i].stepNumber = i + 1;
      controllers[i] ??= TextEditingController(text: steps[i].description);
    }
    steps.refresh();
  }

  void updateStep(int index, String value) {
    if (index < 0 || index >= steps.length) return;
    steps[index].description = value;
    controllers[index]?.text = value;
    steps.refresh();
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final step = steps.removeAt(oldIndex);
    steps.insert(newIndex, step);

    // cập nhật lại stepNumber và controllers
    for (int i = 0; i < steps.length; i++) {
      steps[i].stepNumber = i + 1;
      controllers[i] ??= TextEditingController(text: steps[i].description);
    }

    steps.refresh();
  }
}
