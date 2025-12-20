import 'package:flutter/material.dart';
import 'profile_tokens.dart';

class DangerTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const DangerTile({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ProfileTokens.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFEE2E2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.logout, color: Color(0xFFEF4444)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFFEF4444),
          ),
        ),
      ),
    );
  }
}
