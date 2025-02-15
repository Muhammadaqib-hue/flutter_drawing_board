import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/arrow_data.dart';
import 'package:flutter_drawing_board/drawing_board_ui.dart';
import 'package:flutter_drawing_board/shape_data.dart';
import 'package:flutter_drawing_board/stroke.dart';
import 'package:flutter_drawing_board/text_data.dart';

class DrawingPainter extends CustomPainter {
  List<Stroke> strokes;
  List<Offset> currentStrokePoints;
  Color currentColor;
  double currentStrokeWidth;
  List<TextData> texts;
  List<ArrowData> arrows;
  List<ShapeData> shapes;
  Offset? shapeStart;
  Offset? shapeEnd;
  ShapeType? selectedShape;

  DrawingPainter({
    required this.strokes,
    required this.currentStrokePoints,
    required this.currentColor,
    required this.currentStrokeWidth,
    required this.texts,
    required this.arrows,
    required this.shapes,
    this.shapeStart,
    this.shapeEnd,
    this.selectedShape,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes) {
      Paint paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < stroke.points.length - 1; i++) {
        if (stroke.points[i] != null && stroke.points[i + 1] != null) {
          canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
        }
      }
    }

    if (currentStrokePoints.isNotEmpty) {
      Paint currentPaint = Paint()
        ..color = currentColor
        ..strokeWidth = currentStrokeWidth
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < currentStrokePoints.length - 1; i++) {
        if (currentStrokePoints[i] != null &&
            currentStrokePoints[i + 1] != null) {
          canvas.drawLine(
              currentStrokePoints[i], currentStrokePoints[i + 1], currentPaint);
        }
      }
    }

    for (var textData in texts) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: textData.text,
          style: TextStyle(
            color: textData.color,
            fontSize: 24,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, textData.position);
    }

    for (var arrow in arrows) {
      Paint arrowPaint = Paint()
        ..color = arrow.color
        ..strokeWidth = arrow.strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(arrow.start, arrow.end, arrowPaint);

      double angle = (arrow.end - arrow.start).direction;
      double arrowheadLength = 15.0;
      canvas.save();
      canvas.translate(arrow.end.dx, arrow.end.dy);
      canvas.rotate(angle);
      canvas.drawPath(
        Path()
          ..moveTo(0, 0)
          ..lineTo(-arrowheadLength, -arrowheadLength / 2)
          ..lineTo(-arrowheadLength, arrowheadLength / 2)
          ..close(),
        arrowPaint,
      );
      canvas.restore();
    }

    for (var shape in shapes) {
      Paint shapePaint = Paint()
        ..color = shape.color
        ..strokeWidth = shape.strokeWidth
        ..style = PaintingStyle.stroke;

      switch (shape.shapeType) {
        case ShapeType.rectangle:
          canvas.drawRect(Rect.fromPoints(shape.start, shape.end), shapePaint);
          break;
        case ShapeType.circle:
          double radius = (shape.end - shape.start).distance / 2;
          canvas.drawCircle(
              Offset((shape.start.dx + shape.end.dx) / 2,
                  (shape.start.dy + shape.end.dy) / 2),
              radius,
              shapePaint);
          break;
        case ShapeType.line:
          canvas.drawLine(shape.start, shape.end, shapePaint);
          break;
        case ShapeType.triangle:
          Path trianglePath = Path()
            ..moveTo(shape.start.dx, shape.end.dy)
            ..lineTo(shape.end.dx, shape.end.dy)
            ..lineTo((shape.start.dx + shape.end.dx) / 2, shape.start.dy)
            ..close();
          canvas.drawPath(trianglePath, shapePaint);
          break;
      }
    }

    if (shapeStart != null && shapeEnd != null && selectedShape != null) {
      Paint tempShapePaint = Paint()
        ..color = currentColor
        ..strokeWidth = currentStrokeWidth
        ..style = PaintingStyle.stroke;

      switch (selectedShape!) {
        case ShapeType.rectangle:
          canvas.drawRect(
              Rect.fromPoints(shapeStart!, shapeEnd!), tempShapePaint);
          break;
        case ShapeType.circle:
          double radius = (shapeEnd! - shapeStart!).distance / 2;
          canvas.drawCircle(
              Offset((shapeStart!.dx + shapeEnd!.dx) / 2,
                  (shapeStart!.dy + shapeEnd!.dy) / 2),
              radius,
              tempShapePaint);
          break;
        case ShapeType.line:
          canvas.drawLine(shapeStart!, shapeEnd!, tempShapePaint);
          break;
        case ShapeType.triangle:
          Path trianglePath = Path()
            ..moveTo(shapeStart!.dx, shapeEnd!.dy)
            ..lineTo(shapeEnd!.dx, shapeEnd!.dy)
            ..lineTo((shapeStart!.dx + shapeEnd!.dx) / 2, shapeStart!.dy)
            ..close();
          canvas.drawPath(trianglePath, tempShapePaint);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
