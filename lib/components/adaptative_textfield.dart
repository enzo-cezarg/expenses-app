import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AdaptativeTextfield extends StatelessWidget {
  const AdaptativeTextfield({
    required this.controller,
    required this.label,
    required this.onSubmit,
    this.keyboardType,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final Function(String) onSubmit;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
            padding: const EdgeInsets.only(
              bottom: 15,
            ),
            child: CupertinoTextField(
              controller: controller,
              onSubmitted: onSubmit,
              placeholder: label,
              padding: EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 12,
              ),
            ),
          )
        : TextField(
            controller: controller,
            keyboardType: keyboardType ?? TextInputType.text,
            onSubmitted: onSubmit,
            decoration: InputDecoration(
              labelText: label,
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
          );
  }
}
