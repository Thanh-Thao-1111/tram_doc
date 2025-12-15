import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

enum DisplayMode { light, dark, system }

class AppearancePage extends StatefulWidget {
  static const route = '/appearance';
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  DisplayMode mode = DisplayMode.light;
  int selectedColor = 0;
  double fontSize = 16;

  final colors = const [
    AppColors.primary,
    AppColors.blue,
    AppColors.purple,
    AppColors.pink,
    AppColors.orange,
    AppColors.red,
  ];

  final colorNames = const ['Xanh lá', 'Xanh dương', 'Tím', 'Hồng', 'Cam', 'Đỏ'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giao diện'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          children: [
            const Text('Chế độ hiển thị', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(child: _ModeChip(title: 'Sáng', icon: Icons.wb_sunny_outlined, selected: mode == DisplayMode.light, onTap: () => setState(() => mode = DisplayMode.light))),
                const SizedBox(width: 10),
                Expanded(child: _ModeChip(title: 'Tối', icon: Icons.nightlight_outlined, selected: mode == DisplayMode.dark, onTap: () => setState(() => mode = DisplayMode.dark))),
                const SizedBox(width: 10),
                Expanded(child: _ModeChip(title: 'Hệ thống', icon: Icons.computer_outlined, selected: mode == DisplayMode.system, onTap: () => setState(() => mode = DisplayMode.system))),
              ],
            ),

            const SizedBox(height: 18),
            const Text('Màu chủ đạo', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: colors.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.25,
              ),
              itemBuilder: (_, i) {
                final isSelected = i == selectedColor;
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => setState(() => selectedColor = i),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isSelected ? colors[i] : AppColors.divider, width: isSelected ? 1.4 : 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(color: colors[i], shape: BoxShape.circle),
                        ),
                        const SizedBox(height: 10),
                        Text(colorNames[i], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 18),
            const Text('Kích thước chữ', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: [
                  Slider(
                    value: fontSize,
                    min: 12,
                    max: 20,
                    divisions: 8,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => fontSize = v),
                  ),
                  Text('${fontSize.toStringAsFixed(0)}px', style: const TextStyle(color: AppColors.subText, fontSize: 12)),
                ],
              ),
            ),

            const SizedBox(height: 16),
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

class _ModeChip extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.primary : AppColors.divider, width: selected ? 1.4 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? AppColors.primary : AppColors.subText),
            const SizedBox(height: 6),
            Text(title, style: TextStyle(fontWeight: FontWeight.w800, color: selected ? AppColors.primary : AppColors.subText, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
