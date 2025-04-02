import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class AdaptativeDatePicker extends StatelessWidget {
  const AdaptativeDatePicker({
    required this.selectedDate,
    required this.onDateChanged,
    super.key,
  });

  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color.fromARGB(255, 11, 19, 43), // Cor do destaque da seleção
            colorScheme: ColorScheme.light(
              primary: Color.fromARGB(255, 11, 19, 43), // Cor do círculo do dia selecionado
              onPrimary: Colors.white, // Cor do texto dentro do círculo
              surface: Color.fromARGB(255, 237, 242, 244), // Fundo do calendário
              onSurface: Colors.black, // Cor dos textos normais
            ),
            dialogBackgroundColor: Colors.white, // Cor do fundo do DatePicker
          ),
          child: child!,
        );
      },
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      onDateChanged(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? SizedBox(
            height: 180,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              minimumDate: DateTime(2024),
              maximumDate: DateTime.now(),
              onDateTimeChanged: onDateChanged,
            ),
          )
        : SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Text('Date: ${DateFormat('MMM d, y', 'en_US').format(selectedDate)}'),
                ),
                TextButton(
                  onPressed: () => _showDatePicker(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 11, 19, 43),
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: Text('Select Date'),
                )
              ],
            ),
          );
  }
}
