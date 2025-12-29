import 'dart:async';

import 'package:get/get.dart';
import 'package:yumshare/features/auth/services/auth_service.dart';
import 'package:yumshare/models/notifications.dart';
import 'package:yumshare/repository/notification_repo.dart';

class NotiController extends GetxController {
  final NotificationRepo _notificationRepository = NotificationRepo();
  final AuthService auth = AuthService();

  final notifications = <Notifications>[].obs;

  StreamSubscription<List<Notifications>>? _subscription;

  @override
  void onInit() {
    super.onInit();

    final userId = auth.currentUser?.uid;
    if (userId == null) return;

    _subscription = _notificationRepository.streamNotifications(userId).listen((data) {
      notifications.value = data;
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
