import 'package:flutter/material.dart';

class RepeatContainerCode extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon; // Optional icon property
  final VoidCallback? onPressed; // Optional onPressed callback

  const RepeatContainerCode({
    Key? key,
    required this.text,
    required this.color,
    this.icon,
    this.onPressed, // New onPressed property
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Trigger the callback on tap
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[700]!, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: Colors.white,
                size: 40,
              ),
            if (icon != null) SizedBox(height: 10), // Space between icon and text
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
