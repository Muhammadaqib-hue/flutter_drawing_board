import 'package:flutter/material.dart';

class StrokeButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  StrokeButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black,
            child: Text(label,
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
          SizedBox(height: 4),
          Text(label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
