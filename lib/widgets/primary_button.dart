import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label, style: const TextStyle(fontWeight: FontWeight.bold));

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: outlined
          ? OutlinedButton(onPressed: loading ? null : onPressed, child: child)
          : FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: loading ? null : onPressed,
              child: child,
            ),
    );
  }
}
