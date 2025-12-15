import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class AccountPage extends StatelessWidget {
  static const route = '/account';
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài Khoản'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          children: [
            const Text('Thông tin cá nhân', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),

            const _ReadonlyField(icon: Icons.person_outline, label: 'Họ và tên', value: 'Alex Nguyen'),
            const SizedBox(height: 10),
            const _ReadonlyField(icon: Icons.email_outlined, label: 'Email', value: 'alex.nguyen@example.com'),
            const SizedBox(height: 10),
            const _ReadonlyField(icon: Icons.calendar_month_outlined, label: 'Ngày sinh', value: '15/06/1995'),

            const SizedBox(height: 18),
            const Text('Bảo mật', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),

            _ActionCard(
              title: 'Đổi mật khẩu',
              subtitle: 'Cập nhật mật khẩu của bạn',
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _ActionCard(
              title: 'Xác thực hai yếu tố',
              subtitle: 'Tăng cường bảo mật tài khoản',
              onTap: () {},
            ),

            const SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Xóa tài khoản', style: TextStyle(color: AppColors.danger)),
              ),
            ),

            const SizedBox(height: 10),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {},
                child: const Text('Lưu thay đổi', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadonlyField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ReadonlyField({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.subText),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
                const SizedBox(height: 6),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
          ],
        ),
      ),
    );
  }
}
