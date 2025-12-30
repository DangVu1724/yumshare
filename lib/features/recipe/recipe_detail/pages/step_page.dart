import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/recipe/recipe_detail/controllers/cooking_controller.dart';

class CookingModePage extends StatefulWidget {
  final List steps;
  final String recipeName;

  const CookingModePage({
    super.key,
    required this.steps,
    required this.recipeName,
  });

  @override
  State<CookingModePage> createState() => _CookingModePageState();
}

class _CookingModePageState extends State<CookingModePage> {
  final PageController pageController = PageController();
  final CookingController controller = Get.put(CookingController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      controller.speak(widget.steps.first.description);
    });
  }

  @override
  void dispose() {
    Get.delete<CookingController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark background for focus
      body: SafeArea(
        child: Column(
          children: [
            // Header with Progress
            _buildHeader(context),
            // Content Area
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: widget.steps.length,
                onPageChanged: (index) {
                  controller.currentStep.value = index;
                  controller.speak(widget.steps[index]);
                },
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Step Indicator
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D2D2D),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "BƯỚC ${index + 1}/${widget.steps.length}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFE86A33),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Step Description Card
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color(0xFF3A3A3A),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Step Number
                                  Text(
                                    "Bước ${index + 1}",
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Divider
                                  Container(
                                    height: 2,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFFE86A33).withOpacity(0.5),
                                          const Color(0xFFE86A33),
                                          const Color(0xFFE86A33).withOpacity(0.5),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  
                                  // Step Description
                                  Text(
                                    widget.steps[index].description,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFFF0F0F0),
                                      height: 1.6,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  
                                  // Voice Control Button
                                  Obx(
                                    () => Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: controller.isSpeaking.value
                                              ? [
                                                  const Color(0xFFE86A33),
                                                  const Color(0xFFD45A23),
                                                ]
                                              : [
                                                  const Color(0xFF3A3A3A),
                                                  const Color(0xFF2A2A2A),
                                                ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: controller.isSpeaking.value
                                                ? const Color(0xFFE86A33).withOpacity(0.4)
                                                : Colors.black.withOpacity(0.5),
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          controller.isSpeaking.value
                                              ? Icons.volume_up_rounded
                                              : Icons.volume_up_outlined,
                                          size: 32,
                                          color: controller.isSpeaking.value
                                              ? Colors.white
                                              : const Color(0xFFCCCCCC),
                                        ),
                                        onPressed: () => controller.speak(widget.steps[index].description),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Obx(
                                    () => AnimatedOpacity(
                                      opacity: controller.isSpeaking.value ? 1 : 0,
                                      duration: const Duration(milliseconds: 300),
                                      child: Text(
                                        "Đang đọc...",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: const Color(0xFFE86A33).withOpacity(0.8),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Navigation Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.steps.length,
                            (dotIndex) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: dotIndex == index ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: dotIndex == index
                                      ? const Color(0xFFE86A33)
                                      : const Color(0xFF444444),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Navigation Controls
            _buildNavigationControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Back Button
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          // Recipe Title and Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recipeName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Obx(
                  () => Text(
                    "Tiến trình: ${controller.currentStep.value + 1}/${widget.steps.length}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFAAAAAA),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Progress Bar
                Obx(
                  () => LinearProgressIndicator(
                    value: (controller.currentStep.value + 1) / widget.steps.length,
                    backgroundColor: const Color(0xFF333333),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE86A33)),
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF333333).withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Previous Button
          Expanded(
            child: Obx(
              () => OutlinedButton(
                onPressed: controller.currentStep.value > 0
                    ? () {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: controller.currentStep.value > 0
                        ? const Color(0xFF444444)
                        : const Color(0xFF333333),
                  ),
                  backgroundColor: controller.currentStep.value > 0
                      ? const Color(0xFF2A2A2A)
                      : const Color(0xFF1F1F1F),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: Color(0xFFAAAAAA),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Trước",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: controller.currentStep.value > 0
                            ? const Color(0xFFCCCCCC)
                            : const Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Next/Finish Button
          Expanded(
            child: Obx(
              () => ElevatedButton(
                onPressed: () {
                  if (controller.currentStep.value < widget.steps.length - 1) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // TODO: Implement finish cooking action
                    Get.back();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE86A33),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  shadowColor: const Color(0xFFE86A33).withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.currentStep.value < widget.steps.length - 1
                          ? "Tiếp theo"
                          : "Hoàn thành",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (controller.currentStep.value < widget.steps.length - 1)
                      const SizedBox(width: 8),
                    if (controller.currentStep.value < widget.steps.length - 1)
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}