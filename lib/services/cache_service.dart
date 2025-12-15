import 'package:hive/hive.dart';
import 'package:yumshare/models/adapter/recipe_hive.dart';
import 'package:yumshare/models/recipes.dart';

class CacheService {
  final box = Hive.box('cache');

  // DISCOVER PAGE 1
  List<Recipe> getDiscoverPage1() {
    final raw = box.get('discover_page_1');
    if (raw == null) return [];
    return (raw as List).cast<RecipeFeedHive>().map((e) => e.toRecipe()).toList();
  }

  void saveDiscoverPage1(List<Recipe> recipes) {
    box.put('discover_page_1', recipes.take(20).map(RecipeFeedHive.fromRecipe).toList());
  }

  // HOME FEED 
  List<Recipe> getHomeFeed(String uid) {
    final raw = box.get('home_feed_$uid');
    if (raw == null) return [];
    return (raw as List).cast<RecipeFeedHive>().map((e) => e.toRecipe()).toList();
  }

  void saveHomeFeed(String uid, List<Recipe> recipes) {
    box.put('home_feed_$uid', recipes.map(RecipeFeedHive.fromRecipe).toList());
  }
}
