import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:yumshare/features/auth/pages/onboarding_page.dart';
import 'package:yumshare/firebase_options.dart';
import 'package:yumshare/models/adapter/recipe_hive.dart';
import 'package:yumshare/routers/app_pages.dart';
import 'package:yumshare/utils/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Hive.registerAdapter(RecipeFeedHiveAdapter());
  await Hive.openBox('cache');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      title: 'Flutter Demo',
      home: OnboardingPage(),
      getPages: AppPages.pages,
    );
  }
}
