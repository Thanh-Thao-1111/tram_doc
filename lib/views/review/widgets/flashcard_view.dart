import 'package:flutter/material.dart';

class FlashcardView extends StatelessWidget {
  const FlashcardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: const Center(child: Text("Mặt trước thẻ (Câu hỏi)")),
    );
  }
}