import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AdaptativeTextfield extends StatelessWidget {
  const AdaptativeTextfield({
    required this.textController,
    required this.label,
    //required this.submitForm,
    this.keyboardType,
    super.key,
  });

  final TextEditingController textController;
  final String label;
  //final void Function(String)? submitForm;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoTextField(
            controller: textController,
          )
        : TextField(
            controller: textController,
            keyboardType: keyboardType ?? TextInputType.text,
            //onSubmitted: (value) => submitForm,
            decoration: InputDecoration(
              labelText: label,
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
          );
  }
}
