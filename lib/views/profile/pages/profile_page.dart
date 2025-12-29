import 'package:flutter/material.dart';

import '../widgets/profile_tokens.dart';
import '../widgets/section_title.dart';
import '../widgets/setting_tile.dart';
import '../widgets/danger_tile.dart';
import '../widgets/metric_card.dart';

import 'edit_profile_page.dart';
import 'account_page.dart';
import 'notification_settings_page.dart';
import 'appearance_page.dart';
import 'stats_page.dart';
import 'help_support_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileTokens.bg,
      appBar: AppBar(
        backgroundColor: ProfileTokens.bg,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Hồ sơ cá nhân',
          style: TextStyle(fontWeight: FontWeight.w900, color: ProfileTokens.text),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: [
          // Avatar + Name
          Column(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ProfileTokens.primary, width: 2),
                ),
                padding: const EdgeInsets.all(4),
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avatar_alex.png'),
                  backgroundColor: Color(0xFFE5E7EB),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Alex Nguyen',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: ProfileTokens.text),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tham gia tháng 1, 2024',
                style: TextStyle(fontSize: 12, color: ProfileTokens.subText),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                child: MetricCard(
                  value: '50',
                  label: 'Sách đã đọc',
                  valueColor: ProfileTokens.primary,
                  bg: ProfileTokens.primarySoft,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  value: '300',
                  label: 'Chuỗi đọc (ngày)',
                  valueColor: ProfileTokens.orange,
                  bg: ProfileTokens.orangeSoft,
                ),
              ),
            ],
          ),

          const SectionTitle('Tài khoản'),
          SettingTile(
            icon: Icons.badge_outlined,
            title: 'Hồ sơ',
            onTap: () => _go(context, const EditProfilePage()),
          ),
          SettingTile(
            icon: Icons.person_outline,
            title: 'Tài khoản',
            onTap: () => _go(context, const AccountPage()),
          ),

          const SectionTitle('Ứng dụng'),
          SettingTile(
            icon: Icons.notifications_none,
            title: 'Thông báo',
            onTap: () => _go(context, const NotificationSettingsPage()),
          ),
          SettingTile(
            icon: Icons.palette_outlined,
            title: 'Giao diện',
            onTap: () => _go(context, const AppearancePage()),
          ),
          SettingTile(
            icon: Icons.bar_chart_outlined,
            title: 'Thống kê',
            onTap: () => _go(context, const StatsPage()),
          ),

          const SectionTitle('Khác'),
          SettingTile(
            icon: Icons.help_outline,
            title: 'Trợ giúp & Hỗ trợ',
            onTap: () => _go(context, const HelpSupportPage()),
          ),

          const SizedBox(height: 6),
          DangerTile(title: 'Đăng xuất', onTap: () {}),
        ],
      ),
    );
  }
}
