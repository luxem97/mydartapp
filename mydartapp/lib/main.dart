import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Standard Dartboard Reihenfolge (im Uhrzeigersinn, Start oben bei 20)
final dartSegments = [
  20,
  1,
  18,
  4,
  13,
  6,
  10,
  15,
  2,
  17,
  3,
  19,
  7,
  16,
  8,
  11,
  14,
  9,
  12,
  5
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dartboard Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DartBoardScreen(),
    );
  }
}

class DartBoardScreen extends StatefulWidget {
  const DartBoardScreen({super.key});

  @override
  State<DartBoardScreen> createState() => _DartBoardScreenState();
}

class _DartBoardScreenState extends State<DartBoardScreen> {
  int currentScore = 0;

  void _onTapDown(TapDownDetails details, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Offset tapPosition = details.localPosition;
    final dx = tapPosition.dx - center.dx;
    final dy = tapPosition.dy - center.dy;
    final distance = sqrt(dx * dx + dy * dy);
    final angle = atan2(dy, dx); // rad

    // Segmentwinkel
    final double segmentAngle = 2 * pi / 20;
    // We align so that angle = -pi/2 (top) corresponds to the center of segment 20.
    // Add pi/2 to shift top to 0, then add segmentAngle/2 to align the center.
    double adjustedAngle = angle + pi / 2 + (segmentAngle / 2);
    if (adjustedAngle < 0) {
      adjustedAngle += 2 * pi;
    }
    int segmentIndex = (adjustedAngle / (2 * pi) * 20).floor();
    if (segmentIndex == 20) segmentIndex = 0; // wrap around if needed
    final segmentValue = dartSegments[segmentIndex];

    // Radien definieren (Beispielwerte)
    final double boardRadius = min(size.width, size.height) / 2;
    final bullseyeRadius = boardRadius * 0.075; // 7.5%
    final bullRadius = boardRadius * 0.20; // 20%
    final tripleRingInner = boardRadius * 0.5; // 50%
    final tripleRingOuter = tripleRingInner + 0.05 * boardRadius; // 55%
    final doubleRingInner = boardRadius * 0.9; // 90%
    final doubleRingOuter = doubleRingInner + 0.05 * boardRadius; //95%

    int hitScore = 0;
    if (distance <= bullseyeRadius) {
      // Bullseye (50)
      hitScore = 50;
    } else if (distance <= bullRadius) {
      // Single Bull (25)
      hitScore = 25;
    } else if (distance > doubleRingOuter) {
      // außerhalb des Boards - 0 Punkte
      hitScore = 0;
    } else {
      // Zwischen Bull und Double:
      if (distance >= tripleRingInner && distance <= tripleRingOuter) {
        // Triple
        hitScore = segmentValue * 3;
      } else if (distance >= doubleRingInner && distance <= doubleRingOuter) {
        // Double
        hitScore = segmentValue * 2;
      } else {
        // Single
        hitScore = segmentValue;
      }
    }

    setState(() {
      currentScore = hitScore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dart Game'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight - 100);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Getroffener Score: $currentScore',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTapDown: (details) => _onTapDown(details, size),
                  child: CustomPaint(
                    size: size,
                    painter: _DartBoardPainter(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DartBoardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // Farben
    final blackPaint = Paint()..color = Colors.black;
    final whitePaint = Paint()..color = Colors.white;
    // Bullseye = rot
    final bullseyePaint = Paint()..color = Colors.red;
    // Bull = grün
    final bullPaint = Paint()..color = Colors.green;
    final greenPaint = Paint()..color = Colors.green;
    final redPaint = Paint()..color = Colors.red;

    // Kreise für Bullseye und Bull
    final bullseyeRadius = radius * 0.075;
    canvas.drawCircle(center, bullseyeRadius, bullseyePaint);

    final bullRadius = radius * 0.20;
    canvas.drawCircle(center, bullRadius, bullPaint);

    // Hintergrund schwarz
    canvas.drawCircle(center, radius, blackPaint);

    final segmentAngle = 2 * pi / 20;
    final tripleRingInner = radius * 0.5;
    final tripleRingOuter = tripleRingInner + 0.05 * radius;
    final doubleRingInner = radius * 0.9;
    final doubleRingOuter = doubleRingInner + 0.05 * radius;

    // Single-Bereiche malen (wechselweise schwarz/weiß)
    for (int i = 0; i < 20; i++) {
      final paint = (i % 2 == 0) ? whitePaint : blackPaint;

      // Single inner Bereich: von bullRadius bis tripleRingInner
      _drawSegment(canvas, center, bullRadius, tripleRingInner,
          i * segmentAngle, segmentAngle, paint);

      // Single äußerer Bereich: von tripleRingOuter bis doubleRingInner
      _drawSegment(canvas, center, tripleRingOuter, doubleRingInner,
          i * segmentAngle, segmentAngle, paint);
    }

    // Triple Ring (rot/grün)
    for (int i = 0; i < 20; i++) {
      final paint = (i % 2 == 0) ? greenPaint : redPaint;
      _drawSegment(canvas, center, tripleRingInner, tripleRingOuter,
          i * segmentAngle, segmentAngle, paint);
    }

    // Double Ring (rot/grün)
    for (int i = 0; i < 20; i++) {
      final paint = (i % 2 == 0) ? greenPaint : redPaint;
      _drawSegment(canvas, center, doubleRingInner, doubleRingOuter,
          i * segmentAngle, segmentAngle, paint);
    }

    // Rahmen ums Board
    final boardOutline = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawCircle(center, radius, boardOutline);

    // Zahlen zeichnen
    // Position zwischen Bull und Triple-Ring:
    final textRadius = (tripleRingInner + bullRadius) / 2;
    for (int i = 0; i < 20; i++) {
      final segmentValue = dartSegments[i];
      final segmentAngle = 2 * pi / 20;
      // For painting, we also want segment 20 at top center.
      // i=0 -> segment 20; its center line should be at top.
      // Start with i*segmentAngle, rotate so 0 is at top (-pi/2), then add half segment to center the text.
      double angle = (i * segmentAngle) - pi / 2 + (segmentAngle / 2);
      if (angle < 0) angle += 2 * pi;
      final textSpan = TextSpan(
        text: segmentValue.toString(),
        style: const TextStyle(
          color: Colors.yellow,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final x = center.dx + textRadius * cos(angle);
      final y = center.dy + textRadius * sin(angle);
      final offset =
          Offset(x - textPainter.width / 2, y - textPainter.height / 2);
      textPainter.paint(canvas, offset);
    }
  }

  void _drawSegment(Canvas canvas, Offset center, double innerRadius,
      double outerRadius, double startAngle, double sweepAngle, Paint paint) {
    final rect = Rect.fromCircle(center: center, radius: outerRadius);
    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(rect, startAngle, sweepAngle, false)
      ..lineTo(center.dx + innerRadius * cos(startAngle + sweepAngle),
          center.dy + innerRadius * sin(startAngle + sweepAngle))
      ..arcTo(Rect.fromCircle(center: center, radius: innerRadius),
          startAngle + sweepAngle, -sweepAngle, false)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
