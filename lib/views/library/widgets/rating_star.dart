import 'package:flutter/material.dart';

class RatingStar extends StatelessWidget {
  final int rating; // Số sao hiện tại (1-5)
  final double size; // Kích thước sao
  final Color activeColor; // Màu sao sáng
  final Function(int)? onRatingChanged; // Hàm callback khi bấm 

  const RatingStar({
    super.key,
    required this.rating,
    this.size = 20,
    this.activeColor = Colors.amber,
    this.onRatingChanged, 
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        bool isSelected = index < rating;
        if (onRatingChanged == null) {
          return Icon(
            Icons.star,
            size: size,
            color: isSelected ? activeColor : Colors.grey[300],
          );
        }
        return IconButton(
          onPressed: () => onRatingChanged!(index + 1),
          iconSize: size,
          padding: EdgeInsets.zero, 
          constraints: const BoxConstraints(), 
          icon: Icon(
            isSelected ? Icons.star : Icons.star_border,
            color: activeColor,
          ),
        );
      }),
    );
  }
}