import 'package:get/get.dart';
import 'package:yumshare/features/discover/controllers/discover_controller.dart';
import 'package:yumshare/features/discover/controllers/search_controller.dart';

class DiscorverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiscoverController());
    Get.lazyPut(() => DiscoverSearchController());
  }
}
