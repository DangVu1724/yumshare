import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/recipe/create_recipe/providers/step_provider.dart';

class StepItem extends StatelessWidget {
  const StepItem({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<StepController>();

    return Obx(() {
      if (ctrl.steps.isEmpty) {
        return SliverToBoxAdapter(
          child: Padding(padding: const EdgeInsets.all(16), child: Text("No steps")),
        );
      }

      return SliverReorderableList(
        itemCount: ctrl.steps.length,
        onReorder: (oldIndex, newIndex) => ctrl.reorder(oldIndex, newIndex),
        itemBuilder: (context, index) {
          final step = ctrl.steps[index];
          final controller = ctrl.controllers[index]!;

          return ReorderableDragStartListener(
            key: ValueKey(step.stepNumber),
            index: index,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Column(
                    children: [
                      const Icon(Icons.menu),
                      const SizedBox(height: 8),
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: const Color.fromARGB(255, 249, 237, 241),
                        child: Text(
                          '${step.stepNumber}', // luôn đúng với vị trí
                          style: const TextStyle(color: Colors.pink, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: (val) => ctrl.updateStep(index, val),
                      decoration: InputDecoration(
                        hintText: "Step ${step.stepNumber}",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => ctrl.removeStep(index),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
