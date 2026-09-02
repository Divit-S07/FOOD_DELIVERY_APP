import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final double height;
  final bool isCompact;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.height = 36,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: height, minHeight: height),
            icon: Icon(
              quantity == 1 ? Icons.delete_outline : Icons.remove,
              size: isCompact ? 16 : 18,
              color: AppColors.primary,
            ),
            onPressed: () {
              if (quantity > 0) {
                onChanged(quantity - 1);
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '$quantity',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isCompact ? 14 : 16,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: height, minHeight: height),
            icon: Icon(
              Icons.add,
              size: isCompact ? 16 : 18,
              color: AppColors.primary,
            ),
            onPressed: () {
              onChanged(quantity + 1);
            },
          ),
        ],
      ),
    );
  }
}
