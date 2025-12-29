import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/user_profile.dart';
import '../../../services/profile_service.dart';
import '../../../services/stats_service.dart';
import '../../../repositories/auth_repository.dart';
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
import '../../homes/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService();
  final AuthRepository _authRepository = AuthRepository();
  final StatsService _statsService = StatsService();
  
  UserProfile? _userProfile;
  bool _isLoading = true;
  
  // Stats
  int _booksRead = 0;
  int _readingStreak = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadStats();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _profileService.getCurrentUserProfile();
      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadStats() async {
    try {
      final stats = await _statsService.getAllStats();
      if (mounted) {
        setState(() {
          _booksRead = stats['booksRead'] ?? 0;
          _readingStreak = stats['readingStreak'] ?? 0;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) {
      // Reload profile when returning from edit pages
      _loadProfile();
      _loadStats();
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authRepository.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
        );
      }
    }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await _loadProfile();
                await _loadStats();
              },
              child: ListView(
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
                        child: CircleAvatar(
                          backgroundImage: _userProfile?.photoURL != null
                              ? NetworkImage(_userProfile!.photoURL!)
                              : const AssetImage('assets/images/avatar_alex.png') as ImageProvider,
                          backgroundColor: const Color(0xFFE5E7EB),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _userProfile?.effectiveDisplayName ?? 'Người dùng',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: ProfileTokens.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userProfile?.formattedJoinDate ?? '',
                        style: const TextStyle(fontSize: 12, color: ProfileTokens.subText),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: MetricCard(
                          value: '$_booksRead',
                          label: 'Sách đã đọc',
                          valueColor: ProfileTokens.primary,
                          bg: ProfileTokens.primarySoft,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MetricCard(
                          value: '$_readingStreak',
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
                  DangerTile(title: 'Đăng xuất', onTap: _logout),
                ],
              ),
            ),
    );
  }
}
