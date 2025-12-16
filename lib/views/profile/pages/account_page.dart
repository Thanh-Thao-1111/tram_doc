import 'package:flutter/material.dart';
import '../widgets/profile_tokens.dart';
import '../widgets/section_title.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileTokens.bg,
      appBar: AppBar(
        backgroundColor: ProfileTokens.bg,
        elevation: 0,
        leading: const BackButton(color: ProfileTokens.text),
        title: const Text('Tài khoản', style: TextStyle(fontWeight: FontWeight.w900, color: ProfileTokens.text)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: [
          const SectionTitle('Thông tin cá nhân'),
          const _ReadonlyField(label: 'Họ và tên', value: 'Alex Nguyen', icon: Icons.person_outline),
          const _ReadonlyField(label: 'Email', value: 'alex.nguyen@example.com', icon: Icons.email_outlined),
          const _ReadonlyField(label: 'Ngày sinh', value: '15/06/1995', icon: Icons.calendar_month_outlined),

          const SectionTitle('Bảo mật'),
          _ActionCard(
            title: 'Đổi mật khẩu',
            subtitle: 'Cập nhật mật khẩu của bạn',
            onTap: () {},
          ),
          _ActionCard(
            title: 'Xác thực hai yếu tố',
            subtitle: 'Tăng cường bảo mật tài khoản',
            onTap: () {},
          ),

          const SizedBox(height: 8),
          TextButton(
            onPressed: () {},
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text('Xóa tài khoản', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w700)),
            ),
          ),

          const SizedBox(height: 6),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ProfileTokens.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              onPressed: () {},
              child: const Text('Lưu thay đổi', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadonlyField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ReadonlyField({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: ProfileTokens.card, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Icon(icon, color: ProfileTokens.subText),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: ProfileTokens.subText)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: ProfileTokens.card, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: ProfileTokens.subText)),
      ),
    );
  }
}
