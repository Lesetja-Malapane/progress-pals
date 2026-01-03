import 'package:flutter/material.dart';
import 'package:progress_pals/core/theme/app_colors.dart';

enum ButtonType { primary, outline }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = type == ButtonType.primary;

    return SizedBox(
      width: double.infinity, // Full width
      height: 56, // Standard mobile button height
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : Colors.transparent,
          elevation: 0,
          side: isPrimary ? null : const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Smooth corners
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isPrimary ? Colors.white : AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}