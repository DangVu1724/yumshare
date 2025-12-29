import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yumshare/features/home/controllers/noti_controller.dart';
import 'package:yumshare/models/notifications.dart';
import 'package:yumshare/utils/themes/app_colors.dart';
import 'package:yumshare/utils/themes/text_style.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotiController _notiController = Get.find<NotiController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notifications', style: AppTextStyles.heading2),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            SizedBox(width: 5),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
          ],
          bottom: TabBar(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2.5,
            tabs: [
              Tab(child: Text('General', style: AppTextStyles.body)),
              Tab(child: Text('System', style: AppTextStyles.body)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNotificationItem(_notiController.notifications, _notiController),
            Center(child: Text('System', style: AppTextStyles.body)),
          ],
        ),
      ),
    );
  }
}

Widget _buildNotificationItem(List<Notifications> notifications, NotiController notiController) {
  return Obx(() {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 10),
            const Text('Empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            Text(
              'You don\'t have any notifications at this time',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: notifications.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final isUnread = !notification.isRead;

        return Container(
          color: isUnread ? AppColors.primary.withOpacity(0.06) : Colors.transparent,
          child: ListTile(
            leading: Stack(
              children: [
                const CircleAvatar(radius: 26, backgroundImage: AssetImage('assets/images/avatar1.png')),
                if (isUnread)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    ),
                  ),
              ],
            ),
            title: Text(notification.message, style: isUnread ? AppTextStyles.bodyBold : AppTextStyles.body),
            subtitle: Text(
              formatTimeAgoWithHour(notification.createdAt),
              style: AppTextStyles.body.copyWith(color: Colors.grey[600], fontSize: 13),
            ),
            trailing: const Icon(Icons.more_horiz_outlined),
            onTap: () {
              if (isUnread) {
                notiController.markAsRead(notification.id);
              }
            },
          ),
        );
      },
    );
  });
}

String formatTimeAgoWithHour(DateTime time) {
  final now = DateTime.now();
  final difference = now.difference(time);

  String ago;

  if (difference.inSeconds < 60) {
    ago = 'Vừa xong';
  } else if (difference.inMinutes < 60) {
    ago = '${difference.inMinutes} phút trước';
  } else if (difference.inHours < 24) {
    ago = '${difference.inHours} giờ trước';
  } else if (difference.inDays < 7) {
    ago = '${difference.inDays} ngày trước';
  } else {
    ago = '${(difference.inDays / 7).floor()} tuần trước';
  }

  final hour = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  return '$ago | $hour';
}
