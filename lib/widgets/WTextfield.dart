import 'package:flutter/material.dart';

class WTextField extends StatelessWidget {
  const WTextField({
    super.key,
    required this.ctl,
    required this.label,
    required this.keyboard,
  });

  final TextEditingController ctl;
  final String label;
  final TextInputType keyboard;


  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      controller: ctl,
      keyboardType: keyboard,
    );
  }

}