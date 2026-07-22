import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/ui_helpers.dart';
import 'package:subzero/common/widgets/k_text.dart';

class AuthButton extends StatefulWidget {
  const AuthButton({
    super.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.isLoading,
    required this.onTap,
    this.borderColor,
  });

  final String label;
  final Widget icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  double _scale = 1.0;

  void _setPressed(bool isPressed) {
    setState(() {
      _scale = isPressed ? 0.97 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.borderColor;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.isLoading ? null : widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          height: 52.h,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(16.r),
            border: borderColor == null
                ? null
                : Border.all(color: borderColor, width: 1),
          ),
          child: Center(
            child: widget.isLoading
                ? _ButtonLoader(color: widget.foregroundColor)
                : _ButtonContent(
                    label: widget.label,
                    icon: widget.icon,
                    foregroundColor: widget.foregroundColor,
                  ),
          ),
        ),
      ),
    );
  }
}

class _ButtonLoader extends StatelessWidget {
  const _ButtonLoader({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20.w,
      height: 20.w,
      child: CircularProgressIndicator(
        strokeWidth: 2.2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.foregroundColor,
  });

  final String label;
  final Widget icon;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        sWidthSpan,
        KText(
          text: label,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: foregroundColor,
        ),
      ],
    );
  }
}
