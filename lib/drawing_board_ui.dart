import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/arrow_data.dart';
import 'package:flutter_drawing_board/color_button.dart';
import 'package:flutter_drawing_board/drawing_painter.dart';
import 'package:flutter_drawing_board/shape_button.dart';
import 'package:flutter_drawing_board/shape_data.dart';
import 'package:flutter_drawing_board/stroke.dart';
import 'package:flutter_drawing_board/stroke_button.dart';
import 'package:flutter_drawing_board/text_data.dart';
import 'package:flutter_drawing_board/tool_bar_button.dart';

class DrawingBoardUI extends StatefulWidget {
  @override
  _DrawingBoardUIState createState() => _DrawingBoardUIState();
}

enum ShapeType { rectangle, circle, line, triangle }

class _DrawingBoardUIState extends State<DrawingBoardUI> {
  String? activeBar;
  List<Stroke> strokes = [];
  List<Offset> currentStrokePoints = [];
  bool isDrawing = false;
  double currentStrokeWidth = 4.0;
  Color currentColor = Colors.black;
  List<TextData> texts = [];
  List<ArrowData> arrows = [];
  List<ShapeData> shapes = [];
  ShapeType? selectedShape;
  Offset? shapeStart;
  Offset? shapeEnd;

  void toggleBar(String bar) {
    setState(() {
      activeBar = activeBar == bar ? null : bar;
      selectedShape = null;
    });
  }

  void selectShape(ShapeType shape) {
    setState(() {
      selectedShape = shape;
      activeBar = 'shape';
    });
  }

  void startDrawing(Offset point) {
    setState(() {
      isDrawing = true;
      if (activeBar == 'pen') {
        currentStrokePoints = [];
        currentStrokePoints.add(point);
      } else if (activeBar == 'shape') {
        shapeStart = point;
        shapeEnd = point;
      } else if (activeBar == 'arrow') {
        currentStrokePoints = [];
        currentStrokePoints.add(point);
      }
    });
  }

  void updateDrawing(Offset point) {
    if (isDrawing) {
      setState(() {
        if (activeBar == 'pen') {
          currentStrokePoints.add(point);
        } else if (activeBar == 'shape') {
          shapeEnd = point;
        } else if (activeBar == 'arrow') {
          currentStrokePoints.add(point);
        }
      });
    }
  }

  void stopDrawing() {
    setState(() {
      isDrawing = false;

      if (activeBar == 'pen') {
        strokes.add(Stroke(
          points: List.from(currentStrokePoints),
          color: currentColor,
          strokeWidth: currentStrokeWidth,
        ));
        currentStrokePoints.clear();
      } else if (activeBar == 'shape' &&
          shapeStart != null &&
          shapeEnd != null) {
        shapes.add(ShapeData(
          shapeType: selectedShape!,
          start: shapeStart!,
          end: shapeEnd!,
          color: currentColor,
          strokeWidth: currentStrokeWidth,
        ));
        shapeStart = null;
        shapeEnd = null;
      } else if (activeBar == 'arrow') {
        if (currentStrokePoints.length >= 2) {
          addArrow(
            currentStrokePoints.first,
            currentStrokePoints.last,
          );
          currentStrokePoints.clear();
        }
      }
    });
  }

  void clearDrawing() {
    setState(() {
      strokes.clear();
      texts.clear();
      arrows.clear();
      shapes.clear();
    });
  }

  void setStrokeWidth(double width) {
    setState(() {
      currentStrokeWidth = width;
    });
  }

  void setColor(Color color) {
    setState(() {
      currentColor = color;
    });
  }

  void addText(Offset position, String text) {
    setState(() {
      texts.add(TextData(
        text: text,
        position: position,
        color: currentColor,
      ));
    });
  }

