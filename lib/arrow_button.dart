import 'package:flutter/material.dart';

class ArrowButton extends StatelessWidget {
  final IconData icon;
  final String label;

  ArrowButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.black),
        SizedBox(height: 4),
        Text(label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
