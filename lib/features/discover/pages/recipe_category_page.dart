import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/discover/controllers/discover_controller.dart';
import 'package:yumshare/utils/themes/text_style.dart';

class RecipeCategoryPage extends StatefulWidget {
  const RecipeCategoryPage({super.key});

  @override
  State<RecipeCategoryPage> createState() => _RecipeCategoryPageState();
}

class _RecipeCategoryPageState extends State<RecipeCategoryPage> {
  final DiscoverController controller = Get.find<DiscoverController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Category', style: AppTextStyles.heading2),
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
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final item = controller.categories[index];
          final category = controller.categories[index];
          final name = category['name']!;

          return SizedBox(
            height: 150,
            width: 200,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(item['image'] ?? '') as ImageProvider,
                          fit: BoxFit.cover,
                        ),
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
                            '${controller.getCategoryCount(name)} recipes',
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
          );
        },
      ),
    );
  }
}
