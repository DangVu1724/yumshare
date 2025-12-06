import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/auth/pages/login_page.dart';
import 'package:yumshare/features/auth/pages/register_page.dart';
import 'package:yumshare/routers/app_routes.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Logo & Title
              const Icon(Icons.restaurant, size: 64, color: Color(0xFFFF6B6B)),
              const SizedBox(height: 24),
              const Text(
                'YumShare',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
              ),
              const SizedBox(height: 8),
              Text('Chia sẻ thực đơn nấu ăn', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),

              const Spacer(),

              // Main Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.register);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B6B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Bắt đầu trải nghiệm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Get.toNamed(Routes.login);
                },
                child: const Text('Đã có tài khoản? Đăng nhập', style: TextStyle(color: Color(0xFF666666))),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
