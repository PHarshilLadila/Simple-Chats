import 'package:flutter/material.dart';

class SmoothBlob extends StatelessWidget {
  final Color color;
  final double height;
  final double width;

  const SmoothBlob({
    super.key,
    required this.color,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CustomPaint(
        painter: _SmoothBlobPainter(color),
      ),
    );
  }
}

class _SmoothBlobPainter extends CustomPainter {
  final Color color;

  _SmoothBlobPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(size.width * 0.5, size.height * 0.05);

    path.cubicTo(
      size.width * 0.85,
      size.height * 0.05,
      size.width * 0.95,
      size.height * 0.35,
      size.width * 0.85,
      size.height * 0.6,
    );

    path.cubicTo(
      size.width * 0.8,
      size.height * 0.9,
      size.width * 0.4,
      size.height * 0.95,
      size.width * 0.25,
      size.height * 0.8,
    );

    path.cubicTo(
      size.width * 0.05,
      size.height * 0.7,
      size.width * 0.05,
      size.height * 0.3,
      size.width * 0.3,
      size.height * 0.2,
    );

    path.cubicTo(
      size.width * 0.4,
      size.height * 0.05,
      size.width * 0.5,
      size.height * 0.05,
      size.width * 0.5,
      size.height * 0.05,
    );

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BlobOne extends StatelessWidget {
  final Color color;
  final double height;
  final double width;

  const BlobOne({
    super.key,
    required this.color,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CustomPaint(
        painter: _BlobOnePainter(color),
      ),
    );
  }
}

class _BlobOnePainter extends CustomPainter {
  final Color color;
  _BlobOnePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.05);

    path.cubicTo(size.width * 0.9, size.height * 0.1, size.width * 0.95,
        size.height * 0.6, size.width * 0.6, size.height * 0.9);

    path.cubicTo(size.width * 0.3, size.height * 1.0, size.width * 0.05,
        size.height * 0.7, size.width * 0.2, size.height * 0.3);

    path.cubicTo(size.width * 0.3, size.height * 0.05, size.width * 0.5,
        size.height * 0.05, size.width * 0.5, size.height * 0.05);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class BlobTwo extends StatelessWidget {
  final Color color;
  final double height;
  final double width;

  const BlobTwo({
    super.key,
    required this.color,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CustomPaint(
        painter: _BlobTwoPainter(color),
      ),
    );
  }
}

class _BlobTwoPainter extends CustomPainter {
  final Color color;
  _BlobTwoPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path();
    path.moveTo(size.width * 0.4, size.height * 0.1);

    path.cubicTo(size.width * 1.0, size.height * 0.2, size.width * 0.9,
        size.height * 0.8, size.width * 0.5, size.height * 0.9);

    path.cubicTo(size.width * 0.1, size.height * 0.85, size.width * 0.0,
        size.height * 0.3, size.width * 0.4, size.height * 0.1);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class BlobThree extends StatelessWidget {
  final Color color;
  final double height;
  final double width;

  const BlobThree({
    super.key,
    required this.color,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CustomPaint(
        painter: _BlobThreePainter(color),
      ),
    );
  }
}

class _BlobThreePainter extends CustomPainter {
  final Color color;
  _BlobThreePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.05);

    path.cubicTo(size.width * 0.85, size.height * 0.05, size.width * 0.95,
        size.height * 0.5, size.width * 0.7, size.height * 0.85);

    path.cubicTo(size.width * 0.4, size.height * 1.0, size.width * 0.05,
        size.height * 0.75, size.width * 0.2, size.height * 0.3);

    path.cubicTo(size.width * 0.3, size.height * 0.05, size.width * 0.5,
        size.height * 0.05, size.width * 0.5, size.height * 0.05);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
