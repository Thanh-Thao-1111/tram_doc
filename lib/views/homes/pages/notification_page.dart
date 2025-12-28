import 'package:flutter/material.dart';

const Color notificationBgColor = Color(0xFFF7F7F7);

class NotificationPage extends StatelessWidget {
   const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: notificationBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Thông báo',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          ),
        ],
      ),
      body: ListView(
        children: const [
          _NotificationItem(
            icon: Icons.notifications,
            iconBg: Color(0xFFFFE5E5),
            iconColor: Colors.redAccent,
            title: 'Nhắc nhở ôn tập: 15 thẻ đang chờ bạn.',
            time: '2m trước',
          ),
          _NotificationItem(
            icon: Icons.person,
            iconBg: Color(0xFFFFF0E5),
            iconColor: Colors.orange,
            title: 'Lan Chi đã bắt đầu theo dõi bạn.',
            time: '1h trước',
          ),
          _NotificationItem(
            icon: Icons.comment,
            iconBg: Color(0xFFFFF8E1),
            iconColor: Colors.amber,
            title: 'Minh bình luận vào ghi chú "Dune": "Ý này hay quá".',
            time: '3h trước',
          ),
          _NotificationItem(
            icon: Icons.menu_book,
            iconBg: Color(0xFFE8F5E9),
            iconColor: Colors.green,
            title: 'Gợi ý sách mới: "Sapiens" có thể bạn sẽ thích.',
            time: '1d trước',
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String time;

  const _NotificationItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: iconBg,
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  time,
                  style:
                      const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
