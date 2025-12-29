import 'package:flutter/material.dart';
import '../widgets/profile_tokens.dart';
import '../widgets/section_title.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  // Local state for UI demonstration
  int mode = 0; // 0: Sáng, 1: Tối, 2: Hệ thống
  int colorIndex = 0;
  double fontSize = 16;
  bool _isSaving = false;

  final colors = const [
    Color(0xFF38A169),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFFFF7A00),
    Color(0xFFEF4444),
  ];

  final colorNames = const ['Xanh lá', 'Xanh dương', 'Tím', 'Hồng', 'Cam', 'Đỏ'];

   Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    
    // Simulate saving delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu cài đặt giao diện (Demo)!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  String get _fontSizeLabel {
    if (fontSize <= 14) return 'Nhỏ';
    if (fontSize <= 17) return 'Vừa';
    return 'Lớn';
  }

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
                    border: Border.all(
                      color: selected ? colors[i] : ProfileTokens.divider,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: colors[i],
                          shape: BoxShape.circle,
                          border: selected
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                          boxShadow: selected
                              ? [BoxShadow(color: colors[i].withOpacity(0.4), blurRadius: 8)]
                              : null,
                        ),
                        child: selected
                            ? const Icon(Icons.check, color: Colors.white, size: 14)
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        colorNames[i],
                        style: TextStyle(
                          fontSize: 12,
                          color: selected ? colors[i] : ProfileTokens.subText,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                        ),
                      ),
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
                  children: [
                    const Text('A', style: TextStyle(color: ProfileTokens.subText, fontSize: 12)),
                    const Spacer(),
                    Text(_fontSizeLabel, style: const TextStyle(fontWeight: FontWeight.w800)),
                    const Spacer(),
                    const Text('A', style: TextStyle(color: ProfileTokens.subText, fontSize: 20)),
                  ],
                ),
                Slider(
                  value: fontSize,
                  min: 12,
                  max: 22,
                  divisions: 10,
                  activeColor: colors[colorIndex],
                  onChanged: (v) => setState(() => fontSize = v),
                ),
                // Preview
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ProfileTokens.bg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Đây là xem trước kích thước chữ ${fontSize.toStringAsFixed(0)}px',
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors[colorIndex],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              onPressed: _isSaving ? null : _saveSettings,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Lưu thay đổi', style: TextStyle(fontWeight: FontWeight.w900)),
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
