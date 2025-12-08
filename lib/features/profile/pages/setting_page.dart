import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/auth/controllers/auth_controller.dart';
import 'package:yumshare/routers/app_routes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthController _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),

      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          _settingItem(icon: Icons.person, bgColor: Colors.pink, title: "Personal Info", onTap: () {}),
          _settingItem(icon: Icons.notifications, bgColor: Colors.orange, title: "Notification", onTap: () {}),
          _settingItem(icon: Icons.shield, bgColor: Colors.green, title: "Security", onTap: () {}),
          _settingItem(
            icon: Icons.language,
            bgColor: Colors.blue,
            title: "Language",
            trailing: const Text("English (US)", style: TextStyle(color: Colors.grey)),
            onTap: () {},
          ),

          // Dark Mode toggle
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                _iconCircle(Icons.remove_red_eye, Colors.purple),
                const SizedBox(width: 14),
                const Text("Dark Mode", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const Spacer(),
                Switch(value: false, onChanged: (value) {}),
              ],
            ),
          ),
          Divider(color: Colors.grey.shade300),

          const SizedBox(height: 10),
          _settingItem(icon: Icons.group, bgColor: Colors.orange, title: "Invite Friends", onTap: () {}),
          _settingItem(icon: Icons.help_center, bgColor: Colors.green, title: "Help Center", onTap: () {}),
          _settingItem(icon: Icons.info, bgColor: Colors.blue, title: "About Cookpedia", onTap: () {}),

          const SizedBox(height: 20),
          _settingItem(
            icon: Icons.logout,
            bgColor: Colors.red,
            title: "Logout",
            textColor: Colors.red,
            onTap: () async {
              await _authController.signOut();
              if(_authController.isSignOut.value){
                Get.offAllNamed(Routes.login);
              }
            },
          ),
        ],
      ),
    );
  }
}

// ==================== WIDGET FUNCTION ====================

Widget _settingItem({
  required IconData icon,
  required Color bgColor,
  required String title,
  Color textColor = Colors.black,
  Widget? trailing,
  Function()? onTap,
}) {
  return Column(
    children: [
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              _iconCircle(icon, bgColor),
              const SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
              ),
              const Spacer(),
              if (trailing != null) trailing,
              if (trailing == null) const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _iconCircle(IconData icon, Color bgColor) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: bgColor.withOpacity(0.25), // làm pastel nhẹ
      shape: BoxShape.circle,
    ),
    child: Icon(
      icon,
      color: bgColor, // icon cùng màu với vòng
      size: 22,
    ),
  );
}
