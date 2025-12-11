import 'package:get/get.dart';
import 'package:yumshare/bindings/discorver_binding.dart';
import 'package:yumshare/bindings/profile_binding.dart';
import 'package:yumshare/bindings/home_binding.dart';
import 'package:yumshare/bindings/auth_binding.dart';
import 'package:yumshare/features/profile/pages/profile_chef_page.dart';
import 'package:yumshare/features/profile/pages/profile_page.dart';
import 'package:yumshare/features/profile/pages/edit_profile_page.dart';
import 'package:yumshare/features/profile/pages/setting_page.dart';
import 'package:yumshare/models/users.dart';
import 'package:yumshare/routers/app_routes.dart';

class ProfileRoutes {
  static final routes = [
    GetPage(name: Routes.profile, page: () => ProfilePage(), bindings: [HomeBinding(), ProfileBinding()]),

    GetPage(name: Routes.editProfile, page: () => EditProfilePage(), bindings: [HomeBinding(), ProfileBinding()]),

    GetPage(
      name: Routes.profilechefPage,
      page: () {
        final chef = Get.arguments as Users;
        return ProfileChefPage(chef: chef);
      },
      bindings: [HomeBinding(), DiscorverBinding()],
    ),

    GetPage(
      name: Routes.setting,
      page: () => SettingsPage(),
      bindings: [HomeBinding(), ProfileBinding(), AuthBinding()],
    ),
  ];
}
