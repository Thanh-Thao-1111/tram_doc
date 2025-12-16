import 'package:flutter/material.dart';
import '../widgets/profile_tokens.dart';
import '../widgets/metric_card.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileTokens.bg,
      appBar: AppBar(
        backgroundColor: ProfileTokens.bg,
        elevation: 0,
        leading: const BackButton(color: ProfileTokens.text),
        title: const Text('Thống kê', style: TextStyle(fontWeight: FontWeight.w900, color: ProfileTokens.text)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: [
          Row(
            children: const [
              Expanded(
                child: MetricCard(
                  value: '50',
                  label: 'Sách đã đọc',
                  valueColor: ProfileTokens.primary,
                  bg: ProfileTokens.primarySoft,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  value: '300',
                  label: 'Chuỗi đọc (ngày)',
                  valueColor: ProfileTokens.orange,
                  bg: ProfileTokens.orangeSoft,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: MetricCard(
                  value: '15',
                  label: 'Flashcards',
                  valueColor: ProfileTokens.blue,
                  bg: ProfileTokens.blueSoft,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  value: '12',
                  label: 'Chuỗi ôn tập (ngày)',
                  valueColor: ProfileTokens.purple,
                  bg: ProfileTokens.purpleSoft,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          _SectionCard(
            title: 'Thời gian đọc tuần này',
            trailing: const Icon(Icons.calendar_today_outlined, size: 18, color: ProfileTokens.subText),
            child: const SizedBox(height: 190, child: _WeeklyBarChart()),
          ),

          const SizedBox(height: 12),
          _SectionCard(
            title: 'Sách đã đọc theo tháng',
            child: const SizedBox(height: 170, child: _MonthlyLineChart()),
          ),

          const SizedBox(height: 12),
          const _GoalCard(),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ProfileTokens.card,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900))),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
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
    return CustomPaint(
      painter: _BarPainter(values: const [50, 60, 35, 90, 75, 120, 105]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 14),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _AxisLabel('T2'), _AxisLabel('T3'), _AxisLabel('T4'),
              _AxisLabel('T5'), _AxisLabel('T6'), _AxisLabel('T7'), _AxisLabel('CN'),
            ],
          ),
        ),
      ),
    );
  }
}

class _AxisLabel extends StatelessWidget {
  final String t;
  const _AxisLabel(this.t);

  @override
  Widget build(BuildContext context) {
    return Text(t, style: const TextStyle(fontSize: 11, color: ProfileTokens.subText));
  }
}

class _BarPainter extends CustomPainter {
  final List<double> values;
  const _BarPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = ProfileTokens.primary..style = PaintingStyle.fill;
    final grid = Paint()..color = ProfileTokens.divider..strokeWidth = 1;

    // grid
    for (int i = 0; i <= 4; i++) {
      final y = (size.height - 28) * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final maxV = values.reduce((a, b) => a > b ? a : b);
    final usableH = size.height - 34;
    final barW = size.width / (values.length * 1.6);
    final gap = barW * 0.6;

    double x = gap;
    for (final v in values) {
      final h = (v / maxV) * usableH;
      final r = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, usableH - h, barW, h),
        const Radius.circular(6),
      );
      canvas.drawRRect(r, paint);
      x += barW + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter oldDelegate) => false;
}

class _MonthlyLineChart extends StatelessWidget {
  const _MonthlyLineChart();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LinePainter(values: const [5, 7, 6, 9, 8, 10]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 12),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _AxisLabel('T1'), _AxisLabel('T2'), _AxisLabel('T3'),
              _AxisLabel('T4'), _AxisLabel('T5'), _AxisLabel('T6'),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<double> values;
  const _LinePainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = ProfileTokens.divider..strokeWidth = 1;
    final line = Paint()..color = ProfileTokens.blue..strokeWidth = 3..style = PaintingStyle.stroke;
    final dot = Paint()..color = ProfileTokens.blue..style = PaintingStyle.fill;

    for (int i = 0; i <= 3; i++) {
      final y = (size.height - 26) * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final maxV = values.reduce((a, b) => a > b ? a : b);
    final minV = values.reduce((a, b) => a < b ? a : b);
    final usableH = size.height - 30;

    final dx = size.width / (values.length - 1);
    Offset p(int i) {
      final v = values[i];
      final t = (v - minV) / ((maxV - minV) == 0 ? 1 : (maxV - minV));
      final y = usableH - t * usableH;
      return Offset(i * dx, y);
    }

    final path = Path()..moveTo(p(0).dx, p(0).dy);
    for (int i = 1; i < values.length; i++) {
      path.lineTo(p(i).dx, p(i).dy);
    }
    canvas.drawPath(path, line);

    for (int i = 0; i < values.length; i++) {
      canvas.drawCircle(p(i), 5, dot);
      canvas.drawCircle(p(i), 8, Paint()..color = Colors.white);
      canvas.drawCircle(p(i), 5, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) => false;
}

class _GoalCard extends StatelessWidget {
  const _GoalCard();

  @override
  Widget build(BuildContext context) {
    const done = 50;
    const total = 60;

    return Container(
      decoration: BoxDecoration(
        color: ProfileTokens.card,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mục tiêu đọc sách', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(child: Text('Mục tiêu năm 2025', style: TextStyle(color: ProfileTokens.subText))),
              Text('$done/$total cuốn', style: TextStyle(color: ProfileTokens.primary, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: done / total,
              backgroundColor: ProfileTokens.divider,
              valueColor: const AlwaysStoppedAnimation(ProfileTokens.primary),
            ),
          ),
          const SizedBox(height: 12),
          const _GoalRow(left: 'Còn lại', right: '10 cuốn'),
          const _GoalRow(left: 'Trung bình/tháng', right: '8.3 cuốn'),
          const _GoalRow(left: 'Dự kiến hoàn thành', right: 'Tháng 12, 2025', rightColor: ProfileTokens.primary),
        ],
      ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(child: Text(left, style: const TextStyle(color: ProfileTokens.subText))),
          Text(right, style: TextStyle(color: rightColor ?? ProfileTokens.text, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
