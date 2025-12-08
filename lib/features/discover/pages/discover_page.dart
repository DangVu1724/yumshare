import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/discover/controllers/discover_controller.dart';
import 'package:yumshare/routers/app_routes.dart';
import 'package:yumshare/utils/themes/app_colors.dart';
import 'package:yumshare/utils/themes/text_style.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final DiscoverController controller = Get.find<DiscoverController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discover')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: [
              _buildTitleSection('Recipe Categories', Routes.categoryRecipe),
              const SizedBox(height: 8),
              _buildSectionCategory(controller),
              // _buildTitleSection('Our Recommendations'),
              // _buildTitleSection('Most Searches'),
              // _buildTitleSection('New Recipes'),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTitleSection(String title, String route) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: AppTextStyles.bodyBold.copyWith(fontSize: 20)),
      IconButton(
        onPressed: () {
          Get.toNamed(route);
        },
        icon: Icon(Icons.arrow_forward, color: AppColors.primary),
      ),
    ],
  );
}

Widget _buildSectionCategory(DiscoverController controller) {
  return SizedBox(
    height: 150,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: controller.categories.length,
      separatorBuilder: (_, _) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final item = controller.categories[index];
        final category = controller.categories[index];
        final name = category['name']!;
        final count = controller.getCategoryCount(name);
        return _categoryCard(title: item['name'] ?? '', image: item['image'] ?? '', count: count);
      },
    ),
  );
}

Widget _categoryCard({required String title, required String image, required int count}) {
  return SizedBox(
    width: 200,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
              ),
            ),
          ),

          // overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.black.withOpacity(0.35)),
            ),
          ),

          Positioned(
            bottom: 12,
            left: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$count recipes',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
