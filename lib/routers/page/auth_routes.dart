import 'package:get/get.dart';
import 'package:yumshare/bindings/auth_binding.dart';
import 'package:yumshare/features/auth/pages/login_page.dart';
import 'package:yumshare/features/auth/pages/register_page.dart';
import 'package:yumshare/features/auth/pages/set_up_page.dart';
import 'package:yumshare/routers/app_routes.dart';

class AuthRoutes {
  static final routes = [
    GetPage(name: Routes.login, page: () => const LoginPage(), binding: AuthBinding()),
    GetPage(name: Routes.register, page: () => const RegisterPage(), binding: AuthBinding()),
    GetPage(name: Routes.setup, page: () => const UserSetupPage(), binding: AuthBinding()),
  ];
}
