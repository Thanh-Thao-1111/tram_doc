import 'package:flutter/material.dart';
import '../widgets/profile_tokens.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showName = true;
  String pronoun = 'Nữ';
  String displayName = 'Alex Nguyen';
  String location = '';
  String bio = '';
  String website = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileTokens.bg,
      appBar: AppBar(
        backgroundColor: ProfileTokens.bg,
        elevation: 0,
        leading: const BackButton(color: ProfileTokens.text),
        title: const Text('Hồ sơ', style: TextStyle(fontWeight: FontWeight.w900, color: ProfileTokens.text)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: [
          const Text(
            'Thông tin mà bạn nhập ở đây sẽ hiển thị với người dùng khác. Tìm hiểu thêm về cách chia sẻ thông tin an toàn',
            style: TextStyle(fontSize: 12, color: ProfileTokens.subText, height: 1.4),
          ),
          const SizedBox(height: 12),

          _RowAction(
            iconBg: ProfileTokens.purpleSoft,
            icon: Icons.photo_camera_outlined,
            title: 'Cập Nhật Hình Ảnh',
            onTap: () {},
          ),
          const SizedBox(height: 10),

          _RowField(label: 'Tên Hiển Thị', rightText: displayName, onTap: () => _editField(context, 'Tên Hiển Thị', displayName, (v) => setState(() => displayName = v), validator: (s) {
            if (s == null || s.trim().isEmpty) return 'Tên không được để trống';
            return null;
          })),
          _SwitchRow(
            label: 'Hiển thị Tên Hiển thị',
            value: showName,
            onChanged: (v) => setState(() => showName = v),
          ),
          _RowField(label: 'Địa điểm', rightText: location, onTap: () => _editField(context, 'Địa điểm', location, (v) => setState(() => location = v))),
          _RowField(label: 'Giới thiệu', rightText: bio, onTap: () => _editField(context, 'Giới thiệu', bio, (v) => setState(() => bio = v))),
          _DropdownRow(
            label: 'Đại từ nhân xưng',
            value: pronoun,
            items: const ['Nam', 'Nữ', 'Khác'],
            onChanged: (v) => setState(() => pronoun = v ?? pronoun),
          ),
          _RowField(label: 'Trang web cá nhân', rightText: website, onTap: () => _editField(context, 'Trang web cá nhân', website, (v) => setState(() => website = v), validator: (s) {
            if (s == null || s.trim().isEmpty) return null;
            final uri = Uri.tryParse(s);
            if (uri == null || (!uri.hasScheme)) return 'Nhập URL hợp lệ (bao gồm http/https)';
            return null;
          }, keyboardType: TextInputType.url)),
        ],
      ),
    );
  }

  Future<void> _editField(BuildContext context, String label, String initialValue, ValueChanged<String> onSave,
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
}

class _RowAction extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _RowAction({required this.iconBg, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: ProfileTokens.card, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: ProfileTokens.purple),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900))),
          ],
        ),
      ),
    );
  }
}

class _RowField extends StatelessWidget {
  final String label;
  final String rightText;
  final VoidCallback onTap;

  const _RowField({required this.label, required this.rightText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ProfileTokens.divider)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        title: Text(label, style: const TextStyle(color: ProfileTokens.subText)),
        trailing: SizedBox(
          width: 180,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              rightText,
              style: const TextStyle(fontWeight: FontWeight.w800, color: ProfileTokens.subText),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ProfileTokens.divider)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        title: Text(label, style: const TextStyle(color: ProfileTokens.subText)),
        trailing: Switch(value: value, onChanged: onChanged, activeColor: ProfileTokens.primary),
      ),
    );
  }
}

class _DropdownRow extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownRow({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ProfileTokens.divider)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: ProfileTokens.subText))),
          DropdownButton<String>(
            value: value,
            underline: const SizedBox.shrink(),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
