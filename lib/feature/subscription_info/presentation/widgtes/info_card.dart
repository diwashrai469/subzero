import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';

/// A card that renders a vertical list of [InfoRow]s with dividers between them.
class InfoCard extends StatelessWidget {
  final List<InfoRow> rows;

  const InfoCard({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: List.generate(rows.length, (i) {
          return Column(
            children: [
              rows[i],
              if (i < rows.length - 1)
                Divider(
                  height: 0.5,
                  thickness: 0.5,
                  indent: 58.w,
                  color: const Color(0xFFF3F4F6),
                ),
            ],
          );
        }),
      ),
    );
  }
}

/// A single row inside [InfoCard].
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Color? valueColor;
  final Widget? trailing;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.valueColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      child: Row(
        children: [
          _IconBox(icon: icon),
          sWidthSpan,
          KText(text: label),
          const Spacer(),
          trailing ??
              KText(
                text: value ?? '',
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black,
              ),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;

  const _IconBox({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(9.r),
      ),
      child: Icon(icon, size: 16.sp, color: const Color(0xFF6B7280)),
    );
  }
}
