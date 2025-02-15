import 'package:flutter/material.dart';

class Stroke {
  List<Offset> points;
  Color color;
  double strokeWidth;

  Stroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });
}
