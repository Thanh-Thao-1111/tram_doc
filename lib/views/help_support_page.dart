import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class HelpSupportPage extends StatelessWidget {
  static const route = '/help-support';
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trợ giúp & Hỗ trợ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          children: [
            const _SectionTitle('Liên hệ với chúng tôi'),
            _ContactTile(
              icon: Icons.chat_bubble_outline,
              iconBg: AppColors.primary,
              title: 'Chat trực tiếp',
              onTap: () {},
            ),
            _ContactTile(
              icon: Icons.email_outlined,
              iconBg: AppColors.blue,
              title: 'Email',
              subtitle: 'support@readingapp.com',
              onTap: () {},
            ),
            const SizedBox(height: 14),
            const _SectionTitle('Hướng dẫn sử dụng'),
            _PlainTile(
              icon: Icons.menu_book_outlined,
              title: 'Hướng dẫn cho người mới',
              onTap: () {},
            ),
            _PlainTile(
              icon: Icons.settings_outlined,
              title: 'Cài đặt nâng cao',
              onTap: () {},
            ),
            _PlainTile(
              icon: Icons.security_outlined,
              title: 'Chính sách bảo mật',
              onTap: () {},
            ),
            _PlainTile(
              icon: Icons.description_outlined,
              title: 'Điều khoản sử dụng',
              onTap: () {},
            ),
            _PlainTile(
              icon: Icons.credit_card_outlined,
              title: 'Thanh toán & Đăng ký',
              onTap: () {},
            ),
          ],
        ),
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

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.iconBg,
    required this.title,
    this.subtitle,
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
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: subtitle == null
            ? null
            : Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.subText),
      ),
    );
  }
}

class _PlainTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _PlainTile({
    required this.icon,
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
        leading: Icon(icon, color: AppColors.subText),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.subText),
      ),
    );
  }
}
