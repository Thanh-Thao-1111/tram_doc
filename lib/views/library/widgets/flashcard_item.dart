import 'package:flutter/material.dart';

class FlashcardItem extends StatelessWidget {
  const FlashcardItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'Mặt trước flashcard',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
