import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class StatsPage extends StatelessWidget {
  static const route = '/stats';
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          children: [
            Row(
              children: const [
                Expanded(child: _SmallStatCard(value: '50', label: 'Sách đã đọc', valueColor: AppColors.primary, bg: AppColors.primarySoft)),
                SizedBox(width: 12),
                Expanded(child: _SmallStatCard(value: '300', label: 'Chuỗi đọc (ngày)', valueColor: AppColors.orange, bg: Color(0xFFFFF3E9))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(child: _SmallStatCard(value: '15', label: 'Flashcards', valueColor: AppColors.blue, bg: Color(0xFFEFF6FF))),
                SizedBox(width: 12),
                Expanded(child: _SmallStatCard(value: '12', label: 'Chuỗi ôn tập (ngày)', valueColor: AppColors.purple, bg: Color(0xFFF3E8FF))),
              ],
            ),
            const SizedBox(height: 16),

            _Section(
              title: 'Thời gian đọc tuần này',
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.subText),
              ),
              child: const _WeeklyBarChart(),
            ),

            const SizedBox(height: 14),

            const _Section(
              title: 'Sách đã đọc theo tháng',
              child: _MonthlyLineChart(),
            ),

            const SizedBox(height: 14),

            const _Section(
              title: 'Mục tiêu đọc sách',
              child: _GoalCard(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final Color bg;

  const _SmallStatCard({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: valueColor)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _Section({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800))),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  const _WeeklyBarChart();

  @override
  Widget build(BuildContext context) {
    final values = <double>[45, 60, 30, 90, 75, 120, 105]; // T2..CN
    final labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    final maxV = values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (i) {
          final h = (values[i] / maxV) * 130;
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: h,
                  width: 18,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 8),
                Text(labels[i], style: const TextStyle(fontSize: 11, color: AppColors.subText)),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _MonthlyLineChart extends StatelessWidget {
  const _MonthlyLineChart();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: CustomPaint(
        painter: _LinePainter(points: const [5, 7, 6, 9, 8, 10]),
        child: const Padding(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('T1', style: TextStyle(fontSize: 11, color: AppColors.subText)),
                Text('T2', style: TextStyle(fontSize: 11, color: AppColors.subText)),
                Text('T3', style: TextStyle(fontSize: 11, color: AppColors.subText)),
                Text('T4', style: TextStyle(fontSize: 11, color: AppColors.subText)),
                Text('T5', style: TextStyle(fontSize: 11, color: AppColors.subText)),
                Text('T6', style: TextStyle(fontSize: 11, color: AppColors.subText)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<int> points;
  _LinePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paintAxis = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;

    // grid
    for (int i = 0; i < 4; i++) {
      final y = (size.height - 22) * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintAxis);
    }

    final maxV = points.reduce((a, b) => a > b ? a : b).toDouble();
    final minV = points.reduce((a, b) => a < b ? a : b).toDouble();

    double norm(int v) {
      final denom = (maxV - minV) == 0 ? 1 : (maxV - minV);
      return (v - minV) / denom;
    }

    final linePaint = Paint()
      ..color = AppColors.blue
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()..color = AppColors.blue;

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = (size.width) * (i / (points.length - 1));
      final y = (size.height - 34) * (1 - norm(points[i])) + 6;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, linePaint);

    for (int i = 0; i < points.length; i++) {
      final x = (size.width) * (i / (points.length - 1));
      final y = (size.height - 34) * (1 - norm(points[i])) + 6;
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
      canvas.drawCircle(Offset(x, y), 7, Paint()..color = AppColors.blue.withAlpha((0.08 * 255).round()));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GoalCard extends StatelessWidget {
  const _GoalCard();

  @override
  Widget build(BuildContext context) {
    const total = 60;
    const done = 50;
    final progress = done / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Expanded(
              child: Text('Mục tiêu năm 2025', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            Text('50/60 cuốn', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: AppColors.divider,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        _GoalRow(left: 'Còn lại', right: '${total - done} cuốn'),
        const SizedBox(height: 6),
        const _GoalRow(left: 'Trung bình/tháng', right: '8.3 cuốn'),
        const SizedBox(height: 6),
        const _GoalRow(left: 'Dự kiến hoàn thành', right: 'Tháng 12, 2025', rightColor: AppColors.primary),
      ],
    );
  }
}

class _GoalRow extends StatelessWidget {
  final String left;
  final String right;
  final Color? rightColor;

  const _GoalRow({required this.left, required this.right, this.rightColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(left, style: const TextStyle(color: AppColors.subText, fontSize: 12))),
        Text(right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: rightColor ?? AppColors.text)),
      ],
    );
  }
}
