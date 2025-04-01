import 'package:flutter/material.dart';
import 'adaptative_button.dart';
import 'adaptative_textfield.dart';
import 'adaptative_date_picker.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  const TransactionForm(this.onSubmit, {super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0) {
      return;
    } else {
      widget.onSubmit(title, value, _selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    double keyboardSize = View.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      child: Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: keyboardSize + 10,
          ),
          child: Column(
            children: [
              AdaptativeTextfield(
                controller: _titleController,
                label: 'Title',
                onSubmit: (value) => _submitForm,
              ),
              AdaptativeTextfield(
                controller: _valueController,
                label: 'Value (\$)',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmit: (value) => _submitForm(),
              ),
              AdaptativeDatePicker(
                selectedDate: _selectedDate,
                onDateChanged: (newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AdaptativeButton(
                      label: 'New Transaction',
                      onPressed: _submitForm,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
