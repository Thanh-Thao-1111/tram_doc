import 'package:flutter/material.dart';
import '../widgets/profile_tokens.dart';
import '../widgets/section_title.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool push = true;
  bool remind = true;
  bool achievement = true;
  bool community = true;
  bool comment = true;

  TimeOfDay time = const TimeOfDay(hour: 8, minute: 0);

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: time);
    if (picked != null) setState(() => time = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileTokens.bg,
      appBar: AppBar(
        backgroundColor: ProfileTokens.bg,
        elevation: 0,
        leading: const BackButton(color: ProfileTokens.text),
        title: const Text('Thông báo', style: TextStyle(fontWeight: FontWeight.w900, color: ProfileTokens.text)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: [
          const SectionTitle('Cài đặt thông báo'),
          _SwitchTile(
            icon: Icons.notifications_none,
            title: 'Thông báo đẩy',
            subtitle: 'Nhận thông báo trên thiết bị',
            value: push,
            onChanged: (v) => setState(() => push = v),
          ),
          _SwitchTile(
            icon: Icons.menu_book_outlined,
            title: 'Nhắc nhở đọc sách',
            subtitle: 'Nhắc bạn đọc mỗi ngày',
            value: remind,
            onChanged: (v) => setState(() => remind = v),
          ),
          _SwitchTile(
            icon: Icons.emoji_events_outlined,
            title: 'Thành tích mới',
            subtitle: 'Khi bạn đạt thành tích',
            value: achievement,
            onChanged: (v) => setState(() => achievement = v),
          ),
          _SwitchTile(
            icon: Icons.groups_outlined,
            title: 'Hoạt động cộng đồng',
            subtitle: 'Cập nhật từ cộng đồng',
            value: community,
            onChanged: (v) => setState(() => community = v),
          ),
          _SwitchTile(
            icon: Icons.chat_bubble_outline,
            title: 'Bình luận và thảo luận',
            subtitle: 'Khi có người phản hồi',
            value: comment,
            onChanged: (v) => setState(() => comment = v),
          ),

          const SectionTitle('Thời gian nhắc nhở'),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: ProfileTokens.card, borderRadius: BorderRadius.circular(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Giờ nhắc đọc sách', style: TextStyle(fontSize: 12, color: ProfileTokens.subText)),
                const SizedBox(height: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _pickTime,
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ProfileTokens.divider),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
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
      decoration: BoxDecoration(color: ProfileTokens.card, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: ProfileTokens.primary, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: ProfileTokens.subText)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: ProfileTokens.primary,
        ),
      ),
    );
  }
}
