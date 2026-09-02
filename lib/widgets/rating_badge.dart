import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RatingBadge extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double fontSize;
  final bool isCompact;

  const RatingBadge({
    super.key,
    required this.rating,
    this.reviewCount,
    this.fontSize = 12,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 8,
        vertical: isCompact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32), // High rating green
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
          const SizedBox(width: 3),
          Icon(
            Icons.star,
            color: Colors.white,
            size: fontSize + 1,
          ),
          if (reviewCount != null && !isCompact) ...[
            const SizedBox(width: 4),
            Text(
              '($reviewCount)',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: fontSize - 1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class VegNonVegTag extends StatelessWidget {
  final bool isVeg;
  final double size;

  const VegNonVegTag({
    super.key,
    required this.isVeg,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    final color = isVeg ? AppColors.vegGreen : AppColors.nonVegRed;
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
