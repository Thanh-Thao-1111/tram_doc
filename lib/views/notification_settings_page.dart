import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class NotificationSettingsPage extends StatefulWidget {
  static const route = '/notifications';
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool push = true;
  bool remind = true;
  bool achievement = true;
  bool community = false;
  bool comment = true;

  TimeOfDay? remindTime;

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: remindTime ?? now,
      helpText: 'Chọn giờ nhắc đọc sách',
    );
    if (picked != null) setState(() => remindTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          children: [
            const Text('Cài đặt thông báo', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),

            _SwitchCard(
              icon: Icons.notifications_none,
              title: 'Thông báo đẩy',
              subtitle: 'Nhận thông báo trên thiết bị',
              value: push,
              onChanged: (v) => setState(() => push = v),
            ),
            _SwitchCard(
              icon: Icons.menu_book_outlined,
              title: 'Nhắc nhở đọc sách',
              subtitle: 'Nhắc bạn đọc mỗi ngày',
              value: remind,
              onChanged: (v) => setState(() => remind = v),
            ),
            _SwitchCard(
              icon: Icons.emoji_events_outlined,
              title: 'Thành tích mới',
              subtitle: 'Khi bạn đạt thành tích',
              value: achievement,
              onChanged: (v) => setState(() => achievement = v),
            ),
            _SwitchCard(
              icon: Icons.people_outline,
              title: 'Hoạt động cộng đồng',
              subtitle: 'Cập nhật từ cộng đồng',
              value: community,
              onChanged: (v) => setState(() => community = v),
            ),
            _SwitchCard(
              icon: Icons.chat_bubble_outline,
              title: 'Bình luận và thảo luận',
              subtitle: 'Khi có người phản hồi',
              value: comment,
              onChanged: (v) => setState(() => comment = v),
            ),

            const SizedBox(height: 14),
            const Text('Thời gian nhắc nhở', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),

            InkWell(
              onTap: remind ? _pickTime : null,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Giờ nhắc đọc sách', style: TextStyle(color: AppColors.subText, fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            remindTime == null ? '' : remindTime!.format(context),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const Icon(Icons.schedule, color: AppColors.subText),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
