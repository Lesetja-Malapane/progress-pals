import 'package:flutter/material.dart';
import 'package:progress_pals/core/theme/app_colors.dart';

extension ThemeExtension on BuildContext {
  /// Get theme-aware background color
  Color get themeBackground {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColors.darkBackground
        : AppColors.background;
  }

  /// Get theme-aware surface color
  Color get themeSurface {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColors.darkSurface
        : AppColors.surface;
  }

  /// Get theme-aware surface muted color
  Color get themeSurfaceMuted {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColors.darkSurfaceMuted
        : AppColors.surfaceMuted;
  }

  /// Get theme-aware text primary color
  Color get themeTextPrimary {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
  }

  /// Get theme-aware text secondary color
  Color get themeTextSecondary {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
  }

  /// Get theme-aware text disabled color
  Color get themeTextDisabled {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColors.darkTextDisabled
        : AppColors.textDisabled;
  }

  /// Get theme-aware divider color
  Color get themeDivider {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColors.darkDivider
        : AppColors.divider;
  }

  /// Check if dark mode is enabled
  bool get isDarkMode {
    return Theme.of(this).brightness == Brightness.dark;
  }

  Color get error {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColors.error
        : AppColors.error;
  }
}
