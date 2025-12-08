import 'package:get/get.dart';
import 'package:yumshare/features/discover/controllers/discover_controller.dart';

class DiscorverBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DiscoverController(), permanent: true);
  }
}
