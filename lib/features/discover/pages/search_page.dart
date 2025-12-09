import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:yumshare/features/discover/controllers/search_controller.dart';
import 'package:yumshare/features/home/controllers/home_controller.dart';
import 'package:yumshare/utils/themes/text_style.dart';
import 'package:yumshare/widgets/recipe_card_widget.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  final DiscoverSearchController controller = Get.find<DiscoverSearchController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: TextField(
          controller: controller.searchController,
          focusNode: controller.focusNode,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search recipe...",
            hintStyle: const TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: controller.clearSearch,
            ),

            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          onChanged: controller.onTyping,
          onSubmitted: controller.onSubmitSearch,
        ),
      ),
      body: Obx(() {
        // 1. Nếu đang gõ và có suggestions
        if (controller.suggestions.isNotEmpty) {
          return buildSuggestions();
        }

        // 2. Nếu chưa search và có history
        if (controller.searchResults.isEmpty && controller.query.isEmpty) {
          return buildHistory();
        }

        // 3. Nếu search nhưng không có kết quả
        if (controller.searchResults.isEmpty && controller.query.isNotEmpty) {
          return buildNotFound();
        }

        // 4. Nếu có kết quả search
        if (controller.searchResults.isNotEmpty) {
          return buildResults();
        }

        // 5. Trường hợp mặc định (không có gì)
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("assets/animations/no_data_found.json", width: 150, height: 150, repeat: false),
                const SizedBox(height: 20),
                Text("Search Recipes", style: AppTextStyles.heading2.copyWith(color: Colors.grey)),
                const SizedBox(height: 10),
                const Text(
                  "Type keywords to find delicious recipes",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// ===================== VIEW ======================

  Widget buildHistory() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Recent Searches", style: AppTextStyles.heading2),
            if (controller.history.isNotEmpty)
              TextButton(
                onPressed: controller.clearHistory,
                child: const Text("Clear All", style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...controller.history.map((word) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(word),
              leading: const Icon(Icons.history, color: Colors.grey),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => controller.removeHistory(word),
              ),
              onTap: () {
                controller.searchController.text = word;
                controller.onSubmitSearch(word);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget buildSuggestions() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text("Suggestions", style: AppTextStyles.heading2),
        const SizedBox(height: 12),
        ...controller.suggestions.map((recipe) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(recipe.name),
              leading: const Icon(Icons.search, color: Colors.grey),
              onTap: () {
                controller.selectSuggestion(recipe);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget buildNotFound() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/animations/no_data_found.json", width: 200, height: 200),
            const SizedBox(height: 20),
            Text("No Results Found", style: AppTextStyles.heading2.copyWith(color: Colors.grey)),
            const SizedBox(height: 10),
            Text(
              "No recipes found for '${controller.query}'",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: controller.clearSearch, child: const Text("Clear Search")),
          ],
        ),
      ),
    );
  }

  Widget buildResults() {
    final recipes = controller.searchResults;
    final authors = homeController.authors;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${recipes.length} ${recipes.length == 1 ? 'result' : 'results'} found",
                style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              final author = authors[recipe.authorId];
              return RecipeCard(recipe: recipe, author: author!);
            },
            itemCount: recipes.length,
          ),
        ),
      ],
    );
  }
}
