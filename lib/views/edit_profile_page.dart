import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  static const route = '/edit-profile';
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showDisplayName = true;

  final displayNameCtrl = TextEditingController(text: 'Alex Nguyen');
  final locationCtrl = TextEditingController();
  final bioCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  String pronoun = 'Nữ';

  @override
  void dispose() {
    displayNameCtrl.dispose();
    locationCtrl.dispose();
    bioCtrl.dispose();
    websiteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          children: [
            const Text(
              'Thông tin mà bạn nhập ở đây sẽ hiển thị với người dùng khác. Tìm hiểu thêm về cách chia sẻ thông tin an toàn',
              style: TextStyle(fontSize: 12, color: AppColors.subText),
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.photo_camera_outlined, color: AppColors.purple),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Cập Nhật Hình Ảnh', style: TextStyle(fontWeight: FontWeight.w800))),
                  const Icon(Icons.chevron_right, color: AppColors.subText),
                ],
              ),
            ),

            const SizedBox(height: 14),
            _FieldRow(
              label: 'Tên Hiển Thị',
              child: TextField(controller: displayNameCtrl),
            ),
            const SizedBox(height: 10),
            _SwitchRow(
              label: 'Hiển thị Tên Hiển thị',
              value: showDisplayName,
              onChanged: (v) => setState(() => showDisplayName = v),
            ),
            const SizedBox(height: 10),
            _FieldRow(
              label: 'Địa điểm',
              child: TextField(controller: locationCtrl),
            ),
            const SizedBox(height: 10),
            _FieldRow(
              label: 'Giới thiệu',
              child: TextField(controller: bioCtrl, maxLines: 3),
            ),
            const SizedBox(height: 10),
            _DropdownRow(
              label: 'Đại từ nhân xưng',
              value: pronoun,
              items: const ['Nam', 'Nữ', 'Khác'],
              onChanged: (v) => setState(() => pronoun = v ?? pronoun),
            ),
            const SizedBox(height: 10),
            _FieldRow(
              label: 'Trang web cá nhân',
              child: TextField(controller: websiteCtrl),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _FieldRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
          const SizedBox(height: 10),
          child,
        ],
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
          Switch(value: value, activeThumbColor: AppColors.primary, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _DropdownRow extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownRow({required this.label, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.subText))),
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
