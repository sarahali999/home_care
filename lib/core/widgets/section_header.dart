import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAction;
  final String actionText;

  const SectionHeader({
    super.key,
    required this.title,
    this.onAction,
    this.actionText = 'عرض الكل',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: onAction,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0D9488),
              fontWeight: FontWeight.w600,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.5,
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}

