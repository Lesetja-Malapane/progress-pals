import 'package:flutter/material.dart';
import 'package:progress_pals/core/theme/app_colors.dart';

class DateBubble extends StatelessWidget {
  final String label;
  final bool isSelected;

  const DateBubble({
    super.key,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.secondary,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}