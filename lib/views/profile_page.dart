import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'stats_page.dart';
import 'notification_settings_page.dart';
import 'appearance_page.dart';
import 'account_page.dart';
import 'edit_profile_page.dart';
import 'help_support_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            const _Header(),
            const SizedBox(height: 14),
            Row(
              children: const [
                Expanded(
                  child: _MetricCard(
                    value: '50',
                    label: 'Sách đã đọc',
                    valueColor: AppColors.primary,
                    bg: AppColors.primarySoft,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    value: '300',
                    label: 'Chuỗi đọc (ngày)',
                    valueColor: AppColors.orange,
                    bg: Color(0xFFFFF3E9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            _SectionTitle('Tài khoản'),
            _SettingTile(
              icon: Icons.badge_outlined,
              iconBg: const Color(0xFF38A169),
              title: 'Hồ sơ',
              onTap: () => Navigator.pushNamed(context, EditProfilePage.route),
            ),
            _SettingTile(
              icon: Icons.person_outline,
              iconBg: const Color(0xFF38A169),
              title: 'Tài khoản',
              onTap: () => Navigator.pushNamed(context, AccountPage.route),
            ),

            const SizedBox(height: 10),
            _SectionTitle('Ứng dụng'),
            _SettingTile(
              icon: Icons.notifications_none,
              iconBg: const Color(0xFF38A169),
              title: 'Thông báo',
              onTap: () => Navigator.pushNamed(context, NotificationSettingsPage.route),
            ),
            _SettingTile(
              icon: Icons.palette_outlined,
              iconBg: const Color(0xFF38A169),
              title: 'Giao diện',
              onTap: () => Navigator.pushNamed(context, AppearancePage.route),
            ),
            _SettingTile(
              icon: Icons.bar_chart_outlined,
              iconBg: const Color(0xFF38A169),
              title: 'Thống kê',
              onTap: () => Navigator.pushNamed(context, StatsPage.route),
            ),

            const SizedBox(height: 10),
            _SectionTitle('Khác'),
          _SettingTile(
          icon: Icons.help_outline,
          iconBg: const Color(0xFF38A169),
          title: 'Trợ giúp & Hỗ trợ',
          onTap: () => Navigator.pushNamed(context, HelpSupportPage.route),
        ),

            const SizedBox(height: 8),
            _DangerTile(
              title: 'Đăng xuất',
              onTap: () {
                // TODO: logout
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withAlpha((0.35 * 255).round()), width: 2),
          ),
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar_alex.png'),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Alex Nguyen',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        const Text(
          'Tham gia tháng 1, 2024',
          style: TextStyle(color: AppColors.subText, fontSize: 12),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final Color bg;

  const _MetricCard({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.subText),
          )
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 6, 2, 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.subText),
      ),
    );
  }
}

class _DangerTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DangerTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE4E6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.logout, color: AppColors.danger),
        ),
        title: Text(title, style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
