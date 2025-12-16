import 'package:flutter/material.dart';
import '../widgets/profile_tokens.dart';
import '../widgets/section_title.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileTokens.bg,
      appBar: AppBar(
        backgroundColor: ProfileTokens.bg,
        elevation: 0,
        leading: const BackButton(color: ProfileTokens.text),
        title: const Text('Trợ giúp & Hỗ trợ',
            style: TextStyle(fontWeight: FontWeight.w900, color: ProfileTokens.text)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: [
          const SectionTitle('Liên hệ với chúng tôi'),
          _ContactTile(
            icon: Icons.chat_bubble_outline,
            iconBg: ProfileTokens.primary,
            title: 'Chat trực tiếp',
            onTap: () {},
          ),
          _ContactTile(
            icon: Icons.email_outlined,
            iconBg: ProfileTokens.blue,
            title: 'Email',
            subtitle: 'support@readingapp.com',
            onTap: () {},
          ),
          const SectionTitle('Hướng dẫn sử dụng'),
          const _PlainHelpTile(icon: Icons.menu_book_outlined, title: 'Hướng dẫn cho người mới'),
          const _PlainHelpTile(icon: Icons.settings_outlined, title: 'Cài đặt nâng cao'),
          const _PlainHelpTile(icon: Icons.security_outlined, title: 'Chính sách bảo mật'),
          const _PlainHelpTile(icon: Icons.description_outlined, title: 'Điều khoản sử dụng'),
          const _PlainHelpTile(icon: Icons.credit_card_outlined, title: 'Thanh toán & Đăng ký'),
        ],
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
      decoration: BoxDecoration(color: ProfileTokens.card, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: subtitle == null
            ? null
            : Text(subtitle!, style: const TextStyle(fontSize: 12, color: ProfileTokens.subText)),
        trailing: const Icon(Icons.chevron_right, color: ProfileTokens.subText),
      ),
    );
  }
}

class _PlainHelpTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _PlainHelpTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: ProfileTokens.card, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Icon(icon, color: ProfileTokens.subText),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        trailing: const Icon(Icons.chevron_right, color: ProfileTokens.subText),
      ),
    );
  }
}
