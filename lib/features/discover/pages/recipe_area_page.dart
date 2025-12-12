import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/discover/controllers/discover_controller.dart';
import 'package:yumshare/routers/app_routes.dart';
import 'package:yumshare/utils/themes/text_style.dart';

class RecipeAreaPage extends StatefulWidget {
  const RecipeAreaPage({super.key});

  @override
  State<RecipeAreaPage> createState() => _RecipeAreaPageState();
}

class _RecipeAreaPageState extends State<RecipeAreaPage> {
  final DiscoverController controller = Get.find<DiscoverController>();
  bool isPrecached = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Areas', style: AppTextStyles.heading2),
        actions: [IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.magnifyingGlass))],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: controller.areas.length,
        itemBuilder: (context, index) {
          final area = controller.areas[index];
          final name = area['name']!;
          final image = area['image']!;

          return SizedBox(
            height: 150,
            width: 200,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.recipesByAreaPage, arguments: name);
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(image: AssetImage(image) as ImageProvider, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black.withOpacity(0.35),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 3),
                          Obx(() {
                            return Text(
                              '${controller.getAreaCount(name)} recipes',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
