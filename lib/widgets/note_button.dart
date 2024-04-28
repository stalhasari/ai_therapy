import 'package:flutter/material.dart';

class NoteButton extends StatelessWidget {
  const NoteButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal, // Yazı rengi
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25), // Yuvarlak köşeler
        ),
        elevation: 3, // Gölge efekti
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
