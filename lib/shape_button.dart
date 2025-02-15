import 'package:flutter/material.dart';

class ShapeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  ShapeButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.black),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
