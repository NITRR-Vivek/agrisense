import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color borderColor;
  final VoidCallback onPressed;
  final double width;

  const CustomFloatingActionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.borderColor,
    required this.onPressed,
    this.width = 160.0, // Default width
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 48,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: borderColor, width: 2.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(icon, color: borderColor),
            const SizedBox(width: 8.0),
            Text(
              text,
              style: TextStyle(color: borderColor),
            ),
          ],
        ),
      ),
    );
  }
}