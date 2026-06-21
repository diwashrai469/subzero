import 'package:flutter/material.dart';
import 'package:subzero/feature/login/presentation/constant/auth_constants.dart';

class AppleGlyph extends StatelessWidget {
  const AppleGlyph({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.apple, size: size, color: AuthPalette.bgTop);
  }
}

class GoogleGlyph extends StatelessWidget {
  const GoogleGlyph({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _GoogleGlyphPainter()),
    );
  }
}

class _GoogleGlyphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final iconSize = size.width;
    final strokeWidth = iconSize * 0.22;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      iconSize - strokeWidth,
      iconSize - strokeWidth,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, -0.35, 1.70, false, paint);

    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, 1.35, 1.50, false, paint);

    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, 2.85, 1.20, false, paint);

    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, 4.05, 1.50, false, paint);

    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        iconSize * 0.50,
        iconSize * 0.42,
        iconSize * 0.46,
        iconSize * 0.16,
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
