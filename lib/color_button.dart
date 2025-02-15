import 'package:flutter/material.dart';

class ColorButton extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  ColorButton({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color,
          ),
          SizedBox(height: 4),
          Text(color.toString().split('(0x')[1].split(')')[0],
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
