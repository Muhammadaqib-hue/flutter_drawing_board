import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/drawing_board_ui.dart';

class ShapeData {
  ShapeType shapeType;
  Offset start;
  Offset end;
  Color color;
  double strokeWidth;

  ShapeData({
    required this.shapeType,
    required this.start,
    required this.end,
    required this.color,
    required this.strokeWidth,
  });
}
