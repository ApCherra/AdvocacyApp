import 'package:flutter/material.dart';

class EmoticonFace extends StatelessWidget {
  final String emoticonFace;

  const EmoticonFace({
    super.key,
    required this.emoticonFace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 232,
      width: 232,
      decoration: BoxDecoration(
        color: Colors.green[300]!,
        borderRadius: BorderRadius.circular(14),

      ),
      padding: const EdgeInsets.all(12),
      child: Text(
        emoticonFace,
        style: const TextStyle(
          fontSize: 40,
        ),
      ),
    );
  }
}
