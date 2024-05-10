import 'package:flutter/material.dart';

final class CoaTextField {
  static Padding generateDefault(TextEditingController controller, String hint, {bool secureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        obscureText: secureText,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.amber),
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: hint,
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),
    );
  }

  static Padding generateSecure(TextEditingController controller, String hint) {
    return generateDefault(controller, hint, secureText: true);
  }

}