import 'package:flutter/material.dart';

enum EarStyle { round, pointy, long, none }

enum FaceMark { none, whiskers, blush, beak }

class CuteAvatarData {
  final int id;
  final Color background;
  final EarStyle earStyle;
  final FaceMark mark;

  const CuteAvatarData({
    required this.id,
    required this.background,
    this.earStyle = EarStyle.round,
    this.mark = FaceMark.none,
  });
}

/// كتالوج كل الأشكال المتاحة للاختيار — ضيف/شيل/غيّر ألوان براحتك هنا
const List<CuteAvatarData> kCuteAvatars = [
  CuteAvatarData(id: 0, background: Color(0xFFF2C9A5), mark: FaceMark.blush), // hamster
  CuteAvatarData(id: 1, background: Color(0xFFE8C99B)), // bear
  CuteAvatarData(id: 2, background: Color(0xFFE4D9F0), earStyle: EarStyle.pointy, mark: FaceMark.whiskers), // cat
  CuteAvatarData(id: 3, background: Color(0xFFCDEAF5), earStyle: EarStyle.long), // bunny
  CuteAvatarData(id: 4, background: Color(0xFFF3F3F3)), // panda
  CuteAvatarData(id: 5, background: Color(0xFFF6C9D2), earStyle: EarStyle.pointy, mark: FaceMark.whiskers), // pink cat
  CuteAvatarData(id: 6, background: Color(0xFF3A3A3A), earStyle: EarStyle.pointy, mark: FaceMark.whiskers), // dark cat
  CuteAvatarData(id: 7, background: Color(0xFFF8D46B), earStyle: EarStyle.none, mark: FaceMark.beak), // chick
  CuteAvatarData(id: 8, background: Color(0xFFE99B6B), earStyle: EarStyle.none), // fox
];

CuteAvatarData avatarById(int id) =>
    kCuteAvatars.firstWhere((a) => a.id == id, orElse: () => kCuteAvatars.first);

class CuteAvatar extends StatelessWidget {
  final CuteAvatarData data;
  final double size;
  final bool selected;

  const CuteAvatar({
    super.key,
    required this.data,
    this.size = 48,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: selected
            ? Border.all(color: Colors.orangeAccent, width: 2)
            : null,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: _CuteFacePainter(data),
      ),
    );
  }
}

class _CuteFacePainter extends CustomPainter {
  final CuteAvatarData data;
  _CuteFacePainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final bgPaint = Paint()..color = data.background;
    final blackPaint = Paint()..color = Colors.black87;
    final radius = s * 0.26;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    // آذان (بترسم الأول عشان تبان وراء الجسم)
    switch (data.earStyle) {
      case EarStyle.round:
        canvas.drawCircle(Offset(s * 0.18, s * 0.14), s * 0.14, bgPaint);
        canvas.drawCircle(Offset(s * 0.82, s * 0.14), s * 0.14, bgPaint);
        break;
      case EarStyle.pointy:
        _drawTriangle(canvas, bgPaint, Offset(s * 0.2, 0), s * 0.16);
        _drawTriangle(canvas, bgPaint, Offset(s * 0.8, 0), s * 0.16);
        break;
      case EarStyle.long:
        canvas.drawOval(
          Rect.fromCenter(center: Offset(s * 0.28, -s * 0.05), width: s * 0.14, height: s * 0.32),
          bgPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(center: Offset(s * 0.72, -s * 0.05), width: s * 0.14, height: s * 0.32),
          bgPaint,
        );
        break;
      case EarStyle.none:
        break;
    }

    // الجسم (المربع الدائري) فوق الآذان
    canvas.drawRRect(rrect, bgPaint);

    // العينين
    canvas.drawCircle(Offset(s * 0.36, s * 0.5), s * 0.045, blackPaint);
    canvas.drawCircle(Offset(s * 0.64, s * 0.5), s * 0.045, blackPaint);

    // العلامة المميزة (شوارب/خدود/منقار)
    switch (data.mark) {
      case FaceMark.blush:
        final blushPaint = Paint()
          ..color = Colors.pinkAccent.withValues(alpha: 0.5);
        canvas.drawCircle(Offset(s * 0.28, s * 0.62), s * 0.06, blushPaint);
        canvas.drawCircle(Offset(s * 0.72, s * 0.62), s * 0.06, blushPaint);
        break;
      case FaceMark.whiskers:
        final whiskerPaint = Paint()
          ..color = Colors.black45
          ..strokeWidth = 1.2;
        for (final dy in [-0.04, 0.0, 0.04]) {
          canvas.drawLine(
            Offset(s * 0.05, s * (0.58 + dy)),
            Offset(s * 0.24, s * (0.58 + dy)),
            whiskerPaint,
          );
          canvas.drawLine(
            Offset(s * 0.76, s * (0.58 + dy)),
            Offset(s * 0.95, s * (0.58 + dy)),
            whiskerPaint,
          );
        }
        break;
      case FaceMark.beak:
        final beakPaint = Paint()..color = Colors.orange;
        _drawTriangle(canvas, beakPaint, Offset(s * 0.5, s * 0.56), s * 0.1, pointDown: true);
        break;
      case FaceMark.none:
        break;
    }
  }

  void _drawTriangle(Canvas canvas, Paint paint, Offset top, double width, {bool pointDown = false}) {
    final path = Path();
    if (!pointDown) {
      path
        ..moveTo(top.dx - width / 2, top.dy + width)
        ..lineTo(top.dx + width / 2, top.dy + width)
        ..lineTo(top.dx, top.dy);
    } else {
      path
        ..moveTo(top.dx - width / 2, top.dy)
        ..lineTo(top.dx + width / 2, top.dy)
        ..lineTo(top.dx, top.dy + width);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CuteFacePainter oldDelegate) =>
      oldDelegate.data != data;
}