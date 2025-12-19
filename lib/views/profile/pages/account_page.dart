import 'package:flutter/material.dart';
import '../widgets/profile_tokens.dart';
import '../widgets/section_title.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String name = 'Alex Nguyen';
  String email = 'alex.nguyen@example.com';
  String dob = '15/06/1995';

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
          _ReadonlyField(
            label: 'Họ và tên',
            value: name,
            icon: Icons.person_outline,
            onTap: () => _showEditFieldDialog(context, 'Họ và tên', name, (v) => setState(() => name = v), validator: (s) {
              if (s == null || s.trim().isEmpty) return 'Tên không được để trống';
              return null;
            }),
          ),
          _ReadonlyField(
            label: 'Email',
            value: email,
            icon: Icons.email_outlined,
            onTap: () => _showEditFieldDialog(context, 'Email', email, (v) => setState(() => email = v), validator: (s) {
              if (s == null || s.trim().isEmpty) return 'Email không được để trống';
              final emailReg = RegExp(r"^[\w\-.]+@[\w\-]+\.[a-zA-Z]{2,}");
              if (!emailReg.hasMatch(s)) return 'Email không hợp lệ';
              return null;
            }, keyboardType: TextInputType.emailAddress),
          ),
          _ReadonlyField(
            label: 'Ngày sinh',
            value: dob,
            icon: Icons.calendar_month_outlined,
            onTap: () => _showEditFieldDialog(context, 'Ngày sinh (dd/MM/yyyy)', dob, (v) => setState(() => dob = v), validator: (s) {
              if (s == null || s.trim().isEmpty) return 'Ngày sinh không được để trống';
              final dReg = RegExp(r'^\\d{2}/\\d{2}/\\d{4}\$');
              if (!dReg.hasMatch(s)) return 'Định dạng ngày sinh: dd/MM/yyyy';
              return null;
            }, keyboardType: TextInputType.datetime),
          ),

          const SectionTitle('Bảo mật'),
          _ActionCard(
            title: 'Đổi mật khẩu',
            subtitle: 'Cập nhật mật khẩu của bạn',
            onTap: () => _showChangePasswordDialog(context),
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

  Future<void> _showEditFieldDialog(BuildContext context, String label, String initialValue, ValueChanged<String> onSave,
      {String? Function(String?)? validator, TextInputType keyboardType = TextInputType.text}) async {
    final _formKey = GlobalKey<FormState>();
    String value = initialValue;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(label),
        content: Form(
          key: _formKey,
          child: TextFormField(
            initialValue: initialValue,
            keyboardType: keyboardType,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            validator: validator,
            onChanged: (v) => value = v,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? true) {
                onSave(value);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    String current = '';
    String next = '';
    String confirm = '';

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đổi mật khẩu'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mật khẩu hiện tại'),
                validator: (v) => (v == null || v.isEmpty) ? 'Vui lòng nhập mật khẩu hiện tại' : null,
                onChanged: (v) => current = v,
              ),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mật khẩu mới'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu mới';
                  if (v.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự';
                  return null;
                },
                onChanged: (v) => next = v,
              ),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Xác nhận mật khẩu mới'),
                validator: (v) => (v != next) ? 'Mật khẩu xác nhận không khớp' : null,
                onChanged: (v) => confirm = v,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mật khẩu đã được cập nhật')));
              }
            },
            child: const Text('Lưu'),
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
  final VoidCallback? onTap;
  final Color valueColor;
  final Color iconColor;

  const _ReadonlyField({
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
    this.valueColor = const Color(0xFF71717A),
    this.iconColor = const Color(0xFF71717A),
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: ProfileTokens.card, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: ProfileTokens.subText)),
                const SizedBox(height: 4),
                Text(value, style: TextStyle(fontWeight: FontWeight.w800, color: valueColor)),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(borderRadius: BorderRadius.circular(14), onTap: onTap, child: content);
    }
    return content;
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
