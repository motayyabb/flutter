import 'package:flutter/material.dart';

class RepeatContainerCode extends StatelessWidget {
  final String text;
  final Color color;
  final Widget? child;
  final VoidCallback? onPressed;
  final IconData? icon;
  final TextStyle? textStyle;

  const RepeatContainerCode({
    required this.text,
    required this.color,
    this.child,
    this.onPressed,
    this.icon,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[700]!
                : Colors.grey[400]!,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: child ??
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    size: 50,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                const SizedBox(height: 10),
                Text(
                  text,
                  style: textStyle ??
                      TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                        fontSize: 16,
                      ),
                ),
              ],
            ),
      ),
    );
  }
}
