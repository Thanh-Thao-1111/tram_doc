import 'package:flutter/material.dart';
import 'community_tokens.dart';

class StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final Color bg;

  const StatTile({
    super.key,
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
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: CommunityTokens.subText)),
        ],
      ),
    );
  }
}
