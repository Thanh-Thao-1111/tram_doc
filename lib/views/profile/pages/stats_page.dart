import 'package:flutter/material.dart';
import '../../../services/stats_service.dart';
import '../widgets/profile_tokens.dart';
import '../widgets/metric_card.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final StatsService _statsService = StatsService();
  
  bool _isLoading = true;
  int _booksRead = 0;
  int _totalBooks = 0;
  int _readingStreak = 0;
  List<int> _weeklyMinutes = List.filled(7, 0);
  List<Map<String, dynamic>> _readBooks = [];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    
    try {
      final stats = await _statsService.getAllStats();
      final weeklyMinutes = await _statsService.getWeeklyReadingMinutes();
      final readBooks = await _statsService.getReadBooks();
      
      if (mounted) {
        setState(() {
          _booksRead = stats['booksRead'] ?? 0;
          _totalBooks = stats['totalBooks'] ?? 0;
          _readingStreak = stats['readingStreak'] ?? 0;
          _weeklyMinutes = weeklyMinutes;
          _readBooks = readBooks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                children: [
                  // Main stats
                  Row(
                    children: [
                      Expanded(
                        child: MetricCard(
                          value: '$_booksRead',
                          label: 'Sách đã đọc',
                          valueColor: ProfileTokens.primary,
                          bg: ProfileTokens.primarySoft,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MetricCard(
                          value: '$_readingStreak',
                          label: 'Chuỗi đọc (ngày)',
                          valueColor: ProfileTokens.orange,
                          bg: ProfileTokens.orangeSoft,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: MetricCard(
                          value: '$_totalBooks',
                          label: 'Tổng số sách',
                          valueColor: ProfileTokens.blue,
                          bg: ProfileTokens.blueSoft,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MetricCard(
                          value: '${_weeklyMinutes.fold(0, (a, b) => a + b)}',
                          label: 'Phút đọc tuần này',
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
                    child: SizedBox(
                      height: 190,
                      child: _WeeklyBarChart(values: _weeklyMinutes.map((e) => e.toDouble()).toList()),
                    ),
                  ),

                  const SizedBox(height: 14),
                  _buildReadingHistory(),
                ],
              ),
            ),
    );
  }

  Widget _buildReadingHistory() {
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
              const Expanded(
                child: Text(
                  'Lịch sử sách đã đọc',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                '$_booksRead cuốn',
                style: const TextStyle(color: ProfileTokens.primary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          if (_readBooks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'Chưa có sách nào được hoàn thành',
                  style: TextStyle(color: ProfileTokens.subText),
                ),
              ),
            )
          else
            ...(_readBooks.take(5).map((book) => _ReadBookItem(
              title: book['title'] ?? '',
              author: book['author'] ?? '',
              imageUrl: book['imageUrl'] ?? '',
              finishedAt: book['finishedAt'],
            ))),
          
          if (_readBooks.length > 5)
            TextButton(
              onPressed: () {}, // TODO: Navigate to full history
              child: Text('Xem tất cả ${_readBooks.length} cuốn'),
            ),
        ],
      ),
    );
  }
}

class _ReadBookItem extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  final DateTime? finishedAt;

  const _ReadBookItem({
    required this.title,
    required this.author,
    required this.imageUrl,
    this.finishedAt,
  });

  String get _formattedDate {
    if (finishedAt == null) return '';
    return '${finishedAt!.day}/${finishedAt!.month}/${finishedAt!.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ProfileTokens.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 40,
              height: 55,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFE5E7EB),
                        child: const Icon(Icons.menu_book, size: 20, color: Colors.white),
                      ),
                    )
                  : Container(
                      color: const Color(0xFFE5E7EB),
                      child: const Icon(Icons.menu_book, size: 20, color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  author,
                  style: const TextStyle(color: ProfileTokens.subText, fontSize: 11),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          if (finishedAt != null)
            Column(
              children: [
                const Icon(Icons.check_circle, color: ProfileTokens.primary, size: 18),
                const SizedBox(height: 2),
                Text(
                  _formattedDate,
                  style: const TextStyle(color: ProfileTokens.subText, fontSize: 10),
                ),
              ],
            ),
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
  final List<double> values;
  
  const _WeeklyBarChart({required this.values});

  @override
  Widget build(BuildContext context) {
    // Ensure we have 7 values
    final chartValues = values.length == 7 ? values : List.filled(7, 0.0);
    
    return CustomPaint(
      painter: _BarPainter(values: chartValues),
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

    final maxV = values.isEmpty ? 1.0 : values.reduce((a, b) => a > b ? a : b);
    final effectiveMax = maxV == 0 ? 1.0 : maxV;
    final usableH = size.height - 34;
    final barW = size.width / (values.length * 1.6);
    final gap = barW * 0.6;

    double x = gap;
    for (final v in values) {
      final h = (v / effectiveMax) * usableH;
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