  void addArrow(Offset start, Offset end) {
    setState(() {
      arrows.add(ArrowData(
        start: start,
        end: end,
        color: currentColor,
        strokeWidth: currentStrokeWidth,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    ToolbarButton(
                      icon: Icons.brush,
                      label: "Pen",
                      onTap: () => toggleBar('pen'),
                    ),
                    ToolbarButton(
                      icon: Icons.crop_square,
                      label: "Shape",
                      onTap: () => toggleBar('shape'),
                    ),
                    ToolbarButton(
                      icon: Icons.circle,
                      label: "Stroke",
                      onTap: () => toggleBar('stroke'),
                    ),
                    ToolbarButton(
                      icon: Icons.palette,
                      label: "Color",
                      onTap: () => toggleBar('color'),
                    ),
                    ToolbarButton(
                      icon: Icons.text_fields,
                      label: "Text",
                      onTap: () => toggleBar('text'),
                    ),
                    ToolbarButton(
                      icon: Icons.arrow_forward,
                      label: "Arrow",
                      onTap: () => toggleBar('arrow'),
                    ),
                    ToolbarButton(
                      icon: Icons.clear,
                      label: "Clear",
                      onTap: clearDrawing,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTapDown: (details) {
                    if (activeBar == 'text') {
                      _showTextDialog(details.localPosition);
                    }
                  },
                  onPanStart: (details) {
                    if (activeBar == 'pen' ||
                        activeBar == 'shape' ||
                        activeBar == 'arrow') {
                      startDrawing(details.localPosition);
                    }
                  },
                  onPanUpdate: (details) {
                    if (activeBar == 'pen' ||
                        activeBar == 'shape' ||
                        activeBar == 'arrow') {
                      updateDrawing(details.localPosition);
                    }
                  },
                  onPanEnd: (details) {
                    if (activeBar == 'pen' ||
                        activeBar == 'shape' ||
                        activeBar == 'arrow') {
                      stopDrawing();
                    }
                  },
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: DrawingPainter(
                      strokes: strokes,
                      currentStrokePoints: currentStrokePoints,
                      currentColor: currentColor,
                      currentStrokeWidth: currentStrokeWidth,
                      texts: texts,
                      arrows: arrows,
                      shapes: shapes,
                      shapeStart: shapeStart,
                      shapeEnd: shapeEnd,
                      selectedShape: selectedShape,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (activeBar == 'stroke')
            Positioned(
              bottom: 0,
              left: 80,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StrokeButton(
                      label: "2",
                      onTap: () => setStrokeWidth(2),
                    ),
                    StrokeButton(
                      label: "4",
                      onTap: () => setStrokeWidth(4),
                    ),
                    StrokeButton(
                      label: "6",
                      onTap: () => setStrokeWidth(6),
                    ),
                    StrokeButton(
                      label: "8",
                      onTap: () => setStrokeWidth(8),
                    ),
                  ],
                ),
              ),
            ),
          if (activeBar == 'color')
            Positioned(
              bottom: 0,
              left: 80,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ColorButton(
                      color: Colors.black,
                      onTap: () => setColor(Colors.black),
                    ),
                    ColorButton(
                      color: Colors.red,
                      onTap: () => setColor(Colors.red),
                    ),
                    ColorButton(
                      color: Colors.blue,
                      onTap: () => setColor(Colors.blue),
                    ),
                    ColorButton(
                      color: Colors.green,
                      onTap: () => setColor(Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          if (activeBar == 'shape')
            Positioned(
              bottom: 0,
              left: 80,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ShapeButton(
                      icon: Icons.crop_square,
                      label: "Rectangle",
                      onTap: () => selectShape(ShapeType.rectangle),
                    ),
                    ShapeButton(
                      icon: Icons.circle,
                      label: "Circle",
                      onTap: () => selectShape(ShapeType.circle),
                    ),
                    ShapeButton(
                      icon: Icons.linear_scale,
                      label: "Line",
                      onTap: () => selectShape(ShapeType.line),
                    ),
                    ShapeButton(
                      icon: Icons.change_history,
                      label: "Triangle",
                      onTap: () => selectShape(ShapeType.triangle),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showTextDialog(Offset position) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Text"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Type something..."),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  addText(position, controller.text);
                }
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
