import 'package:flutter/material.dart';

class AppBarWrapper extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double fontSize;
  final Color color;
  final TabBar? bottom;
  final double sizeFromHeight;

  const AppBarWrapper({
    super.key,
    required this.title,
    this.color = const Color(0xFF3FAB43),
    this.fontSize = 40,
    this.bottom,
    this.sizeFromHeight = 70
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          centerTitle: true,
          backgroundColor: color,
          bottom: bottom,
          title: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              color: const Color(0xFFEADDC8),
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              shadows: const <Shadow>[
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 10.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}