import 'package:flutter/material.dart';

class LibraryTabBar extends StatelessWidget {
  final TabController controller;

  const LibraryTabBar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      indicatorWeight: 3,
      indicatorColor: Colors.black,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      tabs: const [
        Tab(text: 'Muốn đọc'),
        Tab(text: 'Đang đọc'),
        Tab(text: 'Đã đọc'),
      ],
    );
  }
}
