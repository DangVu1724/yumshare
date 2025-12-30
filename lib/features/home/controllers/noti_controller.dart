import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/auth/services/auth_service.dart';
import 'package:yumshare/models/notifications.dart';
import 'package:yumshare/repository/notification_repo.dart';

class NotiController extends GetxController {
  final NotificationRepo _notificationRepository = NotificationRepo();
  final AuthService auth = AuthService();

  final notifications = <Notifications>[].obs;
  final unreadCount = 0.obs;

  StreamSubscription<List<Notifications>>? _subscription;

  @override
  void onInit() {
    super.onInit();

    final userId = auth.currentUser?.uid;
    if (userId == null) return;

    _subscription = _notificationRepository.streamNotifications(userId).listen((data) {
      notifications.value = data;
      unreadCount.value = data.where((noti) => !noti.isRead).length;
    });

    ever<List<Notifications>>(notifications, (list) {
      final unread = list.where((n) => !n.isRead).toList();

      if (unread.isNotEmpty) {
        final latest = unread.first;

        Get.snackbar(
          latest.title,
          latest.message,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          margin: EdgeInsets.all(12),
        );
      }
    });
  }

  Future<void> markAsRead(String notificationId) async {
    await _notificationRepository.markAsRead(notificationId);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
