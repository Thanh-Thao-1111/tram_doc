import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
        SizedBox(height: 8),
        Text('Alex Nguyen', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Tham gia 2024', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
