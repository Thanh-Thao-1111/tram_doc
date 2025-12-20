import 'package:flutter/material.dart';
import '../widgets/profile_tokens.dart';
import '../widgets/section_title.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  int mode = 0; // 0: Sáng, 1: Tối, 2: Hệ thống
  int colorIndex = 0;
  double fontSize = 16;

  final colors = const [
    Color(0xFF38A169),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFFFF7A00),
    Color(0xFFEF4444),
  ];

  final colorNames = const ['Xanh lá', 'Xanh dương', 'Tím', 'Hồng', 'Cam', 'Đỏ'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileTokens.bg,
      appBar: AppBar(
        backgroundColor: ProfileTokens.bg,
        elevation: 0,
        leading: const BackButton(color: ProfileTokens.text),
        title: const Text('Giao diện', style: TextStyle(fontWeight: FontWeight.w900, color: ProfileTokens.text)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: [
          const SectionTitle('Chế độ hiển thị'),
          Row(
            children: [
              Expanded(child: _ModeChip(label: 'Sáng', icon: Icons.wb_sunny_outlined, selected: mode == 0, onTap: () => setState(() => mode = 0))),
              const SizedBox(width: 10),
              Expanded(child: _ModeChip(label: 'Tối', icon: Icons.nightlight_outlined, selected: mode == 1, onTap: () => setState(() => mode = 1))),
              const SizedBox(width: 10),
              Expanded(child: _ModeChip(label: 'Hệ thống', icon: Icons.desktop_windows_outlined, selected: mode == 2, onTap: () => setState(() => mode = 2))),
            ],
          ),

          const SectionTitle('Màu chủ đạo'),
          GridView.builder(
            itemCount: colors.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (_, i) {
              final selected = i == colorIndex;
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => colorIndex = i),
                child: Container(
                  decoration: BoxDecoration(
                    color: ProfileTokens.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: selected ? ProfileTokens.text : ProfileTokens.divider, width: selected ? 1.5 : 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 18, height: 18, decoration: BoxDecoration(color: colors[i], shape: BoxShape.circle)),
                      const SizedBox(height: 10),
                      Text(colorNames[i], style: const TextStyle(fontSize: 12, color: ProfileTokens.subText)),
                    ],
                  ),
                ),
              );
            },
          ),

          const SectionTitle('Kích thước chữ'),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: ProfileTokens.card, borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                Row(
                  children: const [
                    Text('T', style: TextStyle(color: ProfileTokens.subText)),
                    Spacer(),
                    Text('Vừa', style: TextStyle(fontWeight: FontWeight.w800)),
                    Spacer(),
                    Text('T', style: TextStyle(color: ProfileTokens.subText, fontSize: 18)),
                  ],
                ),
                Slider(
                  value: fontSize,
                  min: 12,
                  max: 22,
                  divisions: 10,
                  activeColor: ProfileTokens.primary,
                  onChanged: (v) => setState(() => fontSize = v),
                ),
                Text('${fontSize.toStringAsFixed(0)}px', style: const TextStyle(color: ProfileTokens.subText, fontSize: 12)),
              ],
            ),
          ),

          const SizedBox(height: 14),
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

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: ProfileTokens.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? ProfileTokens.primary : ProfileTokens.divider, width: selected ? 1.6 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? ProfileTokens.primary : ProfileTokens.subText),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 12, color: selected ? ProfileTokens.primary : ProfileTokens.subText, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}
