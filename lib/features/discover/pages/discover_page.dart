import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/discover/controllers/discover_controller.dart';
import 'package:yumshare/utils/themes/app_colors.dart';
import 'package:yumshare/utils/themes/text_style.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final DiscoverController controller = Get.put(DiscoverController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discover')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: [
              _buildTitleSection('Recipe Categories'),
              const SizedBox(height: 8),
              _buildSectionCategory(controller),
              _buildTitleSection('Our Recommendations'),
              _buildTitleSection('Most Searches'),
              _buildTitleSection('New Recipes'),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTitleSection(String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: AppTextStyles.bodyBold.copyWith(fontSize: 20)),
      IconButton(
        onPressed: () {},
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
        return _categoryCard(title: item['name'] ?? '', image: item['image'] ?? '');
      },
    ),
  );
}

Widget _categoryCard({required String title, required String image}) {
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
                image: DecorationImage(image: AssetImage('assets/images/avatar1.png'), fit: BoxFit.cover),
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
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ),
  );
}
